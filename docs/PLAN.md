# Ninnly — Ürün ve Yapım Planı

Tarih: 2026-11-16 · Kaynak: *Ninnly iOS Master Araştırma, Analiz ve Mimari Raporu* (16 Kasım 2026)

## 1. Kararlar (Himmet, 2026-11-16)

| Konu | Karar |
|---|---|
| Teknoloji | SwiftUI yerel uygulama. iOS 18+, watchOS 11+. Mac yok: derleme, test ve simülatör ekran görüntüleri GitHub Actions macOS makinelerinde alınır. |
| İş modeli | **Tek fiyatlı ücretli uygulama.** Uygulama içi satın alma, abonelik, deneme süresi ve reklam yok. Bütün özellikler satın alan herkese açık. |
| v1.0 kapsamı | Raporun tamamı: bütün modüller + Apple Watch + Siri + CSV ile veri aktarma. |
| Konum | `C:/Users/win10/Desktop/ninnly` ↔ GitHub `himmetaga/ninnly` (herkese açık depo, dal `main`; özel depoda macOS derlemesi fatura engeline takıldı. Strateji raporu yalnız yerelde, `docs/kaynak/` git dışı). |
| Kimlikler | Bundle `dev.himmetaga.ninnly`, App Group `group.dev.himmetaga.ninnly`, iCloud `iCloud.dev.himmetaga.ninnly`. |
| Apple hesabı | Mevcut bireysel geliştirici hesabı (Team JF563M2B3Z, Godloom ile aynı). |
| Cihaz | Yalnız iPhone (dikey). |

## 2. Rapordan sapmalar (bilerek yapılan düzeltmeler)

1. **"SweetSpot" adı kullanılmaz.** Huckleberry'nin tescilli markası. Özelliğin adı "Uyku Penceresi" (EN: "Nap Window").
2. **Anahtar kelimelerde rakip adı yok** ("nara", "huckleberry" çıkarıldı). App Store Review Guideline 2.3.7.
3. **Ücretsiz/Plus katmanları kalktı** (tek fiyat kararı). Paywall, RevenueCat ve StoreKit yok.
4. **HealthKit v1.0'da yok.** Gerekmiyor; Guideline 5.1.3 yükünü ve inceleme riskini azaltır.
5. **Teşhis dili yok.** Dışkı rengi, ateş ve büyüme gibi veriler "bilgi + doktorunuza danışın" olarak sunulur; uyarı ya da teşhis gibi gösterilmez (Guideline 1.4.1).
6. **Tıbbi içerik doğrulanmadan yayına girmez** (bkz. §6).
7. **Pazar rakamları doğrulanmadı.** Raporun pazar ve rakip rakamları (ör. "Nara Baby Eylül 2026'da ücretliye geçti") yalnız yön göstergesi.

## 3. Mimari

**Hedefler (XcodeGen `project.yml`):**
- `Ninnly`: iOS uygulaması.
- `NinnlyWidgets`: WidgetKit ve Live Activity / Dynamic Island.
- `NinnlyWatch`: watchOS uygulaması (WatchConnectivity).
- `NinnlyCore`: yerel Swift paketi. Arayüz içermez, yalnız Foundation kullanır. İçinde saf kurallar var: uyku penceresi, süt stoku 4'ler kuralı, aşı takvimi, DSÖ persentili, CSV ayrıştırma ve birim dönüşümü. Bütün hedefler bu paketi kullanır; testleri en kapsamlı katmandır.

**Veri:** Core Data + `NSPersistentCloudKitContainer`, kendi veritabanı ve paylaşılan veritabanı birlikte. CloudKit paylaşımının en olgun olduğu yol bu. Varlıklar:
- `BabyProfile`
- `CareEvent`: türü feed, bottle, pump, sleep, diaper, solid, growth, vaccine, medication veya temperature olur.
- `MilkStashItem`
- `FoodTrial`

Widget ve Watch verileri App Group üzerinden okur. Sunucu yok; geliştiriciye maliyet 0 $.

