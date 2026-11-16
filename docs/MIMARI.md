# Ninnly — Mimari Plan (logodan işleve)

Tarih: 2026-11-16. Dayanak: `docs/PLAN.md` (kararlar) ve araştırmalar `docs/arastirma/A1`, `M1` (pazar, rakip, yasal), `M2` (ebeveyn ihtiyaçları), `M3` (teknik), `M4` (tasarım, marka), `M5` (aşı takvimleri). Bu belge "nasıl yapılacak" sorusunu yanıtlar; "ne yapılacak" kararları PLAN'dadır. Claude'un doğrulamadığı araştırma iddiaları belirtilmiştir.

---

## 0. Beş ilke (her kararın ölçüsü)

1. **Gece 03:00, tek el, kucakta bebek.** Her temel kayıt en çok iki dokunuşta biter; birincil düğmeler ekranın alt yarısındadır; kilit ekranından ve saatten de yapılır.
2. **Kaygı üretme.** Kıyaslama yok, kırmızı alarm yok, "seri bozuldu" yok. Persentil ve ortalama gizlenebilir ("Kaygısız Görünüm").
3. **Veri bizde değil.** Sunucu, hesap, analitik, üçüncü taraf kod yok. Veri yalnız cihazda ve ailenin iCloud'unda. Mağaza etiketi: "Veri Toplanmıyor".
4. **Abonelik var, baskı yok.** Haftalık ve yıllık abonelik (Himmet, 2026-11-16; ömür boyu satış yok). Reklam yok; karanlık desen (gizli deneme sonu, kapatılmayan pencere, gece kayıt anında ödeme ekranı) yok. Ayrıntı §10b.
5. **Kutusuz, yüzen tipografi.** Kart, panel, çerçeve yok; hiyerarşi yazı boyutu, renk ve boşlukla kurulur. Hareket canlı ama gece sakindir.

---

## 1. Platform ve derleme

| Konu | Karar | Dayanak |
|---|---|---|
| Derleyici | **Xcode 26** (iOS 26 SDK). Apple 28 Nisan 2026'dan beri yalnız Xcode 26 ile derlenen yüklemeleri kabul ediyor. Şu anki Xcode 16.4 ile TestFlight'a çıkılamaz. | Apple "Upcoming Requirements" sayfası — **Claude doğruladı** |
| Bulut makinesi | GitHub Actions `macos-26` (Xcode 26.6 varsayılan; simülatörler iOS/watchOS 26.2–26.5). | runner-images belgesi — **Claude doğruladı** |
| En düşük sürüm | **iOS 18.0 / watchOS 11.0** kalır. iOS 26'ya çekmek aktif iPhone'ların yaklaşık %14'ünü (sık sık büyükanne ve bakıcı telefonları) dışarıda bırakır; v1.0'ın hiçbir işlevi iOS 26'ya özel değil. | M3 §1.3–1.4 (Apple dağılım verisi, Haziran 2026) |
| iOS 26'ya özel görünüm | Liquid Glass yalnız `#available(iOS 26, *)` ile, alt eylem kapsüllerinde; iOS 18'de aynı yerde düz mat yüzey. | M4 §1 |
| Dil | Swift 6.2 araç zinciri. Uygulama hedefleri Swift 6 dil kipi (katı eşzamanlılık); `NinnlyCore` geçiş bitene kadar Swift 5 kipinde. | M3 §9 |
| Proje | XcodeGen (`project.yml`), Mac yok; her şey bulutta derlenir ve test edilir. | PLAN §1 |
| Risk | Bulutta iOS 18 simülatörü yok; iOS 18 davranışı yalnız TestFlight'ta gerçek cihazla denenir. | runner-images |

---

## 2. Hedefler ve katmanlar

