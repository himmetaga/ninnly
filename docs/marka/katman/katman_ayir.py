# Himmet'in ikonunu yeniden çizmeden katmanlara ayırır: zemin, mercan, krem.
import sys, cv2, numpy as np
kaynak, cikis = sys.argv[1], sys.argv[2]
img = cv2.imread(kaynak, cv2.IMREAD_COLOR)            # BGR, 2048
img = cv2.resize(img, (1024, 1024), interpolation=cv2.INTER_AREA)
hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
H, S, V = [hsv[..., i].astype(int) for i in range(3)]
mercan = ((H <= 20) | (H >= 170)) & (S >= 70) & (V >= 120)
krem = (S < 70) & (V >= 170)
def temizle(m, kapat=5):
    m = m.astype(np.uint8) * 255
    m = cv2.morphologyEx(m, cv2.MORPH_OPEN, np.ones((3, 3), np.uint8))
    m = cv2.morphologyEx(m, cv2.MORPH_CLOSE, np.ones((kapat, kapat), np.uint8))
    # en büyük parçalar dışındaki gürültüyü at
    n, lab, st, _ = cv2.connectedComponentsWithStats(m)
    keep = np.zeros_like(m)
    for i in range(1, n):
        if st[i, cv2.CC_STAT_AREA] > 2000:
            keep[lab == i] = 255
    return keep
def delik_doldur(m):
    ff = m.copy(); h, w = m.shape
    msk = np.zeros((h + 2, w + 2), np.uint8)
    cv2.floodFill(ff, msk, (0, 0), 255)
    return m | cv2.bitwise_not(ff)
mercan = temizle(mercan); krem = temizle(krem)
on = delik_doldur(mercan | krem)                       # göz çizgisi ve aradaki ince gölge önde kalır
krem = delik_doldur(krem) & on
mercan = on & cv2.bitwise_not(krem)
# kenar pikselleri (yumuşatma halkası) öne katılır: 1 px genişlet
k = np.ones((3, 3), np.uint8)
on2 = cv2.dilate(on, k)
halka = on2 & cv2.bitwise_not(on)
# halka pikselini en yakın sınıfa ver
yakin_krem = cv2.dilate(krem, k)
krem = krem | (halka & yakin_krem)
mercan = (on2 & cv2.bitwise_not(krem))
on = on2
def katman(m):
    rgba = cv2.cvtColor(img, cv2.COLOR_BGR2BGRA)
    rgba[..., 3] = m
    return rgba
# göz: krem içindeki koyu çizgi; kendi katmanına alınır, kremde delik olarak kalır
goz = (krem > 0) & (V < 140)
goz = cv2.dilate(goz.astype(np.uint8) * 255, k)
goz = goz & cv2.erode(krem, np.ones((9, 9), np.uint8))   # yalnız başın içinde, kenar halkası değil
krem_delikli = krem & cv2.bitwise_not(goz)
cv2.imwrite(f"{cikis}/2_mercan.png", katman(mercan))
cv2.imwrite(f"{cikis}/3_krem.png", katman(krem_delikli))
cv2.imwrite(f"{cikis}/4_goz.png", katman(goz))
print("goz piksel:", int((goz > 0).sum()))
zemin = cv2.inpaint(img, cv2.dilate(on, np.ones((7, 7), np.uint8)), 9, cv2.INPAINT_TELEA)
zemin[on == 0] = img[on == 0]                          # önün dışı orijinalle birebir
cv2.imwrite(f"{cikis}/1_zemin.png", zemin)
# doğrulama: katmanlar üst üste = orijinal
bir = zemin.copy()
for m in (mercan, krem_delikli, goz):
    bir[m > 0] = img[m > 0]
fark = np.abs(bir.astype(int) - img.astype(int)).max()
print("birlesim farki (0 olmali):", fark, "on piksel:", int((on > 0).sum()), "krem:", int((krem > 0).sum()), "mercan:", int((mercan > 0).sum()))
# renklendirilmiş mod için gri ön plan (şeffaf zeminde)
gri = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
tint = np.dstack([gri, gri, gri, on])
cv2.imwrite(f"{cikis}/renklendirilmis.png", tint)
cv2.imwrite(f"{cikis}/orijinal_1024.png", img)