**Tema:**
- `ThemeManager` iki faz arasında geçer: gece fazı (varsayılan 20:00–06:30, ayarlanabilir) ve gündüz fazı. Elle de geçilebilir.
- Renkler raporun §6 tablosundaki hex değerleri.
- Gece fazında beyaz ve mavi ton yok.
- Arayüz kutusuz: kart, çerçeve ve gölge yok, yüzen tipografi var.

**Etkileşim:**
- Kritik işlemlerde 0,7 sn basılı tutarak onay.
- Sayı girişinde klavye yerine haptik kaydırma tekerleği.
- Bütün ana işlemler ekranın alt yarısında, tek başparmakla yapılır.
- "Kaygısız Görünüm" anahtarı: kırmızı grafik ve hedef karşılaştırması gösterilmez.

**Sistem:**
- ActivityKit: etkileşimli emzirme ve uyku sayacı.
- WidgetKit.
- App Intents: Siri, Kısayollar ve Action Button.
- PDF: tek sayfalık doktor özeti (ImageRenderer veya PDFKit).

**Hareket tasarımı (Himmet, 2026-11-16: "hareketli butonlar ve grafikler"):**
- Düğmeler yaylı (spring) basılır, dokunuşta haptik verir. Basılı tutma onayında 0,7 sn'de dolan bir halka ve tamamlanınca küçük bir "tamam" anı oynar. Çalışan sayaç düğmesi yavaşça "nefes alır".
- Sayılar ve sayaçlar akarak değişir (`contentTransition(.numericText())`). Sağ/sol göğüs geçişi `matchedGeometryEffect` ile kayar.
- Grafikler Swift Charts ile çizilir: çizgiler soldan sağa çizilerek, çubuklar büyüyerek gelir. Aralık değişince grafik yumuşak geçişle dönüşür; parmakla tarandığında her noktada haptik "tık" verir.
- Logo açılışta tek çizgiyle "çizilerek" belirir (`trim` animasyonu), sonra hafifçe nefes alır.
- Gece fazında hareket daha yavaş ve küçük genliklidir; parlama ve yanıp sönme yoktur (bebeği uyandırmamak için). "Hareketi Azalt" açıksa yalnız yumuşak geçişler oynar.
- Yalnız yerel araçlar kullanılır (SwiftUI spring, PhaseAnimator, KeyframeAnimator, symbolEffect, sensoryFeedback, Swift Charts); Lottie ya da Rive yok. Hedef 120 Hz'de kare kaçırmamak ve her animasyonun yarıda kesilebilmesi.

**Marka (Himmet, 2026-11-16: "şık, premium, göze çarpan logo"):** Logo vektör (SVG) olarak tasarlanır ve 16 px'ten 1024 px'e kadar okunur kalır. Gece ve gündüz paletinin ikisinde de çalışır. Tek çizgiden kurulur ki açılışta çizilerek canlandırılabilsin. Uygulama ikonu da bu logodan türetilir.