```
NinnlyCore (Swift paketi, yalnız Foundation)      ← saf kurallar, testlerin çoğu burada
   kurallar: Uyku Penceresi, süt stoku, göğüs sırası, çift doz, birimler   (A1'de yazıldı)
   sağlık:   aşı takvimi motoru + TR/ABD takvim verisi, DSÖ persentil (izin gelirse)
   aktarım:  CSV okuyucu (Huckleberry, Nara, Ninnly) ve yazıcı
   özet:     günlük/haftalık özetler (grafik ve PDF bunları kullanır)

NinnlyData (Swift paketi: Core Data + CloudKit)    ← iOS, widget ve saat aynı kodu kullanır
   model, iki depo (özel + paylaşılan), paylaşım akışı, geçmiş izleme, widget anlık görüntüsü

Ninnly          (iOS uygulaması: SwiftUI ekranları, tema, bildirim planlayıcı, PDF, Siri niyetleri)
NinnlyWidgets   (ana ekran ve kilit ekranı kutucukları, kilit ekranı sayacı, Denetim Merkezi düğmeleri)
NinnlyWatch     (watchOS uygulaması + saat kutucukları)
NinnlyTests / NinnlyUITests (birim testleri; gece/gündüz, TR/EN ekran görüntüleri)
```

Kurallar: arayüz `NinnlyCore`'u ve `NinnlyData`'yı kullanır, tersi asla. Ekran modelleri `@Observable`; iş kuralı ekran kodunda yazılmaz. Her yeni kural önce `NinnlyCore`'a testle girer.

---

## 3. Veri modeli

**Seçim: Core Data + `NSPersistentCloudKitContainer`, SwiftData değil.** SwiftData iOS 26 itibarıyla kullanıcılar arası paylaşımı (CKShare) desteklemiyor; eş, büyükanne ve bakıcı paylaşımı Ninnly'nin temel özelliği (M3 §2.1). iOS 27'de değişip değişmediği doğrulanmadı; değişse bile iOS 18 hedefi yüzünden Core Data gerekir.

**Varlıklar** (CloudKit kuralları: tüm alanlar isteğe bağlı ya da varsayılanlı, benzersizlik kısıtı yok, sıralı ilişki yok):

| Varlık | Ana alanlar | Not |
|---|---|---|
| `Baby` | ad, doğum tarihi, cinsiyet (persentil için, isteğe bağlı), doğum haftası (prematüre düzeltmesi), aşı takvimi ülkesi | Paylaşımın kökü |
| `CareEvent` | tür, başlangıç, bitiş (devam ediyorsa boş), değer (kanonik birimde), alt tür, not, saat dilimi kimliği, kaydeden kişi, silinme zamanı | Beslenme, emzirme, biberon, sağım, uyku, bez, ateş, ilaç dozu, ek gıda, ölçüm, not — **tek tablo, yalnız eklenir** |
| `MilkStashItem` | hacim, konum, saklama zamanı, kullanıldı mı | Süt stoku |
| `Medication` | ad, en kısa doz aralığı (kullanıcı girer), aktif mi | Doz hesabı YAPILMAZ (tıbbi cihaz sınırı) |
| `VaccineRecord` | takvim doz kodu ya da elle aşı adı, yapıldığı tarih, doktorun verdiği tarih, not | Takvimin kendisi veri dosyasında, burada yalnız ailenin kaydı |
| `HandoffNote` | metin, yazan, zaman | Ana ekranda sabit devir notu |
| `Reminder` | tür, hedef zaman, tekrar | Bildirim planlayıcının kaynağı |

**Kurallar:**
- Ölçümler veritabanına **metrik** yazılır (ml, g, cm, °C); oz, lb, inç, °F yalnız gösterimde çevrilir.
- Süre = bitiş − başlangıç (saniye). Takvim günü hesabıyla süre ölçülmez; yaz saati ve seyahat kayması böyle önlenir. Her olayda saat dilimi kimliği saklanır.
- Kayıt silinmez, `silinme zamanı` ile gizlenir (iki kişi aynı anda düzenlerse geri alınabilir). Birleştirme politikası: alan bazında son yazan kazanır.
- Devam eden sayaç = bitişi boş bir olay. Uygulama kapalıyken saniye sayan bir zamanlayıcı yoktur.

