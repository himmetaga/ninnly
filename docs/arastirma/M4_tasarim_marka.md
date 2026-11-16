# Ninnly — Tasarım, Hareket, Renk Bilimi ve Marka Araştırma Raporu (M4)

**Hazırlanma Tarihi:** 16 Kasım 2026  
**Kapsam:** iOS 26 / iOS 27 *Liquid Glass* tasarım dili, *Icon Composer* ve katmanlı ikon mimarisi (`docs/marka/aday/hilal-bebek.jpg` analizi), gece sirkadiyen renk bilimi, SwiftUI yerel hareket ve grafik API'leri, *SF Pro Rounded* ve Türkçe tipografi, kutusuz "yüzen tipografi" arayüz kalıpları, rakip görsel analizi ve WCAG / renk körlüğü denetimi, yazı logosu (*wordmark*) ile açılış animasyonu mühendisliği ve 2026 App Store ürün sayfası görsel standartları.  
**Not:** Birincil resmi kaynaklardan doğrudan teyit edilemeyen noktalar **"DOĞRULANAMADI"** olarak işaretlenmiştir. `docs/PLAN.md` ve `docs/arastirma/A1_kaynak_dogrulama.md` içinde doğrulanmış tıbbi/yasal bulgular yeniden araştırılmamış, yalnızca gerekli tasarım kesişimlerinde atıf yapılmıştır.

---

## 1. iOS 26 ve iOS 27 Tasarım Dili: Liquid Glass ve HIG Değişiklikleri

### 1.1. Liquid Glass Nedir? (iOS 26 Devrimi ve iOS 27 İyileştirmeleri)
Apple, Haziran 2025'te (WWDC25) tanıttığı **iOS 26**, **iPadOS 26**, **macOS Tahoe 26**, **watchOS 26**, **tvOS 26** ve **visionOS 26** ile tüm platformlarını **Liquid Glass** adlı dinamik, optik cam malzemesi etrafında birleştirmiştir (`https://www.apple.com/newsroom/2025/06/apple-introduces-a-delightful-and-elegant-new-software-design/`, `https://developer.apple.com/documentation/technologyoverviews/liquid-glass`).
* **Fiziksel ve Optik Özellikler:** Klasik sabit bulanıklık (*Gaussian blur* / `UIBlurEffect`) malzemelerinden farklı olarak Liquid Glass; gerçek zamanlı **ışık kırılması (refraction / lensing)**, kenarlarda **speküler yansımalar (specular highlights)**, cihaz eğimine ve dokunuşa duyarlı **akışkan esneme/birleşme (fluid morphing)** ve altındaki içeriğin rengini ödünç alan **adaptif yarı saydamlık** sunar (`https://developer.apple.com/design/human-interface-guidelines/materials`).
* **HIG Temel İlkesi:** Apple İnsan Arayüzü Kılavuzu (HIG), Liquid Glass'ın **yalnızca içerik katmanının üzerinde yüzen navigasyon ve kontrol katmanı** için ayrıldığını belirtir: *"Liquid Glass forms a distinct functional layer for controls and navigation above content."* (`https://developer.apple.com/design/human-interface-guidelines/materials`).
* **iOS 27 Güncellemeleri (WWDC 2026, Haziran–Eylül 2026):** iOS 26'daki yüksek şeffaflığın karmaşık zeminlerde yarattığı okunabilirlik eleştirileri üzerine Apple, **iOS 27**'de (WWDC26) Liquid Glass'ı üç noktada rafine etmiştir (`https://developer.apple.com/design/whats-new/`):
  1. **Kontrast ve Kenar Koyulaştırma:** Cam yüzeylerin altındaki arka plan yayılımı (diffusion) güçlendirilmiş, kontrol kenarlarındaki speküler çizgiler ve kenar gölgeleri metin okunabilirliğini artıracak şekilde keskinleştirilmiştir (`https://developer.apple.com/design/human-interface-guidelines/materials`).
  2. **Sistem Geneli Şeffaflık/Renklendirme Ayarı:** Kullanıcılara sistem ayarlarında cam görünümünü *ultra şeffaf (clear)* ile *yoğun/opaklaştırılmış (tinted/frosted)* arasında ayarlama imkânı verilmiştir (`https://support.apple.com/guide/iphone/`).
  3. **SF Symbols 8 ve Icon Composer 2:** iOS 27 ile birlikte yeni sembol seti ve gelişmiş ikon katmanlama araçları sunulmuştur (`https://developer.apple.com/design/resources/`). *(Not: iOS 27'de üçüncü parti geliştiricilere açılan tamamen yeni bir `glassEffect` alt API imzası olup olmadığı kamuya açık statik özetlerde ayrı bir kırılım olarak **DOĞRULANAMADI**; iOS 26'daki `glassEffect` API ailesi standart olarak devam etmektedir: `https://developer.apple.com/documentation/swiftui/applying-liquid-glass-to-custom-views`).*

### 1.2. Sekme Çubuğu (Tab Bar), Araç Çubuğu (Toolbar) ve Sayfalar (Sheets)
HIG'in iOS 26/27 güncellemeleri navigasyon bileşenlerinin anatomisini değiştirmiştir:
* **Sekme Çubuğu (Tab Bar):** Ekranın alt kenarına yapışık tam genişlikli opak şerit kalkmış; yerine içerik üzerinde **yüzen kapsül (floating pill) şeklinde bir Liquid Glass sekme çubuğu** gelmiştir (`https://developer.apple.com/design/human-interface-guidelines/tab-bars`). Kullanıcı aşağı kaydırdığında sekme çubuğu küçülerek (*minimize*) yalnızca aktif bağlamı bırakabilir, yukarı kaydırıldığında tekrar genişler (`https://developer.apple.com/documentation/swiftui/view/tabbarminimizebehavior(_:)`). Ayrıca arama (`Role.search`) sekmesi ayrık bir cam kapsül olarak sağda konumlanabilir ve sekme çubuğunun hemen üstüne Apple Music'teki "Şimdi Çalıyor" benzeri kalıcı bir alt aksesuar (`tabViewBottomAccessory`) yerleştirilebilir (`https://developer.apple.com/documentation/swiftui/tabview`).
* **Araç Çubuğu (Toolbar) ve Gezinme Çubuğu (Navigation Bar):** Üst ve alt araç çubuğu düğmeleri artık düz metin yerine yuvarlatılmış cam kapsüller içinde gruplanır (`https://developer.apple.com/design/human-interface-guidelines/toolbars`). İçerik bu çubukların altına kaydığında sistem otomatik bir **kaydırma kenarı efekti (`scrollEdgeEffectStyle`)** uygulayarak yüzen cam kontrollerin arkasındaki metni yumuşakça bulanıklaştırır (`https://developer.apple.com/documentation/swiftui/view/scrolledgeeffectstyle(_:for:)`).
* **Sayfalar (Sheets), Popover ve Eylem Menüsü:** Yarım ekran sayfalar (`presentationDetents([.medium, .large])`) ekran kenarlarından hafifçe içeride yüzen yüksek yuvarlatılmış cam paneller olarak açılır; tetikleyici düğmeden sıvı bir geçişle (`navigationTransition(.zoom)` veya cam esnemesiyle) büyüyerek çıkar (`https://developer.apple.com/design/human-interface-guidelines/sheets`).

### 1.3. Cam Malzemeyi Ne Zaman Kullanmalı, Ne Zaman Kullanmamalı?

| Durum | HIG Kuralı ve Gerekçe (`https://developer.apple.com/design/human-interface-guidelines/materials`) | Ninnly Uygulama Kararı |
| :--- | :--- | :--- |
| **Yüzen Kontroller ve Navigasyon** | **KULLANILMALI.** Sekme çubuğu, araç çubuğu düğmeleri, yüzen eylem düğmeleri (FAB), aktif sayaç kapsülü (`tabViewBottomAccessory`) ve hızlı seçim tekerleği üst katmanı. | Ana ekranda altta yüzen "Emzir / Uyku / Bez" hızlı başlatma kapsüllerinde ve aktif sayaç barında kullanılır. |
| **İçerik Katmanı (Kartlar, Listeler, Tablolar, Grafikler)** | **KULLANILMAMALI.** HIG açıkça uyarır: *"Don't use Liquid Glass in the content layer."* İçerik kartlarını cam yapmak hem GPU yükünü artırır hem de görsel hiyerarşiyi bozar. | Ninnly'nin **"kutu/panel yok, yüzen tipografi"** kuralıyla %100 örtüşür: içerik katmanında hiçbir kart veya cam kutu olmayacak; metinler ve grafikler doğrudan zemin üzerinde yüzecektir. |
| **Cam Üzerine Cam (Glass on Glass)** | **KULLANILMAMALI.** Bir Liquid Glass yüzeyin üzerine ikinci bir Liquid Glass bileşen bindirmek kırılma (refraction) karmaşası ve kontrast kaybı yaratır. | Yarım ekran bir sayfa (Sheet) açıldığında, sayfa içindeki öğelerde tekrar `.glassEffect()` kullanılmaz. |
| **Gece Fazı (20:00–06:30)** | **DİKKATLİ / KISITLI KULLANILMALI.** Standart `.regular` cam malzemesi parlak beyaz speküler kenar yansımaları üretebilir. | Gece fazında parlak speküler yansımaları önlemek için `.glassEffect(.regular.tint(nightCoral.opacity(0.18)))` veya düşük opaklıklı koyu kehribar yüzey kullanılır; saf beyaz parlama engellenir. |

### 1.4. SwiftUI Liquid Glass API'leri
Apple'ın iOS 26+ için sunduğu temel SwiftUI API'leri şunlardır (`https://developer.apple.com/documentation/swiftui/applying-liquid-glass-to-custom-views`):

1. **`.glassEffect(_:in:isEnabled:)`:** Özel bir görünüme Liquid Glass malzemesi uygular (`https://developer.apple.com/documentation/swiftui/view/glasseffect(_:in:isenabled:)`).
   * `Glass.regular`: Standart adaptif cam malzemesi.
   * `Glass.clear`: Zengin medya/arka planlar üzerinde daha şeffaf varyant.
   * `Glass.identity`: Efekti koşulsuz/koşullu devre dışı bırakmak için birim değer.
   * Zincirlenebilir metodlar: `.tint(_:)` (camı marka rengiyle hafifçe boyar) ve `.interactive(_:)` (dokunma/basma anında camın fiziksel olarak esneyip parlamasını sağlar).