**Logo kararı (2026-11-16, Himmet'in kendi taslağı):** Mercan bir hilal (anne ve beşik) içinde kundaklı uyuyan bebek, katmanlı koyu yeşil zemin. Himmet bunu kendisi yapay zekâyla üretti. Uygulama ikonu bu görselin **değiştirilmemiş** halidir (`docs/marka/aday/hilal-bebek.jpg` → 1024 px). Claude'un "sadeleştirilmiş" vektör denemesi (`docs/marka/hilal`) reddedildi: "Logoyu mahvetmişsin". Kural: Himmet'in getirdiği görsel olduğu gibi kullanılır, "düzeltme" yapılmaz. Uygulama içi hareketli logo için aynı çizimin şeffaf zeminli hali gerekiyor; o gelene kadar ana ekranda logo yok. Koyu ve renklendirilmiş ikon varyantlarını sistem üretiyor. Hilalin yanına yıldız eklenmez. Reddedilen yönler: `docs/marka/tur2`–`tur4`, cam "n" (`docs/marka/son`), sadeleştirilmiş vektör (`docs/marka/hilal`).

**Gizlilik:** Üçüncü taraf SDK ve analitik yok. `PrivacyInfo.xcprivacy` eklenecek. Veriler yalnız kullanıcının kendi iCloud hesabında durur.

## 4. v1.0 modülleri

1. **Beslenme:**
   - Sağ/sol emzirme sayacı ve son kullanılan göğüs.
   - Biberon: anne sütü, mama veya karışık.
   - Sağ/sol sağım (ml) ve sağ/sol denge grafiği.
   - Biberon verildiğinde sağım hatırlatıcısı sıfırlanmaz.
2. **Süt stoku:**
   - Saklama yeri: oda, buzdolabı veya dondurucu.
   - 4'ler kuralı geri sayımı, toplam ml ve "önce bunu kullan" bildirimi.
3. **Uyku:**
   - Uyku sayacı ve uyanıklık penceresi.
   - Uyku Penceresi tahmini: yaş tablosu ve son 7 günün ağırlıklı ortalaması; 4. ve 8. ay gerilemelerine uyarlanır.
   - Beyaz/pembe gürültü ve pışpış mikseri. Sesler bizim üretimimiz ya da telifsiz olacak.
4. **Bez:** Islak, kirli ve karma bez kaydı, günlük sayaç, renk ve kıvam kaydı (yalnız bilgi).
5. **Sağlık:**
   - Ateş kaydı.
   - İlaç ve takviye kaydı, çift doz korumalı.
   - Boy, kilo ve baş çevresi ile DSÖ persentil eğrileri.
   - T.C. aşı ve tarama takvimi, hatırlatıcılarıyla.
   - Doktor PDF'i.
6. **Ek gıda (BLW):** İlk 100 besin listesi, 3 deneme kuralıyla alerjen matrisi, reaksiyon notu ve aya göre sunum kartları.
7. **Paylaşım:** Eş, büyükanne ve bakıcı ile CloudKit paylaşımı. Paylaşılan kişinin de uygulamaya sahip olması gerekir, bu yüzden Aile Paylaşımı önemli (§8).
8. **Aktarma:** Huckleberry ve Nara Baby CSV dosyalarını içe aktarma; Ninnly verisini CSV olarak dışa aktarma.
9. **Sistem:** Dynamic Island, widget, Apple Watch ve Siri.
10. **Dil:** Türkçe ve İngilizce (String Catalog).

## 5. Aşamalar

Bu aşamalar için süre tahmini verilmiyor. Her aşamanın sonunda derleme temiz, testler geçer ve simülatör ekran görüntüsüyle doğrulanır; büyük aşamalardan sonra TestFlight'ta da denenir.

| # | Aşama | Bitti tanımı |
|---|---|---|
| A0 | Kurulum: klasör yapısı, `project.yml`, `.gitignore`, GitHub Actions iş akışı (derleme, test, simülatör ekran görüntüsü, TestFlight) | Boş uygulama bulutta derlenir ve TestFlight'a çıkar |
| M | Marka: logo yönü, vektör logo ve yazı logosu, hareketli açılış logosu, uygulama ikonu | Logo onaylı, ikon 1024 px hazır, açılış animasyonu simülatör videosuyla doğrulanmış |
| A1 | `NinnlyCore`: kurallar ve birim testleri | Bütün kural testleri geçer |
| A2 | Veri katmanı ve CloudKit paylaşımı (en riskli kısım, bu yüzden erken) | İki cihaz arasında kayıt eşleşir |
| A3 | Arayüz iskeleti: tema fazları, kutusuz ana ekran, basılı tutma, tekerlek | Gece ve gündüz ekran görüntüleri onaylı |
| A4 | Modüller: beslenme, sağım, stok, uyku, bez | Gece 03:00 senaryosu tek elle yapılabilir |
| A5 | Sistem: Live Activity, widget, Siri, Watch | Kilit ekranından sayaç durdurulabilir |
| A6 | Sağlık: aşı, büyüme, ilaç, ateş, ek gıda, PDF | §6'daki içerikler doğrulanmış |
| A7 | CSV içe ve dışa aktarma | Gerçek örnek dosyalar hatasız aktarılır |
| A8 | Mağaza: ikon, ekran görüntüleri, TR/EN metinler, gizlilik ve destek sayfası, inceleme notu, fiyat | İncelemeye gönderilir |

## 6. Yayın öncesi doğrulanması şart olan içerik

- [ ] T.C. Sağlık Bakanlığı güncel çocukluk dönemi aşı takvimi ve taramalar (resmî sayfadan). İlk tarama: `docs/arastirma/A1_kaynak_dogrulama.md`. Rapordaki takvim eski: 14 Nisan 2025'ten beri 2-4-6-18. aylarda 6'lı karma (DaBT-İPA-Hib-HepB) var, 1. ay ve 6. ay ayrı HepB dozları yok (HBsAg+ anne bebeği hariç). 9. ay KKK yalnız risk durumunda ek doz. Rotavirüs ulusal programda değil. Bunlar yayından önce resmî sayfadan bir kez daha elle teyit edilecek.
- [ ] DSÖ büyüme standartları LMS tabloları ve kullanım lisansı. DSÖ içerikleri CC BY-NC-SA 3.0 IGO (ticari olmayan) lisanslı. Ücretli uygulamada kullanmak için DSÖ'den ticari izin istenir (§8). DSÖ logosu ve "DSÖ onaylı" ifadesi kullanılmaz.
- [x] CDC ve AAP anne sütü saklama süreleri: oda 4 saat, buzdolabı 4 gün, dondurucu 6 ay en iyi ve 12 ay kabul edilebilir, çözülmüş süt buzdolabında 24 saat ve odada 1–2 saat, artan süt 2 saat, tekrar dondurma yok. `MilkStorage` bunlara göre yazıldı.
- [x] Yaşa göre uyanıklık penceresi tablosu: üç kaynakla uyumlu. 11–14 ayda tek uykuya geçen bebek için 270–330 dk eklendi. Tıbbi standart değil, rehberdir; arayüzde bu not gösterilecek.
- [ ] Ek gıda sunum kartları (boğulma riski: en hassas içerik)
- [ ] "Ninnly" marka taraması: TÜRKPATENT, EUIPO, USPTO ve App Store
- [ ] Huckleberry ve Nara Baby CSV biçimleri (gerçek örnek dosya gerekiyor)

## 7. İş bölümü

- **Claude (patron):** plan, karar, brif, denetim, commit ve kullanıcıyla iletişim.
- **Kod:** agy (öncelikli), yedeği GitHub Copilot CLI. Jules kapandı, Codex iptal edildi.
- **Uzun araştırma:** Gemini Deep Research. **İkon ve görseller:** Nano Banana Pro.
- **Derleme:** GitHub Actions macOS. Windows'ta Swift kurulu değil, bu yüzden testler de bulutta koşar.

## 8. Açık kararlar (Himmet)

- [ ] **Fiyat:** ABD ve Türkiye fiyat basamağı.
- [x] **GitHub deposu:** `himmetaga/ninnly`, 2026-11-16'da açıldı. Fatura engeli yüzünden herkese açık yapıldı (Himmet onayı).
- [ ] **DSÖ ticari kullanım izni (A6 öncesi):** Büyüme persentilleri için DSÖ'nün izin formuyla başvuru yapılır. Başvuru Himmet adına yapılacağı için onayı gerekir. İzin gelmezse büyüme ekranı persentilsiz yalnız ölçüm grafiği olarak çıkar.
- [ ] **App Store Connect kurulumu (A0 sonu):** Ninnly uygulama kaydı, iCloud kapsayıcısı ve App Group. Bunları Himmet açar ya da onaylar. GitHub'a `APPLE_TEAM_ID`, `APP_STORE_CONNECT_KEY`, `APP_STORE_CONNECT_KEY_ID` ve `APP_STORE_CONNECT_ISSUER_ID` gizli değerlerinin girilmesi gerekiyor (Godloom'daki anahtarla aynı).
- [ ] **Aile Paylaşımı:** Öneri açık. Böylece eşin ve ailenin ayrıca satın alması gerekmez; aile grubu dışındaki bakıcı yine satın almak zorunda kalır.
- [ ] **Gizlilik ve destek sayfası adresi:** App Store için şart. Seçenekler: `himmetaga.dev/ninnly` (mevcut, ücretsiz) ya da yeni bir alan adı (`ninnly.app` vb., ücretli).