---

## 4. Eşitleme ve paylaşım

- **İki depo:** `private.sqlite` (ailenin sahibi) ve `shared.sqlite` (davet edilenler). İkisi de App Group içinde; widget ve saat aynı veriyi okur.
- **Paylaşım birimi bebek:** her bebek CloudKit'te kendi bölgesindedir; davet o bebeği ve tüm olaylarını paylaşır. Roller: düzenleyebilir (eş, büyükanne) ya da yalnız görür.
- **Davet:** iOS'un kendi paylaşım ekranı (Mesajlar, WhatsApp bağlantısı). Davet edilenin de Ninnly'ye sahip olması gerekir. Aile Paylaşımı açık olduğundan aile grubundaki eş yeniden ödemez; davet ekranında bu üç adımda anlatılır (M1 §3.3).
- **Apple hesabı ya da iPhone'u olmayan bakıcı:** tek dokunuşla "bugünün özeti" görseli/metni WhatsApp'a gönderilir (salt okunur). Bakıcının veri girmesi v1.0'da yok.
- **En riskli kısım bu:** A2'de arayüzden önce iki gerçek iCloud hesabıyla TestFlight'ta denenir; şema yayından önce bir kez `initializeCloudKitSchema` ile üretimdeki CloudKit'e gönderilir. Şema sonradan yalnız **eklenerek** değişir.
- **Saat:** saat kendi Core Data + CloudKit deposunu da tutar (telefon uzaktayken çalışsın), telefon yakındaysa `WatchConnectivity` ile anında iletir. İki yolun çift kayıt üretmemesi için her olay saatte üretilen kimliğiyle gider. Saatte paylaşılan veritabanının davranışı A5'te prototiple doğrulanacak.

---

## 5. Sistem entegrasyonları

| Yüzey | Ne yapar | Teknik not |
|---|---|---|
| **Kilit ekranı sayacı** (Live Activity, Dynamic Island) | Süren emzirme/uyku sayacı; kilidi açmadan "durdur", "taraf değiştir" | Sayaç `Text(timerInterval:)` ile, pil harcamaz. Sistem 8 saatte sonlandırır; uzun gece uykusunda veri yine doğru kalır (olay veritabanında açık). Eşin telefonunda sessiz güncellenir, uyandırmaz. |
| **Ana ekran ve kilit ekranı kutucukları** (widget) | Son beslenme ne zaman / hangi taraf, Uyku Penceresi, bugünün bez sayısı | Etkileşimli düğmelerle tek dokunuş kayıt (iOS 17+). |
| **Denetim Merkezi ve Eylem Düğmesi** | "Emzirme başlat", "Bez" | iOS 18 Denetim Merkezi kontrolleri. |
| **Siri ve Kısayollar** (App Intents) | "Ninnly'de sol emzirmeyi başlat", "Son beslenme ne zamandı?" | TR ve EN ifadeler; iOS 26'da Apple Intelligence aynı niyetleri kullanır. |
| **Apple Watch** | Tek dokunuşla başlat/durdur: emzirme, uyku, bez; son olay; saat kutucukları ve Smart Stack | Bağımsız watchOS uygulaması. |
| **Bildirimler** | İlaç zamanı, süt stoku bozulacak, Uyku Penceresi (isteğe bağlı), aşı yaklaşıyor | iOS en çok 64 bekleyen bildirim tutar: planlayıcı her açılışta en yakın 50'yi önceliğe göre yeniden kurar. İlaç ve süt `.timeSensitive`. Eşin her kaydı karşı tarafa bildirim olarak GİTMEZ. |

---

## 6. Ekranlar ve akış

**İlk 60 saniye** (M2 §8): tek ekran — doğum tarihi (varsayılan bugün) ve isteğe bağlı ad. "Başla" → ödeme ekranı (§10b; davet bağlantısıyla gelen atlar) → ana ekran. Hesap, anket, tanıtım turu yok. Bildirim izni ilk hatırlatıcı kurulurken istenir, açılışta değil. Önceki uygulamadan geçenler için ilk ekranda küçük bir "Huckleberry / Nara verimi getir" bağlantısı.