2. **`GlassEffectContainer(spacing:content:)`:** Birden fazla cam öğeyi tek bir optik grup içinde toplar; öğeler birbirine yaklaştığında su damlaları gibi birleşir (*morphing*) ve GPU'da tek geçişte çizilir (`https://developer.apple.com/documentation/swiftui/glasseffectcontainer`).
3. **`.glassEffectID(_:in:)` ve `.glassEffectUnion(id:namespace:)`:** `@Namespace` ile birlikte kullanılarak durum değiştiğinde (örneğin "Emzir" düğmesi "Sol / Sağ" iki düğmeye ayrıldığında) cam yüzeylerin kopmadan akışkan şekilde bölünüp birleşmesini sağlar (`https://developer.apple.com/documentation/swiftui/view/glasseffectid(_:in:)`).
4. **`.buttonStyle(.glass)` ve `.buttonStyle(.glassProminent)`:** Standart SwiftUI `Button` bileşenlerine sistem cam stilini doğrudan uygular (`https://developer.apple.com/documentation/swiftui/glassbuttonstyle`).
5. **Gezinme ve Kaydırma Yardımcıları:** `.tabBarMinimizeBehavior(.onScrollDown)`, `.tabViewBottomAccessory { ... }`, `.scrollEdgeEffectStyle(.soft, for: .top)` ve `.toolbarBackgroundVisibility(_:for:)` (`https://developer.apple.com/documentation/swiftui/tabview`).

---

## 2. Uygulama İkonu: iOS 26 Icon Composer ve `hilal-bebek.jpg` Analizi

### 2.1. iOS 26 Icon Composer ve Katmanlı İkon Mimarisi (`.icon`)
iOS 26 ile birlikte uygulama ikonları tek katmanlı düz `1024×1024` PNG dosyalarından, Xcode 26 ile gelen **Icon Composer** aracıyla üretilen çok katmanlı **`.icon`** paketlerine evrilmiştir (`https://developer.apple.com/design/human-interface-guidelines/app-icons`, `https://developer.apple.com/documentation/xcode/creating-your-app-icon-using-icon-composer`).
* **Katman Yapısı:** Bir arka plan katmanı (*Background*) ve üst üste dizilen **1 ila 4+ ön plan katmanı/grubu (*Foreground Layers*)** bulunur (`https://developer.apple.com/videos/play/wwdc2025/220/`).
* **Dinamik Cam Özellikleri:** Icon Composer her katmana gerçek zamanlı **speküler kenar parlaması (specular highlights)**, alt katmanı büken **ışık kırılması (refraction)**, **yarı saydamlık (translucency)** ve cihazın jiroskop hareketine tepki veren **dinamik gölge/derinlik** uygular (`https://developer.apple.com/documentation/xcode/creating-your-app-icon-using-icon-composer`).
* **Sistem Görünüm Modları (Appearances):**
  1. **Açık (Default / Light):** Tam renkli arka plan ve katmanlı cam ön plan.
  2. **Koyu (Dark):** Arka plan koyulaştırılır/siyahlaştırılır, ön plan katmanları kendi renklerini ve kenar ışık kırılmalarını korur.
  3. **Renklendirilmiş (Tinted / Home Screen Tint):** Kullanıcının seçtiği tek bir vurgu rengi siyah/koyu zemin üzerindeki katmanlara derinlik gradyanı olarak uygulanır.
  4. **Şeffaf / Cam (Clear / All-Glass):** iOS 26'da yeni eklenen bu görünümde ikonun arka plan rengi tamamen şeffaf cam haline gelir, ana ekran duvar kağıdı ikonun içinden kırarak görünür ve ön plan katmanları buzlu/parlak cam silüetlere dönüşür (`https://developer.apple.com/design/human-interface-guidelines/app-icons`).

### 2.2. Tek Parça Raster Bir İkon (`hilal-bebek.jpg`) iOS 26'da Nasıl Görünür?
Himmet'in kararı doğrultusunda (`docs/PLAN.md` §3: *"Uygulama ikonu bu görselin değiştirilmemiş halidir (`docs/marka/aday/hilal-bebek.jpg` → 1024 px)... Koyu ve renklendirilmiş ikon varyantlarını sistem üretiyor"*), Xcode Asset Catalog'a veya Icon Composer'a **tek parça düz raster (1024×1024 JPEG/PNG)** verilirse iOS 26'da şu davranış gerçekleşir (`https://developer.apple.com/documentation/xcode/configuring-your-app-icon`):
1. **Dış Çerçeve (Squircle) Cam Efekti:** Sistem, `1024×1024` düz görseli iOS 26'nın yeni yuvarlatılmış kare (*continuous corners*) maskesiyle keser ve **yalnızca ikonun en dış sınırına** sistem standart speküler cam çerçeve parlamasını (*outer rim specular highlight*) otomatik uygular (`https://developer.apple.com/design/human-interface-guidelines/app-icons`).
2. **İç Katman Derinliği ve Jiroskop Tepkisi Olmaz:** Sistem, düz bir JPEG/PNG'nin içindeki hilali ve bebeği arka plandan otomatik olarak (yapay zekâ/segmentasyon ile) **katmanlara ayırmaz**. Bu nedenle telefonu eğdiğinizde hilalin arka plan dalgaları üzerinde kayması veya iç kenarlarında dinamik ışık kırılması gerçekleşmez; görselin kendi içinde zaten çizilmiş olan kağıt kesiği (*paper-cut*) gölgeleri statik olarak görünür.
3. **Koyu (Dark), Renklendirilmiş (Tinted) ve Şeffaf (Clear) Mod Riski:**
   * **Açık ve Koyu Mod:** `hilal-bebek.jpg` zaten koyu çam yeşili/antrasit bir zemine sahip olduğu için hem Açık hem Koyu modda **çok şık ve doğal** durur.
   * **Renklendirilmiş (Tinted) ve Şeffaf (Clear) Mod Uyarısı:** Eğer ayrı bir monokrom/alfa maskesi veya katman verilmezse, iOS 26 tam kare raster görseli luminans (parlaklık) haritasına göre tek renge boyamaya çalışır (`https://developer.apple.com/design/human-interface-guidelines/app-icons`). `hilal-bebek.jpg` içinde arka planda 5 farklı yeşil dalga tonu bulunduğu için, Şeffaf (*Clear*) modda ikonun içi tam şeffaf cam olamaz; bunun yerine kare kutu şeklinde yarı-bulanık bir plaka gibi görünebilir.

### 2.3. `docs/marka/aday/hilal-bebek.jpg` Görsel İncelemesi ve Önerilen Katman Ayrımı
`docs/marka/aday/hilal-bebek.jpg` dosyası incelendiğinde, görselin **zaten katmanlı kağıt kesiği (3D paper-cut / layered craft) estetiğinde** üretildiği görülmektedir:
* **Zemin:** Sol alttaki en koyu antrasit/siyahtan (`#0F1412`, `#171F1C`) sağ üstteki orman/adaçayı yeşiline (`#2D473B`, `#39584A`, `#436556`) doğru diyagonal uzanan **5 kademeli dalgalı katman**.
* **Ön Plan:** Merkezde çift pahlı/katmanlı **mercan hilal** (`#F59B6C` → `#E47953` → `#C95B3C`), hilalin iç kavisinden bebeği saran **mercan-şeftali iç kundak kolu**, sağda damla formlu **krem/fildişi kundak** (`#F6F0E4`) ve üstte kapalı göz çizgisine (`︶`, `#2D473B`) sahip **krem bebek başı**.

**Himmet'in "görseli mahvetme / olduğu gibi kullan" kuralını bozmadan**, piksel-birebir alfa maskeleme (Photoshop/Pixelmator/alfa kanalı kesimi, yeniden çizim yapmadan!) ile **Icon Composer (`.icon`)** için önerilen 4 katmanlı yapı:

| Katman Sırası (Arkadan Öne) | Katman Adı | İçerik (`hilal-bebek.jpg`'den Birebir Kesim) | Dosya Biçimi | Icon Composer Ayarı |
| :--- | :--- | :--- | :--- | :--- |
| **0 (Arka Plan)** | `Background_Waves` | Sol alttan sağ üste 5 diyagonal koyu yeşil/antrasit dalga (hilal arkası doldurulmuş/inpainted). | **PNG (24-bit, opak, 1024×1024, Display P3)** | `Background` katmanı (Clear/Tinted modda sistem tarafından otomatik gizlenir). |
| **1 (Alt Ön Plan)** | `Layer1_Swaddle_Cream` | Sağdaki damla formlu krem kundak (`#F6F0E4`) + üstteki yuvarlak krem bebek başı (kapalı göz oyuğu şeffaf veya koyu yeşil). | **PNG (32-bit RGBA şeffaf, 1024×1024, P3)** | Opaklığı %95, hafif iç kırılma (Refraction: Düşük), yumuşak alt gölge. |
| **2 (Orta Ön Plan)** | `Layer2_Inner_Cradle` | Bebeğin gövdesini soldan saran iç mercan-şeftali kundak/kol katmanı (`#E47953`). | **PNG (32-bit RGBA şeffaf, 1024×1024, P3)** | Liquid Glass açık, Specular Highlight: Otomatik, orta derinlik. |
| **3 (Üst Ön Plan)** | `Layer3_Crescent_Moon` | En dıştaki iki kademeli ana mercan hilal gövdesi (`#F59B6C` / `#C95B3C`). | **PNG (32-bit RGBA şeffaf, 1024×1024, P3)** | En üst katman; Specular Highlight açık (cihaz eğildiğinde hilalin sırtı parlar). |

* **Neden SVG Değil de 32-bit RGBA PNG Katmanları?** Icon Composer hem vektör **SVG** hem de şeffaf **PNG** kabul eder (`https://developer.apple.com/documentation/xcode/creating-your-app-icon-using-icon-composer`). Ancak `hilal-bebek.jpg` içindeki yumuşak fırça/ışık geçişlerini SVG'ye dönüştürmeye çalışmak görseli plastikleştireceği (ve Himmet tarafından reddedildiği) için, **orijinal raster piksellerin alfa maskesiyle ayrılmış 1024×1024 şeffaf PNG katmanları** olarak Icon Composer'a verilmesi orijinal görseli %100 korurken iOS 26'nın Clear/Tinted/Dark modlarını kusursuz çalıştırır.

---

## 3. Gece Renk Bilimi: Melatonin, Işık Spektrumu, Night Shift ve `UIScreen.brightness`

### 3.1. Ekran Işığının Melatonine Etkisi (ipRGC ve Melanopsin)
İnsan retinasında görüntü oluşturmayan, doğrudan beynin sirkadiyen merkezine (suprakiazmatik çekirdek — SCN) sinyal gönderen **intrinsik fotosensitif retinal ganglion hücreleri (ipRGC)** bulunur (`https://pubmed.ncbi.nlm.nih.gov/11517269/`).
* **Tepe Duyarlılık ($\approx 446\text{–}484\text{ nm}$):** Brainard ve ark. (2001) tarafından *The Journal of Neuroscience*'ta yayınlanan temel çalışmaya göre, insanlarda gece melatonin baskılanmasının aksiyon spektrumu kısa dalga boylu **mavi ışık bandında (446–477 nm, melanopsin fotopigmenti tepe noktası $\approx 480\text{ nm}$)** zirve yapar (`https://pubmed.ncbi.nlm.nih.gov/11517269/`).
* **Gece Ekran Kullanımının Klinik Sonucu:** Chang ve ark. (2015) tarafından *PNAS*'ta yayınlanan randomize çapraz çalışmada, yatmadan önce ışık yayan ekran kullananlarda melatonin salgısının **%55,12 ($\pm 20,12$)** oranında baskılandığı (basılı kitapta %$-18,77$), sirkadiyen ritmin **1,5 saatten fazla geciktiği** ve uykuya dalma süresinin uzadığı kanıtlanmıştır (`https://pubmed.ncbi.nlm.nih.gov/25535358/`, `https://www.pnas.org/doi/10.1073/pnas.1418490112`). Gece 03:00'te emzirmeye kalkan bir ebeveyn için beyaz veya mavi pikselli bir ekran, hem annenin tekrar uykuya dalmasını engeller hem de bebeğin gözüne yansıyan mavi fotonlarla bebeği uyandırır.

### 3.2. Mavi, Kehribar (Amber) ve Kırmızı Işık: Neden Beyaz ve Mavi Yasak?
* **OLED Piksel Fiziği:** iPhone'ların Super Retina XDR (OLED) ekranlarında **saf beyaz (`#FFFFFF`)** bir piksel üretmek için Kırmızı (R), Yeşil (G) ve **Mavi (B) alt piksellerin tamamı %100 güçte** yanar. Dolayısıyla "beyaz metin" aslında yoğun bir 460 nm mavi ışık kaynağıdır.
* **Kırmızı ve Kehribar ($\ge 590\text{–}630\text{ nm}$):** Melanopsin fotopigmentinin duyarlılığı $590\text{ nm}$ (kehribar/turuncu-mercan) üzerinde hızla düşer ve $620\text{ nm}$ (kırmızı) üzerinde neredeyse sıfıra yaklaşır (`https://pubmed.ncbi.nlm.nih.gov/11517269/`).
* **Ninnly Gece Fazı Kuralının Bilimsel Doğrulaması:** Gece fazında (20:00–06:30) **hiçbir beyaz (`#FFFFFF`) ve mavi (`B > G` veya yüksek `B` kanallı) renk kullanılmaması**, metin ve kontrollerin düşük mavi kanallı sıcak mercan/kehribar (`#E89A6C`, `#E06D44`) ve koyu obsidyen/çam zemin (`#080B0A` / `#0F1412`) ile sınırlandırılması sirkadiyen biyolojiyle tam uyumludur.

### 3.3. Night Shift İlişkisi: Yalnızca Renk Sıcaklığını Değiştirmek Yeterli mi?
Apple'ın iOS sistem özelliği olan **Night Shift**, gün batımından sonra ekranın ilişkili renk sıcaklığını (CCT) spektrumun sıcak ucuna kaydırır (`https://support.apple.com/en-us/102635`). Ancak:
* **Hakemli Araştırma Bulgusu:** Nagare, Plitnick ve Figueiro (2019, *Lighting Research & Technology* — Rensselaer Polytechnic Institute Aydınlatma Araştırma Merkezi), iPad **Night Shift** modunu düşük ve yüksek sıcaklıklarda test etmiş ve şu sonuca varmıştır: *"Changing screen color alone is insufficient for limiting acute nocturnal melatonin suppression; screen brightness should also be reduced."* (`https://pubmed.ncbi.nlm.nih.gov/30905279/`).
* **Ninnly İçin Anlamı:** Kullanıcının telefonunda Night Shift açık olsa dahi, uygulama açık/beyaz bir arayüz gösteriyorsa yüksek toplam foton akısı (parlaklık) melatonini yine baskılar. Öte yandan kullanıcı Night Shift'i **en sıcak ayarda** açmışsa ve Ninnly gece fazında aşırı koyu saf kırmızı (`#FF0000`) kullanırsa, Night Shift üstüne bindiğinde kontrast aşırı düşebilir. Bu nedenle Ninnly gece fazında okunabilirliği koruyan **sıcak mercan-kehribar (`#F0A375` / `#E47953`)** tonlarını koyu zemin (`#0B0F0D`) üzerinde kullanmalıdır.

### 3.4. Uygulamanın Ekran Parlaklığını Kendisinin Kısması (`UIScreen.brightness`) Uygun mu?
Apple'ın `UIScreen.brightness` API'si (`0.0` ile `1.0` arası `CGFloat`) teknik olarak mevcuttur (`https://developer.apple.com/documentation/uikit/uiscreen/brightness`). Ancak otomatik parlaklık kısma konusunda mühendislik ve HIG kuralları çok nettir:
1. **Apple Dokümantasyonu Davranışı:** Apple resmi dokümantasyonunda, bu özelliğin yalnızca barkod/QR okuyucu veya el feneri gibi ekranın belirli bir parlaklıkta olmasını **zorunlu kılan** durumlarda kullanılmasını, uygulama arka plana geçtiğinde veya kapandığında sistemin parlaklığı eski haline döndürdüğünü belirtir (`https://developer.apple.com/documentation/uikit/uiscreen/brightness`). Ayrıca iOS 16+ ve çoklu sahne (`UIWindowScene`) mimarisinde `UIScreen.main` kullanımı aşamalı olarak kullanımdan kaldırılmaktadır (*deprecated*: `windowScene.screen.brightness` üzerinden erişilir).
2. **Kullanıcı Deneyimi ve HIG Görüşü:** Uygulama açılır açılmaz kullanıcıdan habersiz `screen.brightness = 0.05` yapmak **kötü bir UX pratiğidir**; çünkü ebeveyn aydınlık bir odada (saat 20:15'te salonda ışıklar açıkken) uygulamayı açtığında ekran bir anda kararır ve okunamaz hale gelir.
3. **Ninnly İçin Doğru Mimari:**
   * **Varsayılan:** Parlaklığı donanımsal olarak (`UIScreen.brightness`) **otomatik kısma!** Bunun yerine koyu OLED zemin (`#0B0F0D` — piksellerin %90'ı kapalı) ve düşük parlaklıklı mercan/kehribar renk paletiyle **yazılımsal ışık emisyonunu** düşür.
   * **Opsiyonel "Gece Ekstra Karartma" (Extra Dim) Anahtarı:** Gece fazı ayarlarına kullanıcı kontrollü bir **"Gece Ekran Parlaklığını Otomatik Kıs"** seçeneği (varsayılan: **Kapalı**) veya uygulama içi yarı saydam siyah katman (*software dimmer overlay*) ekle.

---

## 4. Hareket Tasarımı: HIG Motion, SwiftUI Animasyonları, Swift Charts ve Haptik

### 4.1. Apple Hareket İlkeleri (HIG Motion) ve "Hareketi Azalt"
Apple'ın HIG *Motion* kılavuzu (`https://developer.apple.com/design/human-interface-guidelines/motion`) dört temel kural koyar:
1. **Amaca Yönelik Hareket (Purposeful Motion):** Hareket yalnızca süsleme için değil; geri bildirim vermek (düğmeye basıldığını hissettirmek), durum geçişini anlatmak (emzirmeden sağ memeye geçiş) ve dikkat yönlendirmek için kullanılır.
2. **Kısa, Kesilebilir ve 120 Hz (ProMotion) Uyumlu:** Hiçbir animasyon kullanıcıyı bekletmemeli; animasyon oynarken kullanıcı tekrar dokunduğunda anında yarıda kesilip (*interruptible*) yeni hedefe yönelmelidir (`https://developer.apple.com/design/human-interface-guidelines/motion`).
3. **Bilinçaltı Gerçekçilik ve Gece Hassasiyeti:** Gece fazında yüksek genlikli zıplamalar, flaş çakmaları veya hızlı yanıp sönmeler hem yorgun gözü yorar hem de karanlık odada ışık çakması yaratır.
4. **Hareketi Azalt (`accessibilityReduceMotion`):** Kullanıcı sistemde *Hareketi Azalt* ayarını açtığında (`@Environment(\.accessibilityReduceMotion)`), ölçekleme (`scaleEffect`), kaydırma ve dönme animasyonları iptal edilip yerine yumuşak opaklık geçişi (`.opacity` cross-dissolve) uygulanmalıdır (`https://developer.apple.com/documentation/swiftui/environmentvalues/accessibilityreducemotion`).

### 4.2. SwiftUI Yay (Spring) Animasyonları, `PhaseAnimator` ve `KeyframeAnimator`
iOS 17+ ve iOS 26'da yerel SwiftUI hareket motoru Lottie veya Rive gerektirmeden 120 fps çalışır (`https://developer.apple.com/documentation/swiftui/animations`):
* **Yay (Spring) Ön Ayarları:**
  * `.snappy(duration: 0.25, extraBounce: 0.08)`: Hızlı düğme basımları, sekme geçişleri ve sol/sağ göğüs seçimi (`matchedGeometryEffect`) için idealdir (`https://developer.apple.com/documentation/swiftui/animation/snappy(duration:extrabounce:)`).
  * `.smooth(duration: 0.35)`: Zıplamasız (`bounce: 0`), sakin geçişler ve **Gece Fazı** varsayılan yay eğrisidir (`https://developer.apple.com/documentation/swiftui/animation/smooth(duration:extrabounce:)`).
  * `.bouncy(duration: 0.4, extraBounce: 0.15)`: 0,7 saniyelik basılı tutma onayı tamamlandığında oynayan küçük "tamam" kutlama anı için kullanılır (`https://developer.apple.com/documentation/swiftui/animation/bouncy(duration:extrabounce:)`).
* **`PhaseAnimator`:** Çok adımlı durum geçişlerini bildirimsel olarak döndürür (`https://developer.apple.com/documentation/swiftui/phaseanimator`).
  * *Ninnly Kullanımı:* Aktif çalışan emzirme/uyku sayacı düğmesinin yavaşça **"nefes alması"** (`scale: 1.0 ↔ 1.035`, `opacity: 0.88 ↔ 1.0`, gündüz `2.4 sn`, gece `3.6 sn` periyotla).
* **`KeyframeAnimator`:** Birden fazla özelliğin (`scale`, `verticalStretch`, `rotation`, `opacity`) zaman ekseni üzerinde milisaniyelik bağımsız eğrilerle (`SpringKeyframe`, `CubicKeyframe`, `LinearKeyframe`) yönetilmesini sağlar (`https://developer.apple.com/documentation/swiftui/keyframeanimator`).
  * *Ninnly Kullanımı:* 0,7 sn basılı tutma halkası dolduğunda düğmenin hafifçe içe çekilip (`0.94`) yukarı doğru elastik büyümesi (`1.06`) ve yerine oturması (`1.0`).
* **Akan Sayılar ve Semboller:**
  * `.contentTransition(.numericText(countsDown: ...))`: Sayaç saniyelerinin, ml değerlerinin ve geri sayımların mekanik saat gibi akarak değişmesini sağlar (`https://developer.apple.com/documentation/swiftui/contenttransition/numerictext(countsdown:)`).
  * `.symbolEffect(.bounce, value:)` ve `.symbolEffect(.pulse)`: SF Symbols ikonlarının durum değişiminde canlanması için kullanılır (`https://developer.apple.com/documentation/swiftui/view/symboleffect(_:options:value:)`).

### 4.3. Swift Charts Animasyonları ve Etkileşimli Tarama (Scrubbing)
Swift Charts (`import Charts`), veri dizisi `withAnimation(.smooth(duration: 0.45))` içinde güncellendiğinde çubukları (`BarMark`), çizgileri (`LineMark`) ve alanları (`AreaMark`) otomatik olarak enterpole eder (`https://developer.apple.com/documentation/charts`).
* **İlk Açılış Çizim Animasyonu:**
  * **Çubuk Grafikler (Günlük emzirme/bez/uyku süresi):** Her veri noktasının Y değeri ilk görünümde `0`'dan gerçek değerine `.spring(duration: 0.5, bounce: 0.1).delay(Double(index) * 0.03)` ile yükselir.
  * **Çizgi Grafikler (DSÖ Persentil Eğrileri ve Sağ/Sol Denge):** Grafik üzerinde soldan sağa açılan bir `.mask(alignment: .leading)` genişlik animasyonu veya veri noktası ilerlemesi ile çizgi soldan sağa doğru akarak çizilir.
* **Parmakla Tarama (`chartXSelection(value: $selectedDate)`):** iOS 17+ ile gelen yerel seçim API'si sayesinde ebeveyn parmağını grafik üzerinde gezdirdiğinde dikey bir `RuleMark` imleci kayar, üstte yüzen tipografik değer güncellenir ve her veri noktası değişiminde hafif bir haptik "tık" tetiklenir (`https://developer.apple.com/documentation/charts/view/chartxselection(value:)`).

### 4.4. Dokunsal Geri Bildirim (`sensoryFeedback`) Ölçüsü
SwiftUI'ın `.sensoryFeedback(_:trigger:)` değiştiricisi (`https://developer.apple.com/documentation/swiftui/view/sensoryfeedback(_:trigger:)`) Taptic Engine'i doğrudan kontrol eder. Bebek uyurken aşırı veya sert titreşim (`.error` / `.warning` ağır darbeleri) sessiz odada duyulabilir vızıltı yaratabileceği için Ninnly'de **ölçülü haptik matrisi** uygulanmalıdır (`https://developer.apple.com/design/human-interface-guidelines/playing-haptics`):

| Etkileşim Anı | `SensoryFeedback` Türü | Neden ve Ölçü Kuralı |
| :--- | :--- | :--- |
| **Normal Düğme / Sekme Dokunuşu** | `.impact(flexibility: .soft, intensity: 0.6)` | Yumuşak, sessiz fiziksel yastıklama hissi verir. |
| **Sayı Tekerleği & Grafik Tarama (`chartXSelection`)** | `.selection` | Yalnızca tam birim/nokta değiştiğinde tek bir mikro "tık" üretir; ara piksellerde sürekli titremez. |
| **0,7 sn Basılı Tutma Başlangıcı** | `.impact(weight: .light, intensity: 0.5)` | Kullanıcının basılı tutmanın algılandığını anlamasını sağlar. |
| **0,7 sn Basılı Tutma Onayı Tamamlandı** | `.success` | İşlemin kaydedildiğini ekrana bakmadan bile (gece emzirirken) kesin olarak bildirir. |
| **Sürekli Çalışan Sayaç (Her Saniye)** | **HAPTİK YOK** | Her saniye titreşim pil tüketir ve kullanıcıyı rahatsız eder; kesinlikle kullanılmaz. |

---

## 5. Tipografi: SF Pro Rounded, Dynamic Type ve Türkçe Karakter Sorunları

### 5.1. SF Pro Rounded Kullanımı ve Optik Karakteri
Apple'ın sistem yazı tipi ailesinin yuvarlatılmış uçlu varyantı olan **SF Pro Rounded**, SwiftUI'da harici font dosyası gömmeye gerek kalmadan `.font(.system( style, design: .rounded, weight: ...))` veya `.fontDesign(.rounded)` ile doğrudan çağrılır (`https://developer.apple.com/design/human-interface-guidelines/typography`, `https://developer.apple.com/documentation/swiftui/view/fontdesign(_:)`).
* **Ninnly İçin Avantajı:** Keskin geometrik köşeler yerine sıcak, organik ve bebek dostu yuvarlak uçlar sunar; üstelik sistem fontu olduğu için uygulama boyutuna **0 KB** yük bindirir ve tüm ağırlıkları (`ultralight` → `black`) destekler.
* **Sayaçlarda Zorunlu Kural (`monospacedDigit()`):** Emzirme ve uyku kronometrelerinde saniyeler akarken (`04:11` → `04:12`) rakam genişlikleri değişirse tüm yüzen tipografi sağa-sola titrer (*jitter*). Bunu önlemek için tüm sayaç, saat ve tablo rakamlarında `.monospacedDigit()` değiştiricisi zorunlu olarak zincirlenmelidir (`https://developer.apple.com/documentation/swiftui/font/monospaceddigit()`).

### 5.2. iOS Dynamic Type Ölçek Tablosu (Varsayılan `Large` ve Erişilebilirlik)
Apple HIG *Typography* spesifikasyonuna göre iOS'ta varsayılan (**Large**) boyutta temel metin stilleri ve erişilebilirlik (**AX5 / Accessibility XXXL**) tavan değerleri şöyledir (`https://developer.apple.com/design/human-interface-guidelines/typography#Specifications`):

| Metin Stili (SwiftUI) | Varsayılan Ağırlık | Boyut (`Large` - Varsayılan) | Satır Yüksekliği (Leading) | Erişilebilirlik Tavanı (`AX5`) | Ninnly Kullanım Yeri |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `.largeTitle` | Regular (Ninnly: Bold) | **34 pt** | 41 pt | 60 pt | Aktif sayaç ana rakamı / Ekran başlığı |
| `.title` (`Title 1`) | Regular (Semibold) | **28 pt** | 34 pt | 53 pt | "Uyku Penceresi" geri sayım süresi |
| `.title2` | Regular (Semibold) | **22 pt** | 28 pt | 47 pt | Modül bölüm başlıkları |
| `.title3` | Regular (Medium) | **20 pt** | 25 pt | 43 pt | Hızlı özet metrikleri (Toplam ml / saat) |
| `.headline` | **Semibold** | **17 pt** | 22 pt | 40 pt | Yüzen eylem düğmeleri ve aktif satır başlığı |
| `.body` | Regular | **17 pt** | 22 pt | 40 pt | Ana kayıt satırları ve açıklamalar |
| `.callout` | Regular | **16 pt** | 21 pt | 38 pt | Yardımcı bilgi / Son kullanılan göğüs etiketi |
| `.subheadline` | Regular | **15 pt** | 20 pt | 36 pt | Zaman damgaları ve alt etiketler |
| `.footnote` | Regular | **13 pt** | 18 pt | 33 pt | Tıbbi kaynak ve metodoloji dipnotları |
| `.caption` (`Caption 1`) | Regular | **12 pt** | 16 pt | 31 pt | Grafik eksen etiketleri |
| `.caption2` | Regular | **11 pt** | 13 pt | 29 pt | İkincil rozetler |

* **Kutusuz Arayüzde `dynamicTypeSize` Sınırı:** Kronometre (`56 pt` özel büyük sayaç) veya alt hızlı işlem düğmeleri `AX5` boyutunda ekran dışına taşmasın diye, ana sayaç rakamında `.dynamicTypeSize(...DynamicTypeSize.accessibility1)` üst sınırı uygulanmalı; metin listelerinde ise `AX5`'e kadar tam ölçekleme ve `ViewThatFits` / dikey yığın (`AnyLayout`) geçişi desteklenmelidir (`https://developer.apple.com/documentation/swiftui/view/dynamictypesize(_:)`).

### 5.3. Türkçe Karakterlerle (`ı, ğ, ş, İ, Ö, Ü, Ç`) Yaşanan Teknik Sorunlar ve Çözümleri
1. **Büyük `İ` ve `Ö/Ü` Üst Nokta Kırpılması (Ascender / Cap-Height Clipping):**
   * *Sorun:* Büyük noktalı **`İ`** harfinin noktası, standart Latin büyük harf yüksekliğinin (*cap-height*) belirgin biçimde üzerine çıkar. SwiftUI'da bir metne sabit `.frame(height: ...)` verildiğinde, negatif `.lineSpacing` kullanıldığında veya çok dar `ScrollView` / `GeometryReader` sınırlarında **"İLK 100 BESİN"**, **"İLAÇ"** veya **"İĞNE"** kelimelerindeki `İ` harfinin noktası üstten kesilir.
   * *Çözüm:* Metin kapsayıcılarına **asla sabit `height` verilmemeli**, dikey boşluk `.padding(.vertical, ...)` ile bırakılmalı ve büyük başlıklarda `.lineSpacing(2)` veya sistemin doğal satır yüksekliği korunmalıdır.
2. **Alt Çengel Kırpılması (`ş`, `ç`, `ğ` Descender / Diacritic Collision):**
   * *Sorun:* Küçük `ş` ve `ç` harflerinin alt çengeli (*cedilla*), hemen alt satırdaki büyük `İ`, `Ğ`, `Ö`, `Ü` harflerinin üst işaretleriyle sıkışık satırlarda çarpışabilir.
   * *Çözüm:* Çok satırlı Türkçe metinlerde satır aralığı daraltılmamalı (`.lineSpacing(3)` eklenmeli).
3. **`uppercased()` Yerel Dil Hatası (`i` → `I` vs `İ`, `ı` → `I`):**
   * *Sorun:* Swift'in standart `String.uppercased()` metodu `Locale` belirtilmezse İngilizce kurallarıyla çalışır ve `"emzirme".uppercased()` çağrısını yanlışlıkla **`"EMZIRME"`** (noktasız `I`) olarak çevirir; `"ışık"` kelimesini ya da `"iğne"` kelimesini bozar (`https://developer.apple.com/documentation/foundation/nsstring/1408694-uppercased`).
   * *Çözüm:* Kod tabanında ham `.uppercased()` veya `.lowercased()` kullanımı **yasaklanmalı**; SwiftUI `Text` üzerinde `.textCase(.uppercase)` (ortamın `\.locale` değerini otomatik kullanır) veya String üzerinde `str.uppercased(with: Locale(identifier: "tr"))` / `.localizedUppercase` kullanılmalıdır (`https://developer.apple.com/documentation/swiftui/view/textcase(_:)`).

---

## 6. Kutusuz "Yüzen Tipografi" Arayüz: Örnekler, Riskler ve Çözüm Kuralları

### 6.1. İyi Örnek Uygulamalar (Kart ve Çerçeve Olmadan Hiyerarşi)
Ninnly'nin **"arayüzde kutu/panel yok, yüzen tipografi"** kararı, iOS tasarım dünyasında en üst düzey (Apple Design Award çizgisindeki) uygulamalarda kullanılan "içerik-öncelikli" (*content-first / typographic UI*) yaklaşımdır:
1. **Apple Saat (Clock - Dünya Saati / Kronometre) & Hava Durumu (Weather):** Kronometre ekranında dev bir `monospacedDigit` sayaç doğrudan siyah boşlukta yüzer; altında kutusuz ince turuncu/yeşil yuvarlak eylem düğmeleri ve sade satır listesi yer alır (`https://developer.apple.com/design/human-interface-guidelines/designing-for-ios`).
2. **Endel (iOS / watchOS):** Kutu, kart ve ızgara çizgisi olmadan, doğrudan koyu arka plan üzerinde yüzen tipografi ve akışkan generatif hareketlerle çalışan ödüllü uyku/odaklanma uygulaması (`https://endel.io/`).
3. **SolarWatch / Clear (Minimalist iOS Klasikleri):** Rengi, tipografik boyutu (`34 pt` vs `15 pt`) ve boşluğu (*negative space*) birer kutu sınırı yerine kullanarak tek elle gözü yormayan ekranlar sunar.

### 6.2. Kutusuz Arayüzün 3 Kritik Riski ve Mühendislik Çözümleri

#### Risk 1: Dokunma Hedefi Belirsizliği (Touch Target & Hit-Testing)
* **Sorun:** Bir düğmenin etrafında görünür bir kutu veya çerçeve olmadığında,1) kullanıcı nereye dokunabileceğini anlayamayabilir (*affordance* kaybı), 2) SwiftUI'da yalnızca metinden oluşan bir `Button` içinde metnin etrafındaki boşluklar tıklamayı algılamaz veya dokunma alanı HIG minimumunun altına düşer.
* **HIG ve WCAG Standartları:**
  * **Apple HIG:** Tüm etkileşimli öğeler için minimum **44 × 44 pt** dokunma hedefi şarttır (`https://developer.apple.com/design/human-interface-guidelines/accessibility#Buttons-and-controls`).
  * **WCAG 2.2:** Madde **2.5.8 Target Size (Minimum) (AA)** en az **24 × 24 CSS px**, Madde **2.5.5 Target Size (Enhanced) (AAA)** ise en az **44 × 44 CSS px** şart koşar (`https://www.w3.org/TR/WCAG22/#target-size-minimum`). Gece 03:00'te tek başparmakla yarı uykulu kullanım için Ninnly'de ana eylem hedefleri **minimum 48–56 pt yüksekliğinde** olmalıdır.
* **SwiftUI Çözümü:**
  1. Görünür kutu olmasa bile her etkileşimli satıra `.frame(minWidth: 44, minHeight: 48)` ve **`.contentShape(Rectangle())`** eklenmelidir; böylece metnin sağındaki/solundaki boşluğa dokunulduğunda da düğme tetiklenir (`https://developer.apple.com/documentation/swiftui/view/contentshape(_:eofill:)`).
  2. Tıklanabilir yüzen metinlerin yanına bir **SF Symbol ikonu** (`chevron.right`, `play.fill`, `plus`) veya iOS 26'da yalnızca etkileşimli öğelerde kullanılan **Liquid Glass kapsülü (`.glassEffect`)** konularak "statik veri" ile "dokunulabilir düğme" net biçimde ayrılır.
  3.Kullanıcı sistemde **Düğme Şekillerini Göster (`accessibilityShowButtonShapes`)** ayarını açtığında kutusuz düğmelerin altı çizili veya kapsüllü görünmesi sağlanır (`https://developer.apple.com/documentation/swiftui/environmentvalues/accessibilityshowbuttonshapes`).

#### Risk 2: Kontrast Oranı (WCAG 1.4.3 ve 1.4.11)
* **Sorun:** Kart arka planı olmadığında metinler doğrudan ana zemin üzerinde (veya katmanlı dalga geçişleri üzerinde) durur.
* **WCAG 2.2 Kuralları (`https://www.w3.org/TR/WCAG22/`):**
  * **1.4.3 Contrast (Minimum) (AA):** Normal metin (<18 pt veya <14 pt bold) için en az **4.5:1**, büyük metin (≥18 pt veya ≥14 pt bold) için en az **3.0:1** kontrast oranı.
  * **1.4.6 Contrast (Enhanced) (AAA):** Normal metin için **7.0:1**, büyük metin için **4.5:1**.
  * **1.4.11 Non-text Contrast (AA):** Grafik çizgileri, aktif durum göstergeleri ve kontrol sınırları için en az **3.0:1**.
* **Ninnly Çözümü:** Yüzen tipografi asla çok parçalı/gürültülü bir görselin tam sınır çizgisi üzerine bindirilmemeli; ekran zemini düz veya çok yumuşak gradyanlı tutulmalı ve tüm metin/zemin çiftleri §7.2'deki doğrulanmış kontrast tablosuna uymalıdır.

#### Risk 3: Ayrımın Yalnızca Renkle Yapılması (WCAG 1.4.1 Use of Color)
* **Sorun:** Kutu ve çerçeve olmadığında "Sol Meme vs Sağ Meme", "Islak Bez vs Kirli Bez" veya "Oda Sıcaklığı vs Dondurucu Sütü" ayrımını yalnızca yeşil ve mercan renkleriyle yapmak, hem renk körü ebeveynlerde hem de karanlık odada hataya yol açar (`https://www.w3.org/TR/WCAG22/#use-of-color`).
* **Ninnly Çözümü (Çoklu İpucu Kuralı):** Her durum ayrımında **Renk + İkon/Şekil + Açık Metin Etiketi + Konum** dörtlüsünden en az ikisi birlikte kullanılır:
  * *Emzirme:* Sol taraf daima solda + **`L` / `Sol`** etiketi + sola bakan yay; Sağ taraf daima sağda + **`R` / `Sağ`** etiketi.
  * *Grafikler:* İki veri serisi karşılaştırılırken biri **düz kalın çizgi (`LineMark`) + daire sembolü**, diğeri **kesikli çizgi (`.strokeStyle(StrokeStyle(dash: [5, 3]))`) + kare/elmas sembolü** ile çizilir.

---

## 7. Rakiplerin Görsel Dili, Ninnly Paletinin Farklılaşma Gücü ve Renk Körlüğü Denetimi

### 7.1. Rakiplerin Görsel Dili, Renkleri, Puanları ve Fiyat Modelleri (Kasım 2026 İtibarıyla)

| Uygulama ve Resmi App Store Kaynağı | App Store Puanı (16 Kasım 2026) | İş Modeli ve Fiyat (16 Kasım 2026) | Görsel Dil ve Renk Paleti | Ninnly'ye Göre Zayıf Noktası |
| :--- | :--- | :--- | :--- | :--- |
| **Huckleberry: Baby & Child**<br>([App Store](https://apps.apple.com/us/app/huckleberry-baby-child/id1244793268), [`huckleberrycare.com`](https://huckleberrycare.com/)) | **4.9 / 5** (~120.000+ ABD oyu, 16 Kasım 2026) | **Freemium + Abonelik:** Temel kayıt ücretsiz; *Plus* (~9,99 $/ay veya ~58,99 $/yıl) ve *Premium* (~14,99 $/ay veya ~119,99 $/yıl) (`https://apps.apple.com/us/app/huckleberry-baby-child/id1244793268`, 16 Kasım 2026). | **Lacivert/Mavi + Turuncu/Sarı + Pastel Kartlar:** Koyu mavi zemin üzerinde çok sayıda yuvarlatılmış kutu, yoğun ızgara ve pastel kategori renkleri. | Gece modunda dahi **mavi/lacivert zemin** kullanır; yoğun kart kalabalığı ve abonelik duvarı (*paywall*) ebeveyni yorar. |
| **Nara Baby & Pregnancy Tracker**<br>([App Store](https://apps.apple.com/us/app/nara-baby-pregnancy-tracker/id1469363065), [`narababy.com`](https://narababy.com/)) | **4.8 / 5** (~1.200+ ABD oyu, 16 Kasım 2026) | **Freemium + Uygulama İçi Satın Alma (IAP):** App Store sayfasında (16 Kasım 2026) hâlâ "Free · Offers In-App Purchases" olarak listelenmektedir. *(Strateji raporundaki "Eylül 2026'da tamamen ücretliye geçti" iddiası resmi mağaza sayfasında bu haliyle **DOĞRULANAMADI**; ücretsiz indirme + IAP modeli görünmektedir).* | **Bej / Taupe / Krem + Kart Izgarası:** Toprak tonları, sıcak gri/bej kutular (*boxy cards*) ve ince çizgili minimalist ikonlar. | Görsel olarak sakin olsa da tüm ana ekran **kutucuklardan (cards)** oluşur; güçlü bir marka maskotu/ikonografisi yoktur ve bej tonları düşük kontrastlı kalabilir. |
| **Baby Tracker - Newborn Log (Nighp)**<br>([App Store](https://apps.apple.com/us/app/baby-tracker-newborn-log/id779656557)) | **4.9 / 5** (~90.000+ ABD oyu, 16 Kasım 2026) | **Freemium + Reklam / IAP:** Ücretsiz sürümde reklam; reklamsız/Pro açılımı için tek seferlik veya abonelik IAP (~4,99 $ – 23,99 $, 16 Kasım 2026). | **Parlak Birincil Renkler (Mavi, Pembe, Yeşil, Sarı) + Tablo:** Eski nesil iOS `UITableView` listeleri ve parlak renkli ikonlar. | Görsel dili 2015 döneminden kalma bir veri tablosu gibidir; gece kullanımında yüksek beyaz/mavi parlaklık yayar. |
| **Cubtale: Pregnancy & Baby**<br>([App Store](https://apps.apple.com/us/app/cubtale-pregnancy-baby/id1534019183), [`cubtale.com`](https://www.cubtale.com/)) | **4.9 / 5** (~10.000+ ABD oyu, 16 Kasım 2026) | **Freemium + Abonelik / Donanım:** Temel takip ücretsiz; gelişmiş analitik ve stok için aylık/yıllık abonelik IAP (16 Kasım 2026). | **Beyaz / Açık Mavi-Mor + Renkli Halkalar:** Her aktivite için yuvarlak ilerleme kartları ve modern kurumsal sağlık uygulaması estetiği. | Klinik/hastane yazılımı hissi verir; sıcak, editoryal bir gece/uyku kimliği yoktur. |

### 7.2. Ninnly Paletinin Farklılaşma Gücü ve WCAG Kontrast Doğrulaması
Bebek takip kategorisindeki uygulamaların neredeyse tamamı ya **"bebek mavisi / pembe / mor"** (Huckleberry, Cubtale, Baby Tracker) ya da **"soluk bej / gri kartlar"** (Nara Baby) kullanmaktadır. Ninnly'nin `docs/marka/aday/hilal-bebek.jpg` logosundan doğan **Koyu Çam Yeşili + Sıcak Mercan + Fildişi Krem** paleti, kategoride anında ayırt edilen, doğallık ve gece huzuru çağrıştıran benzersiz bir görsel imza yaratır.

`hilal-bebek.jpg` üzerinden örneklenen (eyedropper) ve gündüz/gece fazları için optimize edilen renk kodları ile **WCAG 2.2 bağıl parlaklık ($L$) ve kontrast oranı** hesaplamaları (`https://www.w3.org/TR/WCAG22/#dfn-contrast-ratio`):

| Rol ve Faz | Renk Adı ve Hex Kodu | RGB (0–255) | Bağıl Parlaklık ($L$) | Karşılaştırıldığı Zemin ve Kontrast Oranı | WCAG 2.2 Uyum Durumu |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Gece Zemin (Ana)** | **Obsidyen Çam** `#0F1412` | `15, 20, 18` | `0.0065` | — *(Ana gece arka planı; mavi kanal B=18 ile sıfıra yakın)* | **Gece Fazı Temeli** |
| **Logo / Vurgu Zemin** | **Derin Orman Yeşili** `#2D473B` | `45, 71, 59` | `0.0538` | `#F6F0E4` (Krem) ile **8.91 : 1** | **AAA** (Tüm metinler) |
| **Gündüz Zemin (Ana)** | **Sıcak Fildişi Krem** `#F6F0E4` | `246, 240, 228` | `0.8751` | `#0F1412` ile **16.37 : 1**<br>`#1C2E26` (Gündüz Koyu Yeşil Metin) ile **12.40 : 1** | **AAA** (Kusursuz okunabilirlik) |
| **Gece Ana Metin & Hilal Işığı** | **Sıcak Şeftali-Mercan** `#F59B6C` | `245, 155, 108` | `0.4393` | `#0F1412` (Gece Zemin) üzerinde **8.66 : 1**<br>`#2D473B` (Orman Yeşili) üzerinde **4.71 : 1** | **AAA** (`#0F1412` üzerinde)<br>**AA** (`#2D473B` üzerinde) |
| **Ana Vurgu (Mercan)** | **Hilal Mercanı** `#E47953` | `228, 121, 83` | `0.3079` | `#0F1412` (Gece Zemin) üzerinde **6.33 : 1**<br>`#2D473B` üzerinde **3.45 : 1** | **AA** (`#0F1412` üzerinde metin)<br>**AA Büyük Metin / İkon** (`#2D473B` üzerinde) |
| **Gündüz Mercan Metin/Vurgu** | **Koyu Terracotta** `#B84322` | `184, 67, 34` | `0.1384` | `#F6F0E4` (Gündüz Krem Zemin) üzerinde **4.91 : 1** | **AA** (Gündüz krem zeminde mercan metin için `#E47953` [2.58:1] yerine `#B84322` kullanılmalıdır!) |
| **Gece İkincil Metin** | **Sıcak Kehribar-Toprak** `#C98462` | `201, 132, 98` | `0.2785` | `#0F1412` (Gece Zemin) üzerinde **5.81 : 1** | **AA** (Gece alt başlık ve saat etiketleri; beyaz/mavi içermez) |

> **Kritik Kontrast Bulgusu:** Açık mercan (`#F59B6C` veya `#E47953`), koyu gece zemininde (`#0F1412`) **8.66:1 ve 6.33:1** ile mükemmel okunurken, gündüz açık krem zemin (`#F6F0E4`) üzerinde yalnızca **1.89:1 ve 2.58:1** kontrast verir (WCAG AA 4.5:1 sınırının altında kalır). Bu nedenle **Gündüz Fazında** krem zemin üzerindeki ana metinler **Koyu Çam Yeşili (`#172820`, kontrast 13.5:1)**, vurgu metinleri ise koyulaştırılmış **Terracotta Mercan (`#B84322`, kontrast 4.91:1)** olmalıdır; açık mercan (`#E47953`) gündüz fazında yalnızca dolgu (arka plan kapsülü, grafik çubuğu, ikon dolgusu) olarak kullanılmalıdır.

### 7.3. Renk Körlüğü (CVD) Kontrolü: Yeşil + Mercan Çiftinin Güvenliği
Erkeklerin yaklaşık %8'inde, kadınların %0,5'inde görülen **kırmızı-yeşil renk körlüğü (Protanopia ve Deuteranopia)** için "Yeşil + Mercan (Kırmızı-Turuncu)" paleti en kritik sınavdır.
* **Neden Standart Kırmızı-Yeşil Tehlikeliyken Ninnly'nin Paleti Güvenlidir?**
  Standart kırmızı (`#FF0000`, $L \approx 0.21$) ile standart yeşil (`#00AA00`, $L \approx 0.25$) eşit parlaklıktadır (*isoluminant*); bu yüzden Deuteranopia/Protanopia gözünde ikisi de aynı çamurlu sarı-kahverengi tona dönüşür ve birbirinden ayrılamaz.
* **Ninnly'de Parlaklık ($\Delta L$) Farkı:** Ninnly'nin koyu orman yeşili (`#2D473B`, $L = 0.0538$) ve obsidyen çam yeşili (`#0F1412`, $L = 0.0065$) **çok koyu**, şeftali-mercanı (`#F59B6C`, $L = 0.4393$) ve kremi (`#F6F0E4`, $L = 0.8751$) ise **çok açıktır**.
  * **Protanopia (Kırmızı koni eksikliği) & Deuteranopia (Yeşil koni eksikliği):** İki renk arasındaki kontrast oranı renk bilgisi tamamen silinse bile (Akromatopsi / Tam Gri Tonlama altında dahi) **8.66:1 (Obsidyen üzerinde Mercan)** ve **4.71:1 (Orman Yeşili üzerinde Mercan)** olarak kalır.
  * **Tritanopia (Mavi-Sarı körlüğü):** Palet mavi kanala dayanmadığı için Tritanopia kullanıcıları da yeşil-mercan-krem hiyerarşisini kayıpsız görür.
* **Uyulması Gereken Tek Kural:** Grafiklerde "Sol Göğüs" ve "Sağ Göğüs" gibi iki farklı veri dizisini yan yana gösterirken **asla aynı parlaklıktaki bir açık yeşil ($L \approx 0.40$) ile açık mercan ($L \approx 0.43$) tek başına kullanılmamalıdır**. Bunun yerine:
  1. Biri **Açık Şeftali-Mercan (`#F59B6C`)**, diğeri **Krem (`#F6F0E4`)** veya **Koyu Çam (`#2D473B`)** seçilmeli (yüksek parlaklık farkı),
  2. Çizgi grafiklerde düz çizgi + kesikli çizgi ve doğrudan `Sol` / `Sağ` metin etiketleri kullanılmalıdır.

---

## 8. Marka Sistemi: Yazı Logosu (Wordmark) ve Tek Parça Raster Logonun Canlandırılması

### 8.1. `hilal-bebek.jpg` ile Uyumlu Yazı Logosu (Wordmark) İçin Ücretsiz/Açık Lisanslı Yazı Tipi Önerileri
"ninnly" veya "Ninnly" kelimesi; iki adet `n`, bir `i` (noktalı), bir `l` ve bir kuyruklu `y` harfinden oluşur. Hilal-bebek logosunun organik, yumuşak kavisli ve sıcak kağıt-kesiği estetiğiyle yarışmayacak, ticari ücretli uygulamada **ücretsiz ve süresiz kullanılabilen (SIL Open Font License 1.1 - OFL)** ve **Türkçe karakterleri (`ğ, ı, İ, ö, ş, ü, ç`) eksiksiz destekleyen** en iyi 4 yazı tipi:

| Sıra | Yazı Tipi Adı ve Birincil Kaynak | Lisans | Türkçe Desteği | Neden `hilal-bebek.jpg` İle Uyumlu? | Wordmark İçin Önerilen Ayar |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1 (Birincil Öneri)** | **SF Pro Rounded**<br>(`https://developer.apple.com/fonts/`) | Sistem içi API kullanımı ücretsiz (Apple Platform Lisansı) | **Tam (%100)** | Uygulama içi tipografiyle birebir aynı DNA'yı taşır; `n` kemerleri ve `y` kuyruğu hilalin iç kavisiyle kusursuz uyum sağlar. | `Bold` veya `Semibold`, küçük harf **`ninnly`** veya **`Ninnly`**, harf aralığı (tracking) `-0.02em`. |
| **2 (Bağımsız SVG Wordmark Önerisi)** | **Quicksand**<br>(`https://fonts.google.com/specimen/Quicksand`) | **SIL OFL 1.1** (Ticari/Uygulama içi ücretsiz: `https://openfontlicense.org/`) | **Tam (`Latin Extended`)** | Geometrik daire tabanlı yapısıyla logodaki yuvarlak bebek başı ve dairesel hilal yaylarıyla aynı geometrik oranı paylaşır. | `Bold (700)`, `i` harfinin noktası mercan (`#F59B6C`), diğer harfler krem (`#F6F0E4`). |
| **3 (Organik/Sıcak Alternatif)** | **Nunito**<br>(`https://fonts.google.com/specimen/Nunito`) | **SIL OFL 1.1** (Ticari ücretsiz) | **Tam (`Latin Extended`)** | Hümanist yuvarlak uçlara sahiptir; `y` harfinin alt kıvrımı beşik gibi yumuşak döner. | `ExtraBold (800)`, hafif sıkı harf aralığı. |
| **4 (Modern Editoryal Alternatif)** | **Plus Jakarta Sans**<br>(`https://fonts.google.com/specimen/Plus+Jakarta+Sans`) | **SIL OFL 1.1** (Ticari ücretsiz) | **Tam (`Latin Extended`)** | Fazla "çocuksu/balon" görünmekten kaçınan, çok şık ve çağdaş kesimli sıcak geometrik harf formları sunar. | `Bold (700)`. |

*(Uyarı: Google Fonts'taki **Fredoka** yazı tipinin bazı eski/standart ağırlıklarında Türkçe `İ/ı` ve `ğ` glif uyumsuzlukları görülebildiğinden wordmark/başlık için önerilmez).*

### 8.2. Uygulama İçi Açılış Animasyonu: Tek Parça Raster Logonun (`hilal-bebek.jpg`) Bozulmadan Canlandırılması
`docs/PLAN.md` §3'teki kritik kuralı hatırlayalım:
> *"Claude'un 'sadeleştirilmiş' vektör denemesi (`docs/marka/hilal`) reddedildi: 'Logoyu mahvetmişsin'. Kural: Himmet'in getirdiği görsel olduğu gibi kullanılır, 'düzeltme' yapılmaz. Uygulama içi hareketli logo için aynı çizimin şeffaf zeminli hali gerekiyor; o gelene kadar ana ekranda logo yok."*

Dolayısıyla logoyu basit bir tek çizgi SVG'ye dönüştürüp çizdirmek **yasaktır**; çünkü bu işlem Himmet'in görselindeki 3B kağıt-kesiği derinliğini ve sıcak ışık geçişlerini yok etmektedir. Bunun yerine, **orijinal raster görselin piksellerine hiç dokunmadan** SwiftUI'da uygulanabilecek **3 somut canlandırma tekniği** şunlardır:

#### Teknik A (Şeffaf Zeminli Tek PNG veya 3 Katmanlı PNG ile "Beşik Salınımı + Nefes Alma" — EN DOĞAL YÖNTEM)
`hilal-bebek.jpg` içindeki yeşil dalgalı arka plan temizlenerek yalnızca **Hilal + Kundak + Bebek** kısmı şeffaf zeminli `ninnly-logo-transparent.png` olarak dışa aktarılır (veya §2.3'teki gibi `Hilal`, `İç Kundak`, `Bebek` olarak 3 şeffaf PNG katmanına ayrılır):
1. **Görünür Olma (Reveal - 0.0 sn → 0.55 sn):** Orijinal şeffaf PNG'nin üzerine hilalin alt ucundan üst ucuna doğru açılan **dairesel bir `Shape.trim(from: 0, to: progress)` maskesi (`.mask`)** uygulanır. Böylece çizimin kendisi vektöre dönüştürülmeden, **orijinal raster hilal sanki fırçayla çiziliyormuş gibi** alttan yukarıya doğru pürüzsüzce belirir!
2. **Beşik Salınımı ve Nefes Alma (`PhaseAnimator` - 0.55 sn sonrası):** Logo belirdikten sonra:
   * Hilal çok hafif bir beşik hareketiyle (`rotationEffect(.degrees(-2.5))` ↔ `.degrees(2.5)`) `.easeInOut(duration: 3.2)` ile sallanır.
   * Bebek ve kundak katmanı (`scaleEffect(1.0)` ↔ `1.025`) uyuyan bir bebeğin göğüs kafesi gibi yavaşça **nefes alır**.

#### Teknik B (Şeffaf Sürüm Hazır Olana Kadar Tam Kare `hilal-bebek.jpg` İle Maskeli Açılış)
Şeffaf zeminli kesim yapılana kadar mevcut `hilal-bebek.jpg` doğrudan kullanılacaksa:
* Görsel dairesel bir yumuşak kenar maskesi (`.clipShape(Circle())` + kenarlarda `#0F1412` radyal vinyet geçişi) içine alınır, böylece kare köşeler kaybolur ve koyu yeşil ekran zeminiyle bütünleşir.
* Açılışta `scaleEffect(0.92 → 1.0)` ve hafif rotasyon (`-4° → 0°`) ile `.smooth(duration: 0.7)` yay animasyonuyla sahneye gelir.

#### Teknik C (Metal Shader / Işık Parlaması Geçişi — `.colorEffect` / `.overlay`)
* Hilalin sırtındaki mercan kavis üzerinden açılışta tek bir kez geçen yumuşak, sıcak bir `LinearGradient` ışık yansıması (*shimmer mask*) kaydırılır; gece fazında bu parlama devre dışı bırakılır.

---

## 9. App Store Ürün Sayfası Görselleri: 2026 Gereksinimleri (iPhone & Apple Watch)

Apple'ın resmi **App Store Connect Ekran Görüntüsü ve Uygulama Önizleme Spesifikasyonları** (`https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications`, `https://developer.apple.com/help/app-store-connect/reference/app-preview-specifications`) uyarınca Kasım 2026'da geçerli kurallar şunlardır:

### 9.1. Zorunlu Ekran Görüntüsü Boyutları (Yalnızca iPhone Dikey + Apple Watch)
App Store Connect'in **basitleştirilmiş medya yönetimi (Media Manager)** sayesinde her iPhone boyutu için ayrı görsel yüklemek gerekmez; **en büyük iPhone ekran sınıfı (6.9 inç)** yüklendiğinde sistem diğer tüm iPhone boyutlarına otomatik ölçekler (`https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications`):

| Cihaz Sınıfı | Zorunluluk Durumu | Dikey (Portrait) Piksel Boyutu | Dosya Biçimi ve Renk Uzayı | Adet Sınırı |
| :--- | :--- | :--- | :--- | :--- |
| **iPhone 6.9" Ekran**<br>*(iPhone 16 Pro Max, iPhone 17 Pro Max)* | **ZORUNLU** *(Diğer tüm iPhone boyutlarına otomatik küçültülür)* | **`1320 × 2868 px`** *(Birincil)*<br>veya `1290 × 2796 px`<br>veya `1260 × 2736 px` | `.png`, `.jpg` veya `.jpeg` · **72 dpi, RGB (sRGB veya Display P3), Düzleştirilmiş (Alfa kanalı / şeffaflık YASAK)** | **1 – 10 adet** (Her dil: `tr-TR` ve `en-US` için ayrı set) |
| **iPhone 6.5" Ekran**<br>*(iPhone 14 Plus, 13/12 Pro Max)* | *Opsiyonel* *(6.9" yüklenirse gerekmez; yedek boyut)* | `1284 × 2778 px`<br>veya `1242 × 2688 px` | Aynı | 1 – 10 adet |
| **Apple Watch**<br>*(Ultra 2/3, Series 10/11/12)* | **ZORUNLU** *(Projede `NinnlyWatch` hedefi olduğu için şarttır!)* | **`410 × 502 px`** *(Ultra)*<br>veya **`416 × 496 px`** *(Series 10/11 46mm)*<br>veya `396 × 484 px` | `.png` / `.jpg`, **Alfa kanalı YASAK** | **1 – 10 adet** |

### 9.2. Uygulama Önizleme Videosu (App Preview) Gereksinimleri
Hareketli düğmeleri, akan sayaçları ve Swift Charts animasyonlarını göstermek için ürün sayfasına eklenecek **App Preview** videosunun resmi sınırları (`https://developer.apple.com/help/app-store-connect/reference/app-preview-specifications`):
* **Çözünürlük (iPhone 6.9" / 6.5" Dikey):** **`886 × 1920 px`** (Dikey / Portrait). *(Dikkat: Ekran görüntüsü gibi `1320×2868` değil, tam `886×1920` olmalıdır; aksi halde App Store Connect yüklemeyi reddeder).*
* **Süre:** En az **15 saniye**, en fazla **30 saniye**.
* **Kare Hızı ve Kodek:** En fazla **30 fps**, **H.264** veya **Apple ProRes 422 (HQ)**, `.mov`, `.mp4` veya `.m4v` konteyneri, maksimum dosya boyutu **500 MB**.
* **Ses Kanalı:** Video sessiz olsa bile dosyada **2 kanallı (Stereo) 44.1 kHz veya 48 kHz AAC (256 kbps) veya PCM ses izi (audio track)** bulunması zorunludur (sessiz bir stereo ses izi gömülmezse App Store Connect hata verir).
* **İçerik Kuralı (Guideline 2.3.4):** Videonun tamamı doğrudan uygulama içi ekran kaydından (*screen capture*) oluşmalıdır; telefonu tutan el çekimi, dış reklam kurgusu veya satın alma fiyatı metni içeremez (`https://developer.apple.com/app-store/review/guidelines/#accurate-metadata`).

---

## 10. Ninnly İçin Çıkarımlar (Önem Sırasına Göre Somut Karar Önerileri)

1. **İçerik Katmanında Sıfır Kutu/Cam, Yalnızca Alt Eylem Kapsüllerinde Liquid Glass Kullan (`iOS 26+`):**
   * **Ne Yapılmalı:** Ana ekrandaki sayaçlar, son kayıtlar, Uyku Penceresi ve grafikler doğrudan zemin (`#0F1412` gece / `#F6F0E4` gündüz) üzerinde kutusuz tipografi olarak yüzmeli; `.glassEffect()` **yalnızca** ekranın alt yarısındaki tek-başparmak hızlı eylem kapsüllerinde, aktif sayaç alt barında (`tabViewBottomAccessory`) ve sekme çubuğunda kullanılmalıdır.
   * **Ne Yapılmamalı:** Beslenme veya uyku satırlarının arkasına yuvarlatılmış dikdörtgen kartlar, gölgeli paneller veya üst üste binen cam katmanlar (*glass-on-glass*) kesinlikle konulmamalıdır.
   * **Neden:** Hem Himmet'in "arayüzde kutu/panel yok" kuralını korur hem de Apple HIG'in *"Liquid Glass'ı asla içerik katmanında kullanmayın"* ilkesiyle %100 uyum sağlar (`https://developer.apple.com/design/human-interface-guidelines/materials`).

2. **Gece Fazında (20:00–06:30) Saf Beyazı (`#FFFFFF`) ve Mavi Kanalı Sıfırla, Ancak `UIScreen.brightness`'ı Zorla Kısma:**
   * **Ne Yapılmalı:** Gece fazında arka plan `#0F1412` (Obsidyen Çam, $B=18$), birincil metin `#F59B6C` (Sıcak Şeftali-Mercan, kontrast **8.66:1 AAA**), ikincil metin `#C98462` (Kehribar-Toprak, kontrast **5.81:1 AA**) ve ana vurgu `#E47953` (Hilal Mercanı, kontrast **6.33:1 AA**) olarak sabitlenmelidir. Gündüz fazında ise krem zemin (`#F6F0E4`) üzerinde açık mercan metin okunamayacağı için (`2.58:1`), gündüz mercan metinlerde koyu **Terracotta (`#B84322`, kontrast 4.91:1 AA)** ve ana metinlerde **Koyu Çam (`#172820`, kontrast 13.5:1 AAA)** kullanılmalıdır.
   * **Ne Yapılmamalı:** Uygulama açıldığında `UIScreen.main.brightness` otomatik olarak kısılmamalıdır; bunun yerine Ayarlar'a isteğe bağlı bir "Gece Ekstra Karartma" anahtarı konulmalıdır.
   * **Neden:** 460–480 nm mavi/beyaz ışık ipRGC hücrelerini uyararak melatonini baskılar (`https://pubmed.ncbi.nlm.nih.gov/11517269/`); ancak donanım parlaklığını habersiz kısmak aydınlık odada ekranı okunmaz kılar (`https://developer.apple.com/documentation/uikit/uiscreen/brightness`).

3. **`hilal-bebek.jpg` Görselini Asla Vektöre Çevirip Sadeleştirme; Alfa Maskesiyle Katmanla ve Maskeli Trim ile Canlandır:**
   * **Ne Yapılmalı:** Uygulama ikonu için `docs/marka/aday/hilal-bebek.jpg` görselinin pikselleri değiştirilmeden `1024×1024` olarak kullanılmalı; iOS 26 Icon Composer'ın Şeffaf (*Clear*) ve Renklendirilmiş (*Tinted*) modlarında kare blok görünmemesi için aynı görsel yeniden çizilmeden piksel-birebir alfa maskesiyle **Zemin Dalgaları + Krem Kundak/Bebek + İç Kundak + Dış Hilal** olarak 4 şeffaf PNG katmanına ayrılmalıdır. Uygulama içi açılış animasyonunda ise şeffaf PNG üzerine dairesel `.mask(ArcShape().trim(from: 0, to: progress))` uygulanarak orijinal çizim alttan yukarıya doğru belirmeli, ardından `PhaseAnimator` ile $\pm 2.5^\circ$ beşik salınımı ve `%2.5` nefes alma hareketi yapmalıdır.
   * **Ne Yapılmamalı:** Görseli düz renkli SVG patikalarına indirgeyen "vektörleştirme/sadeleştirme" denemeleri ve hilalin yanına yıldız eklenmesi kesinlikle yapılmamalıdır.
   * **Neden:** Görselin gücü kendi içindeki 3B kağıt-kesiği ışık/gölge geçişlerindedir; maskeli raster animasyonu bu dokuyu %100 korurken 120 Hz yerel SwiftUI animasyonu sağlar.

4. **Kutusuz Düğmelerde `.contentShape(Rectangle())`, Minimum `48 pt` Hedef ve Renk Dışı İpuçlarını Zorunlu Kıl:**
   * **Ne Yapılmalı:** Görünür çerçevesi olmayan her yüzen metin düğmesine `.frame(minWidth: 44, minHeight: 48)` ve `.contentShape(Rectangle())` uygulanmalı; "Sol/Sağ Meme", "Islak/Kirli Bez" ve grafik eğrileri yalnızca yeşil-mercan rengiyle değil, mutlaka **açık metin etiketi (`Sol`/`Sağ`), ikon ve çizgi stili (düz/kesikli)** ile ayrıştırılmalıdır.
   * **Ne Yapılmamalı:** Sadece `Text("Sol")` yazılıp çerçevesiz bırakılmamalı ve aynı parlaklıktaki açık yeşil ile açık mercan yan yana iki grafik çizgisi olarak kullanılmamalıdır.
   * **Neden:** Gece 03:00'te tek başparmakla kullanımda küçük dokunma hedefleri ıskalanır (HIG 44×44 pt ve WCAG 2.5.5) ve yalnızca renkle ayrım yapmak WCAG 1.4.1 ile kırmızı-yeşil renk körlüğü kurallarını ihlal eder (`https://www.w3.org/TR/WCAG22/`).

5. **Tipografide `SF Pro Rounded` + `.monospacedDigit()` + Türkçe `Locale("tr")` Kurallarını Sabitle:**
   * **Ne Yapılmalı:** Tüm arayüzde ve wordmark'ta **SF Pro Rounded** (alternatif SVG wordmark için **Quicksand Bold** - OFL) kullanılmalı; sayaçlarda `.monospacedDigit()` zorunlu olmalı; büyük `İ` noktasının kesilmemesi için metinlere sabit `.frame(height:)` verilmemeli ve büyük harf dönüşümlerinde yalnızca `.textCase(.uppercase)` veya `Locale(identifier: "tr")` kullanılmalıdır.
   * **Ne Yapılmamalı:** Standart `.uppercased()` (`"emzirme"` → `"EMZIRME"`) ve harici kırpılma yaratan font dosyaları kullanılmamalıdır.
   * **Neden:** Türkçe `İ/ı` dönüşüm hatası ve `İ` noktasının üstten kesilmesi yerel kalite algısını doğrudan bozar.

6. **GitHub Actions Simülatör Boru Hattını 6.9" (`1320×2868`) ve Watch Ultra (`410×502`) Çözünürlüğüne Sabitle:**
   * **Ne Yapılmalı:** A0/A8 aşamalarındaki GitHub Actions otomatik ekran görüntüsü iş akışı doğrudan **iPhone 16/17 Pro Max (`1320 × 2868 px`, alfa kanalsız PNG)** ve **Apple Watch Ultra (`410 × 502 px`)** üretecek şekilde yapılandırılmalı; App Preview videosu ise **`886 × 1920 px` (30 fps, sessiz bile olsa stereo AAC ses kanallı)** olarak dışa aktarılmalıdır.
   * **Ne Yapılmamalı:** Şeffaf (alfa kanallı) PNG ekran görüntüsü veya ses izi olmayan (no-audio track) önizleme videosu yüklenmemelidir.
   * **Neden:** App Store Connect alfa kanallı görselleri ve ses izi bulunmayan önizleme videolarını otomatik olarak reddeder (`https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications`).