**Ana ekran ("Şimdi"):**
- Üst yarı (okuma): süren sayaç (büyük, eş aralıklı rakam), "son beslenme 2 sa 10 dk önce · sol", Uyku Penceresi aralığı, sabit devir notu, son olayı kimin girdiği (Anne / Baba / Anneanne).
- Alt yarı (eylem, başparmak bölgesi): 4 büyük eylem — Emzirme, Biberon, Uyku, Bez. Basılı tutunca dolan halkayla başlar (yanlış dokunmayı önler); kısa dokunuş hızlı seçim açar.
- Bebeğin yaşına göre sıralama değişir: 6. aydan sonra Ek Gıda öne gelir, bez geri çekilir; kullanıcı modül gizleyebilir.

**Modüller:** Beslenme (emzirme L/R sayaç ve denge, biberon anne sütü/mama, karma beslenme tek akış, sağım), Süt Stoku (konum, tazelik, "önce bunu kullan", çözülmüş süt ve artan süt kuralları), Uyku (sayaç, gece/gündüz, Uyku Penceresi + "rehberdir, tıbbi standart değil" notu), Bez (ıslak/kirli, renk kaydı tanısız), Büyüme (kilo/boy/baş çevresi grafiği; persentil DSÖ izni gelirse ve Kaygısız Görünümde gizli), Sağlık (aşı ve taramalar §7, ilaç ve çift doz koruması, ateş kaydı), Ek Gıda (besin, ilk deneme, tepki notu), Paylaşım, Ayarlar.

**Ek sayfalar:** Doktor raporu (tek sayfa PDF, hep açık tema, vektörel), CSV içe/dışa aktarma, "Ebeveyn öz bakım" (doğum sonrası duygular normalleştirilir; tanı yok; tek dokunuşla resmî destek hatları: TR Aile Hekimi, ALO 183, 112; ABD 988, PSI, 1-833-TLC-MAMA — numaralar yayından önce yeniden doğrulanacak), "Kaynaklar ve yöntem" (App Store 1.4.1: her tıbbi bilginin resmî bağlantısı).

**Unutulan sayaç:** emzirme 60 dakikayı, gündüz uykusu 4 saati geçerse nazik bir soru: "Hâlâ sürüyor mu?" ve tek dokunuşla "olağan süreyle bitir".

---

## 7. Aşı ve tarama takvimi

- Uygulama **her ülkede** satılır; hazır takvim **Türkiye ve ABD** için (PLAN §1). Ülke telefonun bölgesinden seçilir, ayarlardan değişir. Diğer ülkelerde aile kendi takvimini girer; başka ülkenin takvimi asla gösterilmez.
- Takvim **veri dosyası** olarak `NinnlyCore` içinde durur (her doz: kod, ad TR/EN, zaman aralığı, en kısa aralık, koşul, kaynak, kaynak tarihi). Kod takvimi değil, motoru içerir; takvim değişince yalnız veri dosyası ve testleri değişir, uygulama güncellemesiyle gelir (sunucu yok).
- **Türkiye bebek:** ulusal program — 14 Nisan 2025'ten beri 6'lı karma (sağlıklı bebekte ayrı 1. ay ve 6. ay hepatit B iğnesi yok), **1 Eylül 2026'dan beri 48. ayda suçiçeği 2. doz** (A1'de eksikti; ikincil kaynaklarla doğrulandı, resmî metin yayından önce asi.saglik.gov.tr'den yeniden kontrol edilecek). Bebek profilinde iki isteğe bağlı anahtar: "anne HBsAg pozitif" (doğumda HBIG, 1. ay tekli hepatit B, 9–12. ayda kan testi hatırlatıcısı) ve "2000 g altı doğum" (BCG için ağırlık/hafta notu, 1. ay hepatit B). 9. ay KKK "doktor önerirse" etiketiyle; 12. ay dozunun yerini tutmaz. Ulusal program dışı aşılar (rotavirüs, meningokok B ve ACWY, grip) ayrı bölümde, tek dokunuşla eklenir. Yenidoğan taramaları (topuk kanı, işitme, kalça ultrasonu, kırmızı refle, prematürede ROP) ilk 60 günün kontrol listesi.
- **Türkiye anne:** gebelikte Tdab (2 Nisan 2025'ten beri ücretsiz, 18–36. hafta) "yapıldı mı" kaydı; Doğum Sonu Bakım Rehberi'ndeki lohusa izlemleri (2–5. gün, 13–17. gün, 30–42. gün) hatırlatıcı olarak.
- **ABD — durum:** 2025–26'da federal takvim ile hekim kuruluşları ayrıştı (ACIP üyelerinin tamamı Haziran 2025'te değiştirildi; 5 Ocak 2026'da CDC yedi aşıyı rutinden çıkardı; AAP kendi takvimini yayımladı). **16 Mart 2026'da federal mahkeme Ocak değişikliklerini ve yeni ACIP oylarını geçici olarak durdurdu** (Claude doğruladı); dava ve itiraz sürüyor.
- **ABD — öneri (Himmet onayı, §13):** tek liste; temel **AAP 2026 çocuk takvimi + ACOG gebelik takvimi** (bugün mahkeme kararıyla federal takvimle büyük ölçüde örtüşüyor). Kaynakların ayrıştığı dozlarda (anne HBsAg negatifken doğum dozu hepatit B, 6–23 ay COVID-19, rotavirüs vb.) dozun altında tarafsız bir not: "Kaynaklar 2025–26'da farklı öneriler yayımladı; çocuğunun doktoruyla konuş." Ayarlarda "CDC mi AAP mi" seçimi yok (kafa karıştırır ve siyasi taraf algısı yaratır). Hiçbir doz listeden gizlenmez: rotavirüsün 15 hafta / 8 ay üst sınırı gibi pencereler kaçmasın.
- **Gösterim dili:** "Yaptırmalısın" değil, kaynak atıflı hatırlatıcı: "Sağlık Bakanlığı takviminde 2. ayın sonunda yer alır. Aile hekimine danış." Her dozda kaynak kurum, resmî bağlantı, kaynağın tarihi ve Ninnly'nin son kontrol tarihi. Aile bir dozu doktor kararıyla "yapılmayacak" diye işaretleyip gizleyebilir. Uygulama aşı lehine ya da aleyhine yorum yapmaz.
- **Geciken doz:** kırmızı yok; takvim otomatik kaydırılmaz (yakalama şemaları yaşa göre doz sayısını değiştirir). Yalnız "bir sonraki doz için en erken tarih" (yapılan gerçek tarih + en kısa aralık) ve "yakalama planı için doktoruna danış" gösterilir. Üst yaş sınırı olan dozlar sınır geçince "üst yaş sınırı geçti" durumuna geçer.
- **Veri ve güncelleme:** `NinnlyCore` içinde sürümlü iki dosya (`vaccines_TR.json`, `vaccines_US.json`; şema sürümü ve son kontrol tarihi ile). M5 §7'deki 82 satırlık tablo tohum verisidir; dosyaya girmeden önce her satır resmî kaynakla karşılaştırılır. Takvim yılda iki kez (Şubat: ABD yıllık takvimleri; Eylül: Türkiye ve kış sezonu) ve resmî duyuruda elle kontrol edilir; değişiklik testleriyle birlikte uygulama güncellemesiyle gelir. Araştırmanın önerdiği "uygulama internetten takvim dosyası indirsin" yolu **seçilmedi**: uygulama hiçbir sunucuya bağlanmamalı (§0, ilke 3).

---

## 8. Tasarım sistemi

**Palet — logoyla uyumlu hale getirme önerisi (Himmet onayı bekliyor, §13):** Logo koyu çam yeşili, mercan ve krem. Mevcut uygulama paleti (gece neredeyse siyah + krem yazı; gündüz krem + yeşil) logoyla akraba ama birebir değil. Öneri (kontrast oranları M4 §7.2'den, Claude yeniden hesaplayacak):

| Rol | Gece (mavi ve beyaz yok) | Gündüz |
|---|---|---|
| Zemin | koyu çam `#0F1412` | krem `#F6F0E4` |
| Ana yazı | sıcak şeftali `#F59B6C` | koyu çam `#172820` |
| İkincil yazı | kehribar toprak `#C98462` | yeşil gri |
| Vurgu (eylem) | hilal mercanı `#E47953` | terrakota `#B84322` |

- Gece fazı 20:00–06:30 (ayarlanabilir). Gece: beyaz, mavi, parlama, yanıp sönme yok. Ekran parlaklığı zorla kısılmaz; ayarlarda isteğe bağlı "ekstra karartma".
- **Tipografi:** SF Pro Rounded; sayaçlarda eş aralıklı rakam; Türkçe büyük harf `tr` yereliyle (İ/ı); sabit yükseklik verilmez (İ noktası kesilmesin); Dynamic Type en büyük boyuta kadar, kesilme yok.
- **Kutusuz düğme kuralları:** her dokunulabilir öğe en az 48 pt yüksek, görünmez dokunma alanı tüm satırı kapsar; bilgi yalnız renkle verilmez (Sol/Sağ yazı + simge, grafikte düz/kesikli çizgi); renk körlüğü kontrolü.
- **Liquid Glass** yalnız alt eylem kapsülleri, süren sayaç çubuğu ve sekme çubuğunda (iOS 26); içerikte cam yok.
- **Hareket:** yay animasyonları; basılı tutunca dolan halka; sayılar akarak değişir; grafikler soldan sağa çizilerek, çubuklar büyüyerek gelir; parmakla taranınca hafif dokunsal tık. Gece daha yavaş, küçük genlikli, parlamasız. Hareketi Azalt açıksa yalnız yumuşak geçiş. Her animasyon yarıda kesilebilir, 120 Hz'de kare kaçırmaz (grafiklere ham olay değil, önceden hesaplanmış günlük özet verilir).
- **Dokunsal geri bildirim:** kayıt başladı/bitti, taraf değişti; her dokunuşa değil.

---

## 9. Marka

- **Uygulama ikonu:** Himmet'in görseli (`docs/marka/aday/hilal-bebek.jpg`), değiştirilmeden. iOS 26'da tek parça görsel çalışır; sistem dış kenara cam parlaması ekler. "Şeffaf" ve "renklendirilmiş" ana ekran modlarında tam kare görsel bulanık bir plaka gibi görünebilir. Çözüm (Himmet onayıyla): aynı pikseller yeniden çizilmeden zemin, hilal, iç kundak ve bebek olarak şeffaf katmanlara ayrılır, Icon Composer ile `.icon` yapılır.
- **Logo farkı:** "9 puan" için üç küçük ayrıntı sürümü (kundakta "n" kemeri, beşik kıvrımlı uç, kurdele) aynı görsel üzerinde düzenleniyor; seçim Himmet'te.
- **Uygulama içi logo:** şeffaf zeminli sürümle hilal beşik gibi hafifçe sallanır, bebek "nefes alır"; gece daha yavaş. Görsel vektöre çevrilmez.
- **Yazı logosu:** "ninnly" SF Pro Rounded (sistem yazı tipi, lisans gerekmez); web ve mağaza için gerekirse açık lisanslı Quicksand.

---

## 10. Gizlilik, yasal ve tıbbi sınır

- Uygulama hiçbir veriyi geliştiriciye göndermez → App Store etiketi **"Veri Toplanmıyor"** (yalnız kullanıcının kendi iCloud'u kullanıldığında Apple'ın tanımına uyar; M1 §5). Çökme raporu da yalnız Apple'ın kendi (kullanıcı onaylı) sistemiyle.
- **Tıbbi cihaz sınırı** (FDA genel sağlıklı yaşam, AB MDR Kural 11, TİTCK): uygulama kayıt tutar, hatırlatır, resmî bilgiyi kaynağıyla gösterir. **Yapmaz:** ilaç dozu hesaplamak (kiloya göre mg), tanı ya da risk skoru, "normal değil" yargısı, sarılık/dehidratasyon tespiti. Yasak kelime listesi metin denetiminde kullanılır (teşhis, tedavi, normal/anormal, risk altında vb.).
- KVKK, GDPR, COPPA, ABD eyalet sağlık verisi yasaları: veri geliştiriciye gelmediği için yükümlülükler büyük ölçüde doğmaz; gizlilik sayfası bunu açıkça yazar. Uygulamada "Tüm verileri sil (cihaz + iCloud)" düğmesi.
- DSÖ büyüme tabloları CC BY-NC-SA: ticari izin başvurusu gerekir; izin gelmezse büyüme ekranı persentilsiz çıkar (PLAN §8).
- Kids kategorisi seçilmez (uygulama ebeveyn içindir); yaş sınırı 4+.

---

## 10b. Abonelik (StoreKit 2, sunucusuz)

- **Ürünler (Himmet, 2026-11-16):** tek abonelik grubu ("Ninnly Premium"), iki ürün: **haftalık 2,99 $** ve **yıllık 39,99 $**. **Deneme yok. Ücretsiz kısım yok:** uygulama abonelikle açılır. Türkiye fiyatı alım gücüne göre elle ve daha düşük belirlenir (App Store Connect kurulumunda Himmet onaylar).
- **Akış:** tek ekranlık başlangıç (doğum tarihi, isteğe bağlı ad) → ödeme ekranı → ana ekran. Ödeme ekranı uygulamanın ne yaptığını üç satırda ve gerçek ekran görüntüleriyle gösterir.
- **Doğrulama cihazda:** StoreKit 2 `Transaction.currentEntitlements` ve `Transaction.updates` dinleyicisi; Apple imzalı işlem cihazda doğrulanır. Sunucu, RevenueCat ya da başka üçüncü taraf kod yok → "Veri Toplanmıyor" etiketi korunur. İnternet yokken son bilinen hak önbellekten okunur (gece çevrimdışı kayıt kesilmez). App Store Connect'te ödeme sorunu için ek süre (billing grace period) açılır.
- **Aile Paylaşımı:** abonelikte açık; aile grubundaki eş ayrıca ödemez.
- **Ödeme ekranı (Apple 3.1.2 ve 3.1.1):** dönem başına fiyat açık ve büyük, deneme bitiş tarihi ve sonra alınacak ücret yazılı, "Satın alımları geri yükle", "Aboneliği yönet" (`manageSubscriptionsSheet`), Kullanım Koşulları ve Gizlilik bağlantıları. Kutusuz, yüzen tipografi; yıllık planın haftalığa göre kazancı tek satırda. Süren sayaç, gece fazı ve kayıt anı asla ödeme ekranıyla kesilmez.
- **Abonelik bitince:** yeni kayıt kapanır, ama aile verisini CSV/PDF olarak dışa aktarabilir; veri rehin tutulmaz (veri zaten ailenin kendi iCloud'unda). O an süren bir sayaç varsa önce kaydedilir, ödeme ekranı sonra gelir.
- **Paylaşılan bebek (Himmet, 2026-11-16): davetli ödemez.** Abone ebeveynin bebeğine davet bağlantısıyla gelen kişi (büyükanne, bakıcı, aile grubu dışındaki eş) ödeme ekranını görmeden o bebeğe kayıt girer; kendi bebeğini açmak için abonelik gerekir. Davet bağlantısı (CKShare) kabul edilince ödeme ekranı atlanır; sahibin aboneliği biterse paylaşılan bebekte de yeni kayıt kapanır.
- **Test:** StoreKit yapılandırma dosyası (`.storekit`) ile bulutta satın alma, iptal, yenileme ve deneme bitişi testleri; TestFlight'ta sandbox.

---

## 11. Test ve bulut derleme hattı

1. `swift test` — `NinnlyCore` (kural, takvim, CSV, birim) — Swift Testing ve XCTest.
2. `xcodebuild test` — uygulama birim testleri + arayüz testleri; arayüz testleri gece/gündüz × TR/EN ana ekran ve her modül için ekran görüntüsü üretir (6,9" iPhone boyutunda; mağaza görselleri de buradan).
3. TestFlight: `xcodebuild archive` + `-exportArchive` + App Store Connect API anahtarı (fastlane yok). Anahtarı Himmet GitHub gizli değerlerine girer.
4. Her aşama sonunda: testler yeşil, ekran görüntüleri incelenmiş, büyük aşamalarda TestFlight'ta gerçek cihaz.
5. Metin denetimi: her oyuncuya görünen metnin TR ve EN karşılığı String Catalog'da; yasak tıbbi kelime taraması.

---

## 12. Aşamalar (güncel sıra)

| # | İş | Bitti tanımı |
|---|---|---|
| A0b | Bulut hattını Xcode 26'ya (`macos-26`) taşı; uygulama hedeflerini Swift 6 kipine al | Hat yeşil, ekran görüntüsü geliyor |
| A1 | ✅ Kurallar (süt, Uyku Penceresi, göğüs, çift doz, birim) | Testler yazıldı; bulutta koşacak |
| A1b | Aşı takvimi motoru + TR/ABD veri dosyası; CSV okuyucu/yazıcı; özet hesapları | Testler yeşil, takvim M5 ile birebir |
| A2 | `NinnlyData`: model, iki depo, paylaşım, widget anlık görüntüsü | İki iCloud hesabı arasında kayıt eşleşir (TestFlight) |
| A3 | Tasarım sistemi: palet, tipografi, kutusuz düğme, basılı tut halkası, gece/gündüz | Ekran görüntüleri Himmet onaylı |
| A4 | Ana ekran + Beslenme, Süt Stoku, Uyku, Bez | Gece 03:00 senaryosu tek elle iki dokunuş |
| A5 | Kilit ekranı sayacı, kutucuklar, Denetim Merkezi, Siri, Apple Watch | Kilit ekranından sayaç durdurulur; saat telefonsuz kayıt alır |
| A6 | Sağlık: aşı/tarama, ilaç, ateş, büyüme, ek gıda, PDF, öz bakım, kaynaklar sayfası | İçerik PLAN §6'ya göre doğrulanmış |
| A7 | CSV içe/dışa aktarma arayüzü | Gerçek Huckleberry/Nara dosyaları hatasız |
| A7b | Abonelik: StoreKit 2, ödeme ekranı, haklar, Aile Paylaşımı (§10b) | `.storekit` testleri yeşil; TestFlight sandbox satın alma |
| A8 | Mağaza: ikon katmanları, ekran görüntüleri, önizleme videosu, TR/EN metin, gizlilik ve destek sayfası, fiyat | İncelemeye gönderildi |

---

## 13. Açık kararlar (Himmet)

1. ~~Abonelik~~ → **karar (2026-11-16):** haftalık 2,99 $, yıllık 39,99 $, deneme yok, ücretsiz kısım yok, davetli ödemez (§10b). Bekleyen yalnız Türkiye fiyatı (App Store Connect kurulumunda).
2. ~~ABD aşı takvimi~~ → **karar (2026-11-16): AAP temelli tek liste**, ayrışan dozlarda tarafsız not, seçim ekranı yok (§7).
3. **Palet:** §8'deki logoyla uyumlu gece/gündüz paleti.
4. ~~İkon katmanları~~ → **karar (2026-11-16): katmanlara ayrılacak**, pikseller değişmeden; sonuç önce Himmet'e gösterilir.
5. **Logo ayrıntısı:** A / B / C sürümlerinden biri ya da hiçbiri.
6. **DSÖ izni:** Himmet adına başvuru.
7. **App Store Connect kurulumu ve anahtarlar**, **gizlilik/destek sayfası adresi** (PLAN §8).
