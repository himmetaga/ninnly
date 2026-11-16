# Ninnly — Ebeveyn İhtiyaçları ve Kullanım Deneyimi (UX) Araştırma Raporu (M2)

**Hazırlanma Tarihi:** 16 Kasım 2026  
**Kapsam:** Yeni ebeveynlerin bebek verisi tutma davranışları, gece ergonomisi ve sirkadiyen biyoloji, eş/bakıcı senkronizasyonu, rakip UX analizi, duygusal tasarım ve doğum sonrası depresyon sınırları, Apple erişilebilirlik standartları, Türkiye pazarına özgü demografik/kültürel dinamikler ve ilk 60 saniye (onboarding) mimarisi.  
**Yöntem Notu:** Bu rapordaki tüm iddialar hakemli akademik makaleler (PubMed, ACM CHI/UbiComp/CSCW), resmi sağlık kurumları (T.C. Sağlık Bakanlığı, HÜNEE TNSA, TÜİK, AAP, ACOG, CDC) ve Apple Developer / Human Interface Guidelines (HIG) birincil kaynaklarına dayandırılmıştır. Birincil kaynaktan doğrudan teyit edilemeyen veriler **"DOĞRULANAMADI"** olarak işaretlenmiştir. `docs/PLAN.md` ve `docs/arastirma/A1_kaynak_dogrulama.md` içinde doğrulanmış olan aşı takvimi, yenidoğan taramaları, DSÖ (WHO) LMS lisansı, anne sütü saklama süreleri (4'ler kuralı), uyanıklık pencereleri, CSV şemaları ve App Store 1.4.1 / 5.1.3 / 2.3.7 maddeleri bu raporda yeniden araştırılmamış, yalnızca ilgili UX kararlarında atıf yapılmıştır.

---

## 1. Yeni Ebeveynler Bebek Verisini Neden, Hangi Sırayla Tutuyor ve Ne Zaman Bırakıyor?

### 1.1. Ebeveynlerin Veri Tutma Nedenleri ve Kronolojik Sırası
İnsan-Bilgisayar Etkileşimi (HCI), pediatri ve beslenme literatüründe yapılan araştırmalar, ebeveynlerin bebek verisi kaydetme motivasyonlarının bebeğin gelişim aylarına göre belirgin bir evrim geçirdiğini göstermektedir:

1. **1. Evre — Hastane Taburculuğu ve İlk 0–2 Hafta (Tıbbi Hesap Verebilirlik, Sarılık ve Dehidratasyon Kontrolü):**
   * **Temel Neden:** Doğumdan sonraki ilk günlerde ebeveynler, çocuk hekimi veya aile hekiminin ilk kontrol muayenesinde soracağı *"Günde kaç kez emdi, kaç ıslak ve kirli bez çıkardı?"* sorusuna yanıt verebilmek için veri tutar. Sosyolog Deborah Lupton bu durumu ebeveynin kendi isteğinden ziyade sağlık otoritelerinin beklentisiyle başlayan **"itilmiş takip" (*pushed self-tracking*)** olarak tanımlar (`https://pubmed.ncbi.nlm.nih.gov/26896295/`).
   * **Tutulan Veri Sırası:** **1) Emzirme / Biberon sıklığı ve süresi**, **2) Islak ve kirli bez sayısı (ve yenidoğan mekonyumdan sarı dışkıya geçiş rengi)**, **3) Doğum kilosuna geri dönüş (tartı)**. Amerikan Pediatri Akademisi (AAP), yenidoğanın ilk 3–5. gün muayenesinde yeterli anne sütü alımını doğrulamak için günlük işeme ve dışkılama sayılarının izlenmesini temel klinik kriter kabul eder (`https://www.healthychildren.org/English/ages-stages/baby/breastfeeding/Pages/How-Often-and-How-Much-Should-Your-Baby-Eat.aspx`).
2. **2. Evre — 2–8. Haftalar (Emzirme Dengesi, Süt Stoku ve Eşler Arası Devir):**
   * **Temel Neden:** Anne sütü üretiminin oturması sürecinde anneler *"En son hangi göğsü vermiştim?"* sorusunu uykusuzluk nedeniyle hatırlamakta zorlanır. Dinour (2022) tarafından yapılan kesitsel çalışmada (`n = 299` postpartum anne), bebek beslenme uygulaması kullanan annelerin en çok **emzirme süresi/tarafı (%90+)**, **biberon miktarı** ve **sağım (pumping) hacmini** kaydettiği saptanmıştır (`https://pubmed.ncbi.nlm.nih.gov/35643748/`, DOI: `https://doi.org/10.1016/j.jneb.2022.03.012`).
   * **Eşler Arası Devir:** Gece nöbetleşe bakımda (ör. annenin sağılmış süt bırakıp 3–4 saat kesintisiz uyuduğu, eşin biberon verdiği vardiyalarda) sözlü devir teslim uyuyan ebeveyni uyandıracağı için uygulama bir **"asenkron iletişim panosu"** işlevi görür (`https://dl.acm.org/doi/10.1145/1518701.1518815`).
3. **3. Evre — 2–6. Aylar (Uyku Düzeni ve Uyanıklık Pencereleri):**
   * **Temel Neden:** İlk 8 haftadan sonra bez sayma ihtiyacı hızla azalır (bebek kilo alımını kanıtlamıştır); buna karşılık bebeğin sirkadiyen ritminin olgunlaşmaya başlaması ve 4. ay uyku gerilemesiyle birlikte **uyku takibi ve "Uyku Penceresi" (*wake windows*)** birincil önceliğe yerleşir (`docs/arastirma/A1_kaynak_dogrulama.md` §5; `https://health.clevelandclinic.org/wake-windows-by-age`).
4. **4. Evre — 6–12+ Aylar (Ek Gıda / Alerjen Takibi, Aşı ve Hastalık/Ateş Kaydı):**
   * **Temel Neden:** 6. ayda tamamlayıcı beslenmeye (BLW / püre) geçişle birlikte günlük rutin kayıtlar yerini **ilk denenen besinler ve alerjen reaksiyonları**, **rutin büyüme (boy/kilo/baş çevresi)**, **aşı takvimi** (`docs/arastirma/A1_kaynak_dogrulama.md` §1) ve yalnızca bebek hastalandığında açılan **epizodik ateş/ilaç (parasetamol/ibuprofen) takibine** bırakır (`https://pubmed.ncbi.nlm.nih.gov/36288484/`).

### 1.2. Ebeveynler Takibi Ne Zaman ve Neden Bırakıyor? ("Happy Abandonment" vs. "Tükenmişlik")
Kişisel bilişim (Personal Informatics) alanında Epstein ve ark. (2015) tarafından ACM UbiComp'ta yayınlanan **"Yaşanan Bilişim Modeli" (*A Lived Informatics Model of Personal Informatics*)** çalışması, kullanıcıların veri takibini bırakma (*lapsing* ve *abandonment*) davranışlarını iki ana kategoride açıklar (`https://doi.org/10.1145/2750858.2804250`):

1. **Veri Giriş Yorgunluğu ve Kaygı Kaynaklı Bırakma (Erken Terk: 1.–3. Aylar):**
   * Uygulamanın her kayıtta çok fazla form alanı sorması, zamanlayıcıyı durdurmayı unutma ("14 saattir emziriyor" hatası) ve grafiklerin bebeği "ortalamanın altında" göstererek ebeveynde yetersizlik hissi yaratması erken terkin birincil nedenidir (`https://doi.org/10.1145/2750858.2804250`).
   * Kientz ve ark. (2009) tarafından ACM CHI'da yayınlanan *Baby Steps* çalışması, yeni ebeveynlerin kronik uykusuzluk ve zaman baskısı altında olduğunu, bu nedenle yüksek sürtünmeli (*high-friction*) veri giriş arayüzlerinin birkaç hafta içinde terk edildiğini kanıtlamıştır (`https://doi.org/10.1145/1518701.1518815`).
2. **Doğal Tamamlanma / "Mutlu Terk" (*Happy Abandonment*: 4.–6. Aylar ve 9.–12. Aylar):**
   * Epstein ve ark. (2015), bir kullanıcının hedeflediği rutini öğrendikten sonra takibi bırakmasının bir başarısızlık değil, **"başarılı bir mezuniyet"** olduğunu vurgular (`https://doi.org/10.1145/2750858.2804250`): *"Stopping tracking is not always a failure; sometimes a tracker has served its purpose."* (`https://doi.org/10.1145/2750858.2804250`).
   * **Kronolojik Terk Noktaları:**
     * **Bez takibi:** Genellikle **1.–2. ayın sonunda** (bebek doğum kilosunu geçip düzenli kilo almaya başladığında) bırakılır; yalnızca kabızlık, ishal veya ateşli hastalık dönemlerinde geçici olarak geri dönülür (`https://pubmed.ncbi.nlm.nih.gov/36288484/`).
     * **Emzirme / Biberon dakika takibi:** Genellikle **3.–6. aylar arasında** emzirme düzeni oturduğunda veya anne işe dönüp sabit biberon saatlerine geçtiğinde bırakılır (`https://pubmed.ncbi.nlm.nih.gov/35643748/`).
     * **Uyku takibi:** En uzun süren günlük modüldür; gündüz uykusu geçişlerinde (3→2 uyku: 6–8. ay; 2→1 uyku: 12–15. ay) yoğunlaşır ve bebek tek gündüz uykusuna oturduğunda (**12.–18. ay**) günlük sayaç kullanımı sona erer (`docs/arastirma/A1_kaynak_dogrulama.md` §5).
     * **Kalıcı (Epizodik) Modüller:** 6. aydan sonra ebeveyn uygulamayı tamamen silmezse, onu uygulamada tutan özellikler **ek gıda (100 besin) çetelesi**, **büyüme persentili**, **aşı takvimi** ve **hastalıkta ateş/ilaç kaydıdır** (`https://doi.org/10.1145/1518701.1518815`).
   * *(Not: Ticari bebek takip uygulamalarının 30., 90. ve 180. gün kesin kohort tutundurma [retention] yüzdeleri şirketlerin ticari sırrı olup hakemli birincil kaynaklarda kamuya açık tekil bir endüstri standardı yüzdesi bulunmadığından kesin oran **DOĞRULANAMADI**).*

### 1.3. Bebek Takip Uygulamaları Üzerine Akademik Çalışmalar (HCI ve Pediatri)

| Çalışma / Yazarlar | Yayın Yeri ve Birincil Bağlantı | Temel Bulgu ve Ninnly İçin Önemi |
| :--- | :--- | :--- |
| **Dinour LM (2022)** | *J Nutr Educ Behav.*, 54(9):835-843. PMID: `35643748` (`https://pubmed.ncbi.nlm.nih.gov/35643748/`) | Doğum sonrası annelerin yarıdan fazlası (%57+) bebek beslenme takip uygulaması kullanmaktadır; ilk kez anne olanlarda ve emzirenlerde kullanım anlamlı derecede daha yüksektir (`https://doi.org/10.1016/j.jneb.2022.03.012`). |
| **Dinour LM & Pole A (2022)** | *JMIR Pediatr Parent.*, 5(4):e37581. PMID: `36288484` (`https://pubmed.ncbi.nlm.nih.gov/36288484/`) | İncelenen 41 emzirme uygulamasının içerik analizinde, uygulamaların çoğunun saat/taraf kaydı sunduğu ancak klinik doğruluk, kapsayıcı dil ve anne ruh sağlığı desteği açısından eksik kaldığı saptanmıştır (`https://doi.org/10.2196/37581`). |
| **Harries V & Brown A (2019)** | *Matern Child Nutr.*, 15(4):e12858 (`https://pubmed.ncbi.nlm.nih.gov/31222962/`) ve *Early Child Dev Care* (`https://doi.org/10.1080/03004430.2017.1378650`) | Katı rutinleri (saat başı emzirme/uyku şablonları) dayatan kaynakların kullanımı, bebeğin doğal değişkenliği şablona uymadığında **annelerde daha yüksek depresyon, anksiyete ve düşük öz-yeterlilik** ile ilişkili bulunmuştur. |
| **Lupton D & Pedersen S (2016)** | *Women Birth.*, 29(4):368-375. PMID: `26896295` (`https://pubmed.ncbi.nlm.nih.gov/26896295/`) | Avustralya'da 410 anne ile yapılan ankette, ebeveynlik uygulamalarının güvence sağladığı kadar "kuantifiye bebek" (*quantified baby*) üzerinden aşırı gözetim ve normallik kaygısı üretebildiği gösterilmiştir (`https://doi.org/10.1016/j.wombi.2016.01.008`). |
| **Kientz JA, Arriaga RI, Abowd GD (2009)** | *Proc. ACM CHI 2009*, s. 1719-1728 (`https://doi.org/10.1145/1518701.1518815`) | *Baby Steps* sistemi değerlendirmesi: Ebeveynler kayıtları yalnızca takip için değil, **çocuk doktoru randevularına hazırlık** ve **eşler arası koordinasyon** için kullanır; düşük veri giriş yükü sürdürülebilirlik için şarttır. |
| **Epstein DA, Ping A, Fogarty J, Munson SA (2015)** | *Proc. ACM UbiComp 2015*, s. 731-742 (`https://doi.org/10.1145/2750858.2804250`) | Kullanıcıların zamanlayıcı unutma (*lapsing*) ve dönemlik bırakma davranışları kaçınılmazdır; uygulama kullanıcıyı cezalandırmadan ("bozuk seri/streak" göstermeden) esnek geçmişe dönük düzenlemeye izin vermelidir. |

---

## 2. Gece Kullanımı: Fizyoloji, Tek El Ergonomisi ve Sistem Kısayolları

### 2.1. Gece 03:00 Senaryosunun Bağlamsal Kısıtları
Gece emzirmesi veya biberon beslemesi yapan bir ebeveyn dört eşzamanlı kısıt altındadır:
1. **Bilişsel Kısıt (Uyku Ataleti / *Sleep Inertia*):** Derin uykudan (yavaş dalga uykusu) aniden uyanan bireylerde ilk 15–30 dakika boyunca prefrontal korteks işlevleri, çalışma belleği ve ince motor karar hızı ciddi biçimde düşer (`https://pubmed.ncbi.nlm.nih.gov/11507175/`). Karmaşık menüler, küçük ikonlar veya klavyeyle sayı yazma bu evrede hata üretir.
2. **Fiziksel / Motor Kısıt (Tek El ve Bebek Kucakta):** Bir kol bebeğin başını ve gövdesini desteklerken yalnızca diğer elin başparmağı serbesttir. Steven Hoober'ın 1.333 mobil kullanıcı gözleminde normal şartlarda bile kullanıcıların **%49'unun telefonu tek elle**, **%75'inin ise yalnızca başparmağıyla** kullandığı saptanmıştır (`https://www.uxmatters.com/mt/archives/2013/02/how-do-users-really-hold-mobile-devices.php`). Karlson ve Bederson'ın (ACM CHI) tek el başparmak biyomekaniği araştırmaları, ekranın **üst köşelerinin (özellikle tutulan elin tersi üst köşenin)** kavrama güvenliğini bozmadan erişilemeyen "kırmızı bölge" olduğunu kanıtlamıştır (`https://doi.org/10.1145/1240624.1240686`).
3. **Görsel Kısıt (Karanlık Oda / Skotopik Karanlık Adaptasyonu):** Karanlığa alışmış göz bebeği (pupilla) genişlemiştir; yüksek parlaklıkta beyaz veya mavi ağırlıklı bir ekran hem ebeveynde kamaşma (*glare*) yaratır hem de kucaktaki bebeğin dikkatini çekerek uykuya dönüşünü zorlaştırır.
4. **Sirkadiyen Kısıt:** Gece ortasında maruz kalınan kısa dalga boylu ışık, ebeveynin emzirme bittikten sonra tekrar uykuya dalma süresini (*sleep onset latency*) uzatır (`https://pubmed.ncbi.nlm.nih.gov/25535358/`).

### 2.2. Ekran Işığının ve Renginin (Mavi, Kehribar, Kırmızı) Melatonine Etkisi: Bilimsel Kanıtlar
İnsan retinasında görüntü oluşturmayan sirkadiyen fotoreseptör sistemi ve dalga boylarının melatonin hormonuna etkisi nörobiyoloji literatüründe kesin olarak haritalanmıştır:

1. **İntrinsik Işığa Duyarlı Retinal Ganglion Hücreleri (ipRGC) ve Melanopsin (~460–480 nm):**
   * **Brainard ve ark. (2001)** (*J Neurosci.*, PMID: `11517229`, `https://pubmed.ncbi.nlm.nih.gov/11517229/`) ve **Thapan ve ark. (2001)** (*J Physiol.*, PMID: `11507175`, `https://pubmed.ncbi.nlm.nih.gov/11507175/`), insanlarda gece melatonin baskılanmasının aksiyon spektrumunu ölçmüş ve en yüksek duyarlılığın **446–477 nm (tepe noktası ~459–480 nm mavi/camgöbeği ışık)** aralığında olduğunu kanıtlamıştır.
   * Bu dalga boyu, klasik çubuk (*rod*) ve koni (*cone*) hücrelerinden bağımsız olarak retinal ganglion hücrelerindeki **melanopsin** fotopigmentini uyarır ve doğrudan beynin sirkadiyen merkezi olan suprakiazmatik çekirdeğe (SCN) sinyal göndererek epifiz bezinden melatonin salgısını akut olarak durdurur (`https://pubmed.ncbi.nlm.nih.gov/24397251/` — Lucas ve ark., *Trends Neurosci.* 2014).
2. **Tablet/Akıllı Telefon Ekranlarının Gece Etkisi (Chang ve ark., 2015 — PNAS):**
   * Harvard Tıp Fakültesi'nden **Chang, Aeschbach, Duffy ve Czeisler (2015)** tarafından *PNAS* dergisinde yayınlanan kontrollü laboratuvar çalışmasında (PMID: `25535358`, PMCID: `PMC4313820`, `https://pubmed.ncbi.nlm.nih.gov/25535358/`), yatmadan önce ışık yayan ekran (iPad, tepe emisyonu ~452 nm mavi ışık) kullanan katılımcılarda basılı kitap okuyanlara kıyasla **melatonin seviyesinin %55,12±20,12 oranında baskılandığı**, sirkadiyen saatin **1,5 saatten fazla geciktiği** ve uykuya dalma süresinin anlamlı biçimde uzadığı gösterilmiştir.
3. **Kırmızı (≥620 nm) ve Kehribar/Amber (585–610 nm) Dalga Boylarının Koruyucu Etkisi:**
   * Melanopsin fotopigmentinin duyarlılık eğrisi **580 nm (kehribar/amber)** üzerinde hızla düşer ve **620–650 nm (uzun dalga boylu kırmızı/mercan ışık)** bölgesinde sıfıra yaklaşır (`https://pubmed.ncbi.nlm.nih.gov/11517229/`).
   * **Figueiro ve ark. (2009 / 2019)** (*BMC Neurosci.* / *Nat Sci Sleep*, PMID: `19604391`, `https://pubmed.ncbi.nlm.nih.gov/19604391/` ve PMID: `30881166`, `https://pubmed.ncbi.nlm.nih.gov/30881166/`), uzun dalga boylu kırmızı ışığın gece melatonin salgısını baskılamadan görsel algıya izin verdiğini, buna karşılık 460–470 nm mavi ışığın düşük aydınlık düzeylerinde bile melatonini güçlü biçimde baskıladığını göstermiştir.
   * **OLED Ekran Avantajı:** Modern iPhone'larda kullanılan OLED panellerde tam siyah (`#000000`) veya çok koyu zemin pikselleri sıfır veya sıfıra yakın foton yayar; mavi alt piksellerin (`B` kanalı) tamamen kapatıldığı veya minimumda tutulduğu **kehribar/mercan (`#D97757`, `#E07A5F` vb.) ve sıcak koyu tonlar**, toplam melanopik lüksü (*melanopic EDI*) dramatik biçimde düşürür (`https://pubmed.ncbi.nlm.nih.gov/24397251/`).

### 2.3. Büyük Dokunma Hedefleri, Tek Dokunuşla Kayıt, Kilit Ekranı ve Saat
Apple Human Interface Guidelines (HIG) ve iOS 18 / watchOS 11 sistem mimarisi çerçevesinde gece kullanım standartları:

1. **Dokunma Hedefi Boyutları (Touch Targets):**
   * Apple HIG (`https://developer.apple.com/design/human-interface-guidelines/accessibility` ve `https://developer.apple.com/design/human-interface-guidelines/buttons`) tüm etkileşimli öğeler için **en az 44×44 pt** dokunma alanı şart koşar: *"Give all controls and interactive elements a hit target that measures at least 44x44 pt."* (`https://developer.apple.com/design/human-interface-guidelines/accessibility`).
   * Ancak gece 03:00'te uyku ataleti ve tek el kavrama altında 44×44 pt yalnızca asgari sınırdır; ana eylem düğmeleri (Sol Emzirme, Sağ Emzirme, Uyku Başlat/Bitir, Islak/Kirli Bez) ekranın **alt %50'lik başparmak yayında (Thumb Zone)** yer almalı ve **en az 64–88 pt yüksekliğinde** tam veya yarım genişlikli hedefler olarak tasarlanmalıdır (`docs/PLAN.md` §3).
2. **Klavyesiz Veri Girişi ve Yanlış Dokunuş Koruması:**
   * Gece biberon veya sağım miktarı (`ml`/`oz`) girerken tam ekran sayısal klavye açmak hem ekranın alt yarısını kaplar hem de parlak bir yüzey oluşturur. Bunun yerine haptik geri bildirimli (`sensoryFeedback`) **dikey kaydırma tekerleği (picker/wheel)** ve `+10 ml / -10 ml` hızlı adım düğmeleri kullanılmalıdır (`docs/PLAN.md` §3).
   * Yanlışlıkla sayacı sıfırlamayı veya silmeyi önlemek için "Emin misiniz?" modal penceresi (gece okumayı zorlaştırır) yerine **0,7 saniye basılı tutarak onaylama (long-press ring)** mekanizması hem tek parmakla çalışır hem de kazara dokunuşları %100 engeller (`docs/PLAN.md` §3).
3. **Kilit Ekranından (Live Activities / Dynamic Island) ve Apple Watch'tan Kayıt:**
   * **ActivityKit ve Etkileşimli Live Activities (iOS 17+ / iOS 18):** Apple HIG Live Activities kılavuzuna (`https://developer.apple.com/design/human-interface-guidelines/live-activities`) göre, devam eden bir emzirme veya uyku sayacı kilit ekranında (Always-On Display dahil) ve Dynamic Island'da görünür. `AppIntent` (`LiveActivityIntent`) kullanılarak kullanıcı **telefonun kilidini açmadan ve uygulamaya girmeden** kilit ekranındaki düğmeye tek dokunuşla basarak:
     * Emzirme tarafını değiştirebilir (Sol ↔ Sağ),
     * Sayacı duraklatabilir veya tamamlayıp kaydedebilir (`https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities`).
   * **iOS 18 Kilit Ekranı ve Denetim Merkezi (Control Center) Kontrolleri:** iOS 18 ile birlikte `ControlWidget` API'si sayesinde iPhone kilit ekranının sol/sağ alt köşesindeki el feneri/kamera düğmelerinin yerine veya Action Button'a "Emzirme Başlat" / "Islak Bez Kaydet" atanabilir (`https://developer.apple.com/documentation/widgetkit/creating-controls-for-control-center-and-the-lock-screen`).
   * **Apple Watch (watchOS 11) ve Siri:** Kucakta bebek varken telefon sehpanın üzerinde uzağa kalmış olabilir. Apple Watch üzerindeki `Smart Stack` bileşeni ve tek dokunuşlu Watch arayüzü veya *"Hey Siri, Ninnly'de sol emzirmeyi başlat"* (`AppShortcutsProvider`) sesli komutu, ekrana hiç bakmadan **0 ekran ışığıyla** kayıt yapılmasını sağlar (`https://developer.apple.com/documentation/appintents/app-shortcuts`).

---

## 3. Eş ve Bakıcı Paylaşımı: Devir Teslim, Çakışma Çözümü ve Bildirim Dengesi

### 3.1. Devir Teslim (Handoff) ve "Kimin Ne Zaman Beslediğini Görme"
Çoklu bakıcı (anne, baba/eş, büyükanne, profesyonel bakıcı) senaryolarında en kritik bilgi **"Son olay ne zaman oldu ve kim yaptı?"** sorusudur (`https://doi.org/10.1145/1518701.1518815`).
* **Bakıcı Bağlamı (Caregiver Attribution):** Her `CareEvent` kaydında kaydı oluşturan kişinin kimliği (`createdBy`) ve son güncelleyen kişinin kimliği (`updatedBy`) tutulmalıdır. Ana ekranda *"Son beslenme: 1 saat 45 dk önce · 120 ml Anne Sütü (Baba)"* şeklinde tek satırlık özet gösterilmesi, nöbet devralan eşin tek bakışta durumu anlamasını sağlar.
* **Devir Teslim Notu (Sticky Note / Pinned Note):** Örneğin annenin işe çıkarken veya uykuya yatarken ekranın en üstüne sabitleyebildiği *"Buzdolabındaki mavi kapaklı 110 ml sütü ısıtıp ver, D vitamini sabah verildi"* şeklinde tek satırlık canlı durum notu, bakıcı iletişim hatalarını (özellikle **çift doz D vitamini veya ateş düşürücü ilaç verilmesi** riskini) ortadan kaldırır (`docs/PLAN.md` §4.5).

### 3.2. Aynı Anda İki Kişinin Kaydı ve Çakışma Çözümü (Core Data + CloudKit)
Ninnly'nin veri katmanı `NSPersistentCloudKitContainer` (özel + paylaşılan `CKRecordZone` / `CKShare`) üzerine kuruludur (`docs/PLAN.md` §3). İki cihazın aynı anda kayıt girmesi durumunda iki farklı teknik senaryo oluşur:

1. **Aynı Olayın İki Farklı Kişi Tarafından Ayrı Ayrı Kaydedilmesi (Mantıksal Çift Kayıt / Duplicate Event):**
   * *Senaryo:* Bebek saat 14:00'te kaka yapar; anne ve baba birbirinden habersiz 2 dakika arayla kendi telefonlarından "Kirli Bez" kaydı girer. Teknik olarak bunlar farklı `UUID` taşıyan iki ayrı `CKRecord` olduğu için CloudKit bunu "çakışma" saymaz, ikisini de ekler ve günlük bez sayısı yanlışlıkla +2 artar.
   * *Ninnly UX ve Kural Çözümü:* Buluttan yeni bir `CareEvent` geldiğinde (`NSPersistentCloudKitContainer.eventChangedNotification`), eğer aynı bebek için aynı `type` (ör. `diaper`, `bottle`, `medication`) türünde **±5 dakika içinde** başka bir bakıcı tarafından oluşturulmuş bir kayıt varsa:
     * **İlaç (`medication`) ise:** "Çift Doz Koruması" devreye girer (`docs/PLAN.md` §4.5). İkinci kişi ilaç kaydetmeye çalıştığında ekran kırmızı/kehribar uyarı verir: *"Dikkat: 12 dakika önce [Eş] tarafından Parasetamol kaydedildi. Yine de kaydetmek için basılı tutun."*
     * **Bez / Biberon ise:** Kayıt engellenmez ancak zaman çizelgesinde sessiz bir birleştirme önerisi (*"14:02 ve 14:04'te iki bez kaydı var, aynı bez mi? [Birleştir]"*) sunulur.
2. **Aynı Kaydın İki Cihazda Aynı Anda Düzenlenmesi (Veritabanı Çakışması / Merge Conflict):**
   * *Senaryo:* Anne devam eden bir uyku kaydına not eklerken, baba aynı uyku kaydının bitiş saatini düzenler.
   * *Teknik Çözüm:* Apple Developer resmi dokümantasyonuna göre (`https://developer.apple.com/documentation/coredata/mirroring_a_core_data_store_with_cloudkit/setting_up_core_data_with_cloudkit`), `viewContext.automaticallyMergesChangesFromParent = true` ve `viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy` kullanılmalıdır. Böylece kayıt bütünsel olarak ezilmez; **özellik (property) bazında** birleştirilir (annenin yazdığı `note` alanı ile babanın güncellediği `endDate` alanı aynı kayıtta korunur). Ayrıca her kayıtta `modifiedAt` zaman damgası tutularak son yazan alan kazanır (*Last-Writer-Wins per attribute*).

### 3.3. Büyükanne ve Bakıcının Rolü (Yetkilendirme ve Basitleştirilmiş Görünüm)
* **Apple CloudKit (`CKShare`) İzin Yapısı:** `CKShare.ParticipantPermission` yalnızca `.readOnly` (salt okunur) veya `.readWrite` (okuma/yazma) sunar (`https://developer.apple.com/documentation/cloudkit/ckshare/participantpermission`).
* **Büyükanne / Bakıcı UX İhtiyacı:** Büyükanne veya gündüz bakıcısı gün içinde **bez, beslenme ve uyku girmek** zorundadır (dolayısıyla `.readWrite` gerekir); ancak yanlışlıkla bebeğin doğum tarihini değiştirmemeli, geçmiş ayların verisini silmemeli veya DSÖ persentil/süt stoku ayarlarını bozmamalıdır.
* **Ninnly Çözümü ("Bakıcı Modu" / Caregiver Role):** `CKShare` üzerinde yazma izni verilse bile, uygulama içi profil rolü "Bakıcı / Aile Büyüğü" olarak seçildiğinde arayüz **Sadeleştirilmiş Bakıcı Görünümüne** geçer:
  * Yalnızca **Bugünün Özeti**, **Beslenme, Uyku, Bez, İlaç/Ateş** büyük kayıt düğmeleri ve **Sabitlenmiş Ebeveyn Notu** görünür.
  * Bebek profili silme, CSV dışa/içe aktarma ve toplu geçmiş silme işlemleri yalnızca `CKShare.owner` (ebeveyn) hesabına açıktır.

### 3.4. Bildirimlerin Rahatsız Etmemesi (Akıllı ve Saygılı Bildirim Mimarisi)
Gece vardiyalı uyuyan ebeveynlerde en büyük şikâyet, nöbette olmayan (uyuyan) ebeveynin telefonunun da bildirimle ötmesidir.
* **Temel Kurallar:**
  1. **Eylem Bildirimi Varsayılan Olarak Kapalı / Sessiz:** Eş "Islak Bez" veya "Emzirme" kaydettiğinde diğer eşe sesli/titreşimli anlık bildirim **gönderilmez**; bunun yerine kilit ekranındaki **Live Activity / Widget** sessizce güncellenir.
  2. **"Nöbetteyim / Uyuyorum" (Shift Toggle) ve iOS Odak (Focus) Uyumu:** Apple'ın `UNNotificationInterruptionLevel` API'si (`https://developer.apple.com/documentation/usernotifications/unnotificationinterruptionlevel`) kullanılarak:
     * Rutin eşitleme ve özetler `.passive` (ekranı uyandırmaz, ses çıkarmaz),
     * Uyku Penceresi ve süt son kullanma hatırlatıcıları `.active` (standart bildirim, Uyku Odak moduna saygı duyar),
     * İlaç saati veya yüksek ateş takibi `.timeSensitive` (zaman duyarlı) seviyesinde gönderilir.

---

## 4. Rakiplerde Kullanım Deneyimi: En İyi Uygulamalar ve Tuzaklar

Kasım 2026 itibarıyla ABD ve Türkiye App Store pazarındaki başlıca rakiplerin (`Huckleberry`, `Nara Baby`, `Baby Tracker - Newborn Log`, `Cubtale`, `Glow Baby`) mağaza verileri ve kullanıcı deneyimi analiz edilmiştir:

### 4.1. Rakip Mağaza ve İş Modeli Tablosu (16 Kasım 2026 İtibarıyla Doğrulanan Veriler)

| Uygulama | App Store Bağlantısı | Puan (ABD App Store, Kasım 2026) | İş Modeli ve Fiyatlandırma (Kasım 2026) | Güçlü Yönü (En İyi Uygulama) | En Büyük UX Tuzağı |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Huckleberry: Baby & Child** | `https://apps.apple.com/us/app/huckleberry-baby-child/id1428476816` | ~4.9 / 5 | Freemium + Abonelik (Plus: ~$9.99–$11.99/ay veya ~$58.99/yıl; Premium: ~$14.99/ay veya ~$119.99/yıl) | *SweetSpot®* uyku penceresi tahmini ve kilit ekranı Live Activity zamanlayıcısı. | **Uzun kayıt (onboarding) hunisi** (10+ ekran anket), en değerli özellik olan uyku tahmininin abonelik duvarı (*paywall*) arkasında olması, çok sayıda alt alan içeren karmaşık giriş formları. |
| **Nara Baby & Pregnancy Tracker** | `https://apps.apple.com/us/app/nara-baby-pregnancy-tracker/id1444639029` | ~4.8 / 5 | Freemium + Uygulama İçi Abonelik (*Plus* katmanı; tarihsel olarak ücretsizken abonelik katmanı eklenmiştir, `docs/PLAN.md` §2.7) | Kutusuz/sakin görsel dil, büyük karolar, Apple Watch ve çoklu bakıcı eşitlemesi. | Hesap açma zorunluluğu (e-posta/şifre), dinamik ve karmaşık CSV yapısı (`docs/arastirma/A1_kaynak_dogrulama.md` §6.2), gelişmiş analizlerin abonelik gerektirmesi. |
| **Baby Tracker - Newborn Log** (Nighp Software) | `https://apps.apple.com/us/app/baby-tracker-newborn-log/id779656557` | ~4.8 / 5 | Ücretsiz (Reklamlı) + Tek Seferlik / Abonelik Seçenekleri | Çok hızlı tek ekranlı giriş, Apple Watch ve Siri kısayolları, doktor ziyareti özetleri. | **Görsel kalabalık ve eski arayüz**, ücretsiz sürümde ekranın altında beliren reklam bantlarının gece karanlıkta parlama yapması ve yanlış dokunuşa yol açması. |
| **Glow Baby: Newborn Tracker Log** | `https://apps.apple.com/us/app/glow-baby-newborn-tracker-log/id1077177456` | ~4.7 / 5 | Freemium + Agresif Abonelik / Reklam | Zengin grafikler ve karşılaştırmalı istatistikler. | **Aşırı agresif ödeme duvarı (paywall) pop-up'ları**, topluluk forumları ve bildirim kalabalığı, diğer bebeklerle kıyaslama yaparak ebeveyn kaygısını tetiklemesi. |

### 4.2. Rakiplerde Tespit Edilen 4 Kritik UX Tuzağı ve Ninnly'nin Avantajı
1. **Tuzak 1 — "Doğumhanede 15 Soruluk Anket" (Uzun Onboarding):**
   * *Sorun:* Rakiplerin çoğu (özellikle Huckleberry ve Glow Baby), kullanıcı uygulamayı ilk açtığında hesap oluşturma, e-posta doğrulama, bebeğin uyku sorunları, emzirme hedefleri ve abonelik planı seçimi içeren **8 ila 15 ekranlık** bir kurulum hunisi dayatır. Oysa kullanıcı uygulamayı çoğu zaman doğumhanede veya gece 02:00'de emzirme sırasında indirir.
   * *Ninnly Kararı:* Sıfır hesap, sıfır e-posta, sıfır anket (§8).
2. **Tuzak 2 — Form Kalabalığı (Over-instrumented Forms):**
   * *Sorun:* Basit bir uyku kaydı için kullanıcıdan "Uyuma şekli (emerek, sallanarak, kendi kendine)", "Uyuduğu yer (beşik, puset, kucak)", "Uyandığındaki ruh hali (mutlu, huzursuz)" gibi 5–6 alt alanı doldurmasını beklemek (`docs/arastirma/A1_kaynak_dogrulama.md` §6.1), veri giriş yorgunluğunu hızlandırır (`https://doi.org/10.1145/2750858.2804250`).
   * *Ninnly Kararı:* Varsayılan kayıt **tek dokunuştur**; detay etiketleri (renk, kıvam, not) zorunlu değil, isteğe bağlı ve katlanmış (*progressive disclosure*) olmalıdır.
3. **Tuzak 3 — Ödeme Duvarının (Paywall) En Kritik Anda Çıkması:**
   * *Sorun:* Ücretsiz indirilen uygulamalarda ebeveyn 2–3 hafta boyunca tüm verisini girdikten sonra, tam 2. ay uyku krizinde uyku penceresi tahminine veya doktor randevusu öncesi PDF rapora tıkladığında **yıllık 60–120 USD'lik abonelik duvarıyla** karşılaşır. Bu durum "rehin alınmış veri" (*data hostage*) hissi yaratır.
   * *Ninnly Kararı:* Ninnly **tek fiyatlı ücretli uygulama** olduğu için (`docs/PLAN.md` §1) uygulama içinde tek bir kilitli simge, "Pro'ya Geç" düğmesi, deneme süresi geri sayımı veya reklam **yoktur**.
4. **Tuzak 4 — Grafiklerin Anlaşılmazlığı ("Barkod Grafikler"):**
   * *Sorun:* Rakiplerin 24 saatlik zaman çizelgesi grafiklerinde 10 farklı aktivite rengi üst üste biner ve küçük ekranlarda okunaksız bir "barkod" görüntüsü oluşur.
   * *Ninnly Kararı:* Swift Charts ile çizilen grafikler (`docs/PLAN.md` §3) aynı anda yalnızca seçili metriği (ör. yalnızca Uyku veya yalnızca Beslenme) net tipografiyle gösterir; parmakla tarandığında (*scrubbing*) haptik tık ile o günün tam değerini okur.

---

## 5. Duygusal Tasarım: Ebeveyn Kaygısını Artırmamak ve Doğum Sonrası Depresyon Farkındalığı

### 5.1. Ebeveyn Kaygısını Artırmayan Tasarım ("Kaygısız Görünüm" ve Suçlamayan Dil)
Akademik literatür (Harries & Brown 2019, `https://pubmed.ncbi.nlm.nih.gov/31222962/`; Lupton & Pedersen 2016, `https://pubmed.ncbi.nlm.nih.gov/26896295/`), bebek takip uygulamalarındaki **keskin norm çizgilerinin, kırmızı uyarı renklerinin ve diğer bebeklerle kıyaslamaların** annelerde klinik düzeyde anksiyeteyi tetiklediğini ortaya koymaktadır.

1. **Persentil Korkusu ve Çözümü:**
   * *Sorun:* Bir bebeğin DSÖ (WHO) büyüme eğrisinde 15. persentilde olması tıbben tamamen sağlıklı bir durum olabilir (önemli olan bebeğin kendi eğrisini korumasıdır: `https://www.cdc.gov/growthcharts/who-growth-charts.html`). Ancak uygulamalar 50. persentili (medyanı) kalın yeşil bir "hedef çizgisi" gibi gösterdiğinde, 15. persentildeki bebeğin ebeveyni bebeğinin "geride kaldığını" düşünerek paniğe kapılır.
   * *Ninnly Çözümü:*
     * Persentil eğrileri (3., 15., 50., 85., 97.) birbirine eşit ağırlıkta, yumuşak tonlu referans bantları olarak çizilir; **50. persentil "ideal hedef" gibi vurgulanmaz**.
     * **"Kaygısız Görünüm" Anahtarı (`docs/PLAN.md` §3):** Kullanıcı bu anahtarı açtığında persentil yüzdeleri, hedef karşılaştırmaları ve "düne göre %20 daha az uyudu" gibi kıyaslamalar gizlenir; yalnızca ham kayıtlar ve bebeğin kendi büyüme çizgisi gösterilir.
2. **Kırmızı Uyarıların Yasaklanması ve App Store Guideline 1.4.1 Uyumu:**
   * Tıbbi aciliyet taşımayan hiçbir veri (ör. kısa gündüz uykusu, geciken emzirme, yeşil dışkı) için **alarm kırmızısı (`#FF0000`) veya ünlem işareti kullanılmaz**.
   * `docs/PLAN.md` §2.5 ve `docs/arastirma/A1_kaynak_dogrulama.md` §7.1 (App Store Review Guideline 1.4.1, `https://developer.apple.com/app-store/review/guidelines/#physical-harm`) uyarınca dışkı rengi, ateş ve büyüme verileri kesinlikle teşhis dili (*"Bebeğinizde ishal/enfeksiyon var"*, *"Yetersiz kilo alımı"*) kullanmaz; yalnızca **"Bilgi + Doktorunuza danışın"** formatında nötr ve sakin bir dille sunulur.
3. **Suçlamayan, Kapsayıcı Dil (Non-Judgmental Microcopy):**
   * **Emzirme vs. Mama (Formula):** Anne sütü ve formül mama seçenekleri arayüzde eşit görsel hiyerarşide sunulur. Mama seçildiğinde veya emzirme süresi kısa olduğunda suçluluk uyandıracak hiçbir ifade yer almaz.
   * **Unutulan Zamanlayıcılar:** Kullanıcı emzirme veya uyku sayacını kapatmayı unuttuğunda (ör. sayaç 10 saattir çalışıyorsa), hata mesajı vermek yerine nazikçe *"Sayaç açık kalmış görünüyor. Bitiş saatini tahmin etmemizi ister misiniz? [Son 7 gün ortalaması: 18 dk]"* seçeneği sunulur (`https://doi.org/10.1145/2750858.2804250`).

### 5.2. Doğum Sonrası Depresyon (PPD) Farkındalığı: Etik, Klinik ve Yasal Sınırlar
Doğum sonrası depresyon (Postpartum Depression - PPD) ve anksiyete, yeni annelerin yaklaşık **%10 ila %20'sini** (ve babaları da) etkileyen ciddi bir halk sağlığı sorunudur (`https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2018/11/screening-for-perinatal-depression`). Amerikan Pediatri Akademisi (AAP), bebeklerin **1., 2., 4. ve 6. ay** rutin sağlam çocuk izlemlerinde ebeveynlerin de PPD açısından desteklenmesini önerir (`https://publications.aap.org/pediatrics/article/143/1/e20183259/37241/Incorporating-Recognition-and-Management-of`). Türkiye'de de T.C. Sağlık Bakanlığı **Doğum Sonu Bakım Yönetim Rehberi** kapsamında lohusa izlemlerinde **Edinburgh Doğum Sonrası Depresyon Ölçeği (EDDS / EPDS)** ile risk taraması ve sevk protokolü tanımlanmıştır (`https://hsgm.saglik.gov.tr/tr/kadin-ve-ureme-sagligi`).

**Bir Bebek Takip Uygulaması Bunu Tanı Koymadan Nasıl ve Hangi Sınırlarla Ele Alabilir?**
1. **Kesin Sınır — Tanı ve Otomatik Puanlama Yapmama (App Store 1.4.1 & Tıbbi Cihaz Sınırı):**
   * Ninnly bir tıbbi cihaz (SaMD) veya psikiyatrik tanı aracı değildir (`https://developer.apple.com/app-store/review/guidelines/#physical-harm`). Uygulama, annenin gece uyanma sıklığına veya emzirme kayıtlarına bakarak **arka planda algoritmik depresyon tahmini yapmamalı** ve *"Depresyon belirtileri gösteriyorsunuz"* gibi bir bildirim **kesinlikle göndermemelidir**.
2. **İzin Verilen Doğru Yaklaşım — Şefkatli Farkındalık ve Doğrudan Destek Hatlarına Bağlantı:**
   * **Ebeveyn Öz-Bakım Köşesi ("Sen Nasılsın?"):** Sağlık veya Ayarlar/Rehber sekmesi içinde, tamamen isteğe bağlı, yargılamayan ve sunucuya hiçbir veri göndermeyen bir **"Ebeveyn İyi Oluş ve Destek Rehberi"** kartı yer alır.
   * **Normalleştirici Dil:** *"Yenidoğan dönemi uykusuz, yorucu ve duygusal olarak zorlayıcı olabilir. Kendinizi sürekli üzgün, aşırı kaygılı, tükenmiş veya yalnız hissediyorsanız bu sizin suçunuz değildir ve yalnız değilsiniz."*
   * **Tek Dokunuşla Resmi Destek ve Kriz Hatları (TR ve ABD):**
     * **Türkiye İçin:**
       * **Aile Hekimi / Sağlıklı Hayat Merkezi (SHM) Psikososyal Destek Birimleri** (ücretsiz psikolojik danışmanlık bilgisi: `https://hsgm.saglik.gov.tr/`),
       * **ALO 183** Sosyal Destek Hattı (Aile ve Sosyal Hizmetler Bakanlığı 7/24 ücretsiz hat: `https://www.aile.gov.tr/alo183/`),
       * **112** Acil Çağrı Merkezi.
     * **ABD İçin:**
       * **Postpartum Support International (PSI) Yardım Hattı:** `1-800-944-4773` (Arama/SMS, İngilizce ve İspanyolca, `https://www.postpartum.net/get-help/`),
       * **Ulusal Anne Ruh Sağlığı Hattı (National Maternal Mental Health Hotline - HRSA):** `1-833-TLC-MAMA` (`1-833-852-6262`, `https://mchb.hrsa.gov/programs-impact/national-maternal-mental-health-hotline`),
       * **988 Suicide & Crisis Lifeline:** `988` (`https://988lifeline.org/`).

---

## 6. Erişilebilirlik: Dynamic Type, VoiceOver, Hareketi Azalt ve Ebeveynlere Özel Gereksinimler

Apple Human Interface Guidelines Erişilebilirlik bölümü (`https://developer.apple.com/design/human-interface-guidelines/accessibility`) sadece kalıcı engeli olan bireyleri değil, **durumsal kısıtları (*situational disabilities*)** olan kullanıcıları da kapsar. Kucağında ağlayan bir bebekle karanlık odada tek elle telefon tutan uykusuz bir ebeveyn; aynı anda **durumsal motor kısıt**, **durumsal görme kısıtı** ve **durumsal bilişsel yorgunluk** yaşamaktadır.

### 6.1. Dynamic Type (Dinamik Punto Boyutu)
* **Apple Standartları:** Tüm metinler sabit piksel boyutları yerine sistem metin stillerini (`.largeTitle`, `.title2`, `.body`, `.caption`) veya `@ScaledMetric` özelliğini kullanmalıdır (`https://developer.apple.com/design/human-interface-guidelines/typography`).
* **Ebeveyn Özel Gereksinimi:** Gece gözlüğünü veya kontakt lensini çıkarmış miyop/astigmat bir ebeveyn ya da yaşça büyük bir büyükanne/büyükbaba (presbiyopi nedeniyle) iOS metin boyutunu `AX1`–`AX5` (Erişilebilirlik Boyutları) seviyesine çıkarmış olabilir.
* **Uygulama Kuralı:** `DynamicTypeSize.isAccessibilitySize` aktif olduğunda yatay (`HStack`) yan yana duran "Sol Göğüs / Sağ Göğüs" veya "Islak / Kirli Bez" düğmeleri metni kesmek (`...` truncation) yerine otomatik olarak dikey (`VStack` / `ViewThatFits`) düzene geçmeli ve zamanlayıcı rakamları asla kırpılmamalıdır (`https://developer.apple.com/documentation/swiftui/viewthatfits`).

### 6.2. VoiceOver ve Ekran Okuyucu Desteği
* **Apple Standartları:** Her etkileşimli bileşenin anlamlı bir `accessibilityLabel`, durum bilgisi için `accessibilityValue` ve eylem ipucu için `accessibilityHint` değeri olmalıdır (`https://developer.apple.com/design/human-interface-guidelines/accessibility`).
* **Ninnly Özel Kuralları:**
  1. **Birleşik Okuma (`accessibilityElement(children: .combine)`):** Ana ekrandaki "Son Emzirme" satırında ikon, başlık, süre ve sağ/sol etiketi ayrı ayrı 4 odak noktası olmak yerine tek bir cümle olarak okunmalıdır: *"Son emzirme: 2 saat 10 dakika önce, Sol göğüs, 14 dakika."*
  2. **Canlı Sayaçlarda Gürültüyü Önleme:** Çalışan bir saniye sayacı her saniye VoiceOver tarafından sesli okunursa hem ekran okuyucu kilitlenir hem de kucaktaki bebek uyanır. Bu nedenle sayaç bileşeninde `.accessibilityUpdatesFrequently` trait'i dikkatli kullanılmalı ve saniyeler yerine yalnızca dakika değişimleri veya kullanıcı odaklandığında geçen süre okunmalıdır (`https://developer.apple.com/documentation/swiftui/accessibility- traits`).
  3. **Swift Charts Sesli Grafik (`AXChartDescriptor`):** Büyüme ve uyku grafikleri Swift Charts'ın yerleşik Sesli Grafik (*Audio Graphs*) protokolünü desteklemeli; görme engelli bir ebeveyn bebeğinin büyüme eğrisini ses perdesi ve özet tablo olarak dinleyebilmelidir (`https://developer.apple.com/documentation/charts/chart`).

### 6.3. Hareketi Azalt (Reduce Motion) ve Gece Hareket Tasarımı
* `docs/PLAN.md` §3'te tanımlanan yaylı (spring) düğmeler, nefes alan sayaç, çizilerek açılan logo ve grafik animasyonları `@Environment(\.accessibilityReduceMotion)` değişkenini dinlemek zorundadır (`https://developer.apple.com/documentation/swiftui/environmentvalues/accessibilityreducemotion`).
* **Kural:** Kullanıcı iOS ayarlarından "Hareketi Azalt" seçeneğini açtığında; yaylı zıplamalar, ölçek büyüme/küçülmeleri (`scaleEffect`) ve grafik çizim animasyonları devre dışı kalır, yalnızca yumuşak opaklık geçişleri (`opacity`) çalışır. Gece fazında ise Hareketi Azalt kapalı olsa bile parlama ve hızlı yanıp sönme kesinlikle yapılmaz (`docs/PLAN.md` §3).

### 6.4. Renk Körlüğü (Color Blindness) ve Motor Kısıtlar
* **Renk + Sembol İkilisi:** Islak bez, kirli bez, anne sütü ve mama ayrımları yalnızca renkle yapılmaz; her zaman belirgin bir **SF Symbol ikonu + metin etiketi** ile desteklenir (`https://developer.apple.com/design/human-interface-guidelines/color`).
* **Motor Kısıtlar (Karpal Tünel ve Tek El):** Gebelik ve lohusalık döneminde ödem nedeniyle yaygın görülen **postpartum karpal tünel sendromu** ve De Quervain tenosinoviti (anne bileği ağrısı), sıkı kavrama ve iki parmakla kıstırma (*pinch-to-zoom*) hareketlerini ağrılı hale getirir. Bu nedenle Ninnly'de hiçbir özellik iki parmak hareketi veya yatay kaydırma zorunluluğu gerektirmez; her işlem tek dokunuşla yapılır.

---

## 7. Türkiye'ye Özgü Dinamikler: Emzirme Verileri, Aile Hekimi, Büyükanne Rolü ve Birimler

### 7.1. Türkiye'de Emzirme Oranları ve Süreleri (TNSA ve Resmi Veriler)
Hacettepe Üniversitesi Nüfus Etütleri Enstitüsü (HÜNEE) tarafından yürütülen **Türkiye Nüfus ve Sağlık Araştırması (TNSA)** serisi, Türkiye'nin birincil ulusal demografik veri kaynağıdır (`http://www.hips.hacettepe.edu.tr/`):
* **Güncel Yayın Durumu Notu (Kasım 2026 İtibarıyla):** Serinin yeni halkası olan **TNSA-2024**'ün Ön Rapor Toplantısı **8 Nisan 2026** tarihinde Hacettepe Üniversitesi ve Cumhurbaşkanlığı Strateji ve Bütçe Başkanlığı (SBB) katılımlarıyla gerçekleştirilmiştir (`http://www.hips.hacettepe.edu.tr/`); ancak yaş-ay kırılımlı tam emzirme veri tablolarını içeren nihai ana rapor henüz kamuya açık tam metin olarak yayınlanmadığından TNSA-2024'ün alt kırılım yüzdeleri **DOĞRULANAMADI**. Kamuya açık, doğrulanmış en kapsamlı ulusal resmi veri seti **TNSA-2018 Ana Raporu** ve T.C. Sağlık Bakanlığı Sağlık İstatistikleri Yıllığı verileridir (`http://www.hips.hacettepe.edu.tr/tnsa2018/rapor/TNSA2018_ana_Rapor.pdf`):
  1. **Herhangi Bir Süre Emzirilme Oranı:** Türkiye'de doğan bebeklerin **%98'i** yaşamlarının bir döneminde emzirilmektedir (`http://www.hips.hacettepe.edu.tr/tnsa2018/rapor/TNSA2018_ana_Rapor.pdf`).
  2. **Doğumdan Sonraki İlk 1 Saatte Emzirme:** Bebeklerin **%71,3'ü** ilk 1 saat içinde, **%85,6'sı** ilk 24 saat içinde emzirilmeye başlanmaktadır.
  3. **İlk 6 Ay (0–5 Ay) Sadece Anne Sütü Oranı:** DSÖ önerisine uygun olarak ilk 6 ay *sadece anne sütü* alan bebeklerin oranı genel toplamda **%40,7**'dir. Ancak aylara göre keskin bir düşüş vardır:
     * **0–1 aylık bebeklerde:** **%59,2**
     * **2–3 aylık bebeklerde:** **%45,1**
     * **4–5 aylık bebeklerde:** **%14,4** (su, bitki çayı, mama veya erken tamamlayıcı gıda verilmesi nedeniyle hızla düşmektedir).
  4. **Ortanca Emzirme Süresi:** Türkiye'de toplam **ortanca emzirme süresi 16,7 ay** iken, **sadece anne sütüyle beslenme ortanca süresi yalnızca 1,8 aydır** (`http://www.hips.hacettepe.edu.tr/tnsa2018/rapor/TNSA2018_ana_Rapor.pdf`).
* **Ninnly Ürün Tasarımına Doğrudan Etkisi:** Türkiye'deki annelerin %98'i emzirmeye başlamakta ve ortanca 16,7 ay devam etmektedir; ancak 2.–4. aylardan itibaren **karma beslenme (anne sütü + biberonla sağılmış süt veya formül mama)** oranı çok yüksektir. Bu nedenle Ninnly'de emzirme ve biberon modülleri birbirinden kopuk iki ayrı dünya gibi değil, **aynı öğün içinde birlikte kaydedilebilir ("Önce 10 dk emdi + üstüne 60 ml mama/sağılmış süt aldı")** şekilde akıcı olmalıdır (`docs/PLAN.md` §4.1).

### 7.2. Fiziksel Aşı Kartı, Aile Sağlığı Merkezi (ASM) ve e-Nabız Alışkanlığı
* **ASM İzlem Kültürü:** Türkiye'de bebeklerin 0–24 ay rutin aşıları (`docs/arastirma/A1_kaynak_dogrulama.md` §1: 14 Nisan 2025'te yürürlüğe giren **6'lı Karma Aşı [DaBT-İPA-Hib-HepB]** şeması) ve topuk kanı/büyüme izlemleri (`docs/arastirma/A1_kaynak_dogrulama.md` §2) mahalledeki **Aile Sağlığı Merkezlerinde (ASM)** Aile Hekimi ve Aile Sağlığı Çalışanı (ebe/hemşire) tarafından ücretsiz yürütülür (`https://asi.saglik.gov.tr/`).
* **Fiziksel Karton Aşı Kartı + e-Nabız İkiliği:** ASM'de her bebeğe basılı bir **karton Aşı ve İzlem Kartı** verilir; aynı zamanda uygulanan aşılar karekod (ATS - Aşı Takip Sistemi) ile T.C. Sağlık Bakanlığı **e-Nabız** (`https://enabiz.gov.tr/`) sistemine işlenir.
* **Eksik Halka ve Ninnly'nin Rolü:**
  1. Özel hastanede veya muayenehanede yaptırılan **ulusal takvim dışı özel aşılar (Rotavirüs 2/3 doz, Meningokok ACWY ve Meningokok B)** (`docs/arastirma/A1_kaynak_dogrulama.md` §1.3) ASM'nin standart rutin çizelgesinden farklı zamanlarda planlanır ve ebeveynlerin kafasını en çok karıştıran konudur. Ninnly'de **Ulusal Takvim (Ücretsiz ASM)** ile **Özel / İsteğe Bağlı Aşılar (Doktor Önerisiyle)** net bir görsel ayrım ve doz hatırlatıcısıyla sunulmalıdır (`docs/arastirma/A1_kaynak_dogrulama.md` §8.1).
  2. ASM veya özel çocuk doktoru muayenesine giderken hekimler *"Son 1 haftada günde kaç kez emdi, kaç kaka yaptı, D vitamini ve demir damlasını düzenli alıyor mu?"* diye sorar. Ninnly'nin **Tek Sayfalık Doktor PDF Özeti** (`docs/PLAN.md` §3, §4.5), ebeveynin muayenede 30 saniyede hekime gösterebileceği klinik özet formatında olmalıdır.

### 7.3. Türkiye'de Büyükanne (Anneanne / Babaanne) ve Bakıcı Rolü
* Türkiye'de annenin doğum izni (ücretli analık izni doğum sonrası 8 hafta + yarı zamanlı/ücretsiz izin seçenekleri) bittiğinde veya lohusalığın ilk 40 gününde ("kırk çıkarma" geleneği) bebek bakımında **anneanne ve babaanne** birincil destekçidir (`http://www.hips.hacettepe.edu.tr/tnsa2018/rapor/TNSA2018_ana_Rapor.pdf`).
* **Kuşaklararası UX Gereksinimi:**
  1. **Yüzde 100 Anlaşılır Türkçe Terimler:** "Wake Window", "Pump", "Stash", "Latch", "BLW" gibi İngilizce kökenli terimler Türkiye arayüzünde doğrudan bırakılmamalı; **"Uyku Penceresi"**, **"Sağım"**, **"Süt Stoku"**, **"Ek Gıda"** gibi doğal Türkçe karşılıklarıyla (`docs/PLAN.md` §2.1, §4) sunulmalıdır.
  2. **Aile Paylaşımı (`Family Sharing`) ve Cihaz Gereksinimi:** Ninnly tek fiyatlı ücretli bir uygulama olduğundan (`docs/PLAN.md` §8), Apple'ın **App Store Aile Paylaşımı (Family Sharing)** özelliği açık tutulduğunda aynı iCloud Aile grubundaki eş ve büyükanne uygulamayı ikinci kez ücret ödemeden indirip `CKShare` davetiyle bebeğin kaydına katılabilir (`https://developer.apple.com/app-store/family-sharing/`).
  3. **Uygulama İndirmeyen Büyükanne İçin WhatsApp/Görsel Özeti:** Eğer büyükanne iPhone kullanmıyorsa (ör. Android kullanıyorsa) veya uygulama kullanmak istemiyorsa, ebeveynin tek dokunuşla **"Bakıcı Günlük Plan Kartı"** (son beslenme saati, sıradaki uyku saati, ısıtılacak süt miktarı) görselini oluşturup WhatsApp/Mesajlar üzerinden paylaşabilmesi Türkiye pazarı için çok yüksek değerli bir pratik çözümdür.

### 7.4. Türkiye ve ABD İçin Birim, Tarih/Saat ve Dil Tercihleri
Uygulama `Locale.current` üzerinden kullanıcının bölge (`TR` vs. `US`) ve dil ayarını okuyarak ilk açılışta doğru varsayılanları seçmeli, ancak Ayarlar'dan her birimin bağımsız değiştirilmesine (`NinnlyCore` birim dönüşümü, `docs/PLAN.md` §3) izin vermelidir:

| Ölçüm / Biçim | Türkiye (`tr_TR`) Varsayılanı | ABD (`en_US`) Varsayılanı |
| :--- | :--- | :--- |
| **Sıvı Hacmi (Biberon / Sağım)** | Mililitre (**`ml`**, ör. `90 ml`, `120 ml`) | Sıvı Ons (**`fl oz`**, `0.25` veya `0.5 oz` adımlı) + `ml` seçeneği |
| **Ağırlık (Tartı)** | Gram / Kilogram (**`g` / `kg`**, ör. `3.450 g` veya `3,45 kg`) | Pound ve Ons (**`lb` `oz`**, ör. `7 lb 8 oz`) |
| **Boy ve Baş Çevresi** | Santimetre (**`cm`**, ör. `50,5 cm`) | İnç (**`in`**, ör. `19.8 in`) |
| **Vücut Sıcaklığı (Ateş)** | Santigrat (**`°C`**, ör. `37,8 °C`) | Fahrenhayt (**`°F`**, ör. `100.0 °F`) |
| **Saat Biçimi** | **24 Saat** (`03:15`, `14:30`) | **12 Saat** (`3:15 AM`, `2:30 PM`) |
| **Ondalık Ayırıcı** | Virgül (**`,`**) | Nokta (**`.`**) |
| **Eklenen Damla/Takviye Varsayılanları** | **D Vitamini** (1. günden itibaren 400 IU / 3 damla) + **Demir Damlası** (4. aydan itibaren, T.C. Sağlık Bakanlığı "Demir Gibi Türkiye" programı: `https://hsgm.saglik.gov.tr/tr/cocuk-ve-ergen-sagligi`) | **Vitamin D Drops** (400 IU) + İsteğe bağlı takviyeler (`https://www.healthychildren.org/`) |

---

## 8. Uygulamanın İlk 60 Saniyesi: Kayıt Olmadan Başlama, En Az Bilgi ve İlk Kayıt

### 8.1. Kayıt Olmadan Başlama (Zero-Sign-Up / Local + iCloud First)
* Apple Human Interface Guidelines — Onboarding ve Sign in with Apple kuralları (`https://developer.apple.com/design/human-interface-guidelines/onboarding` ve `https://developer.apple.com/app-store/review/guidelines/#sign-in-with-apple`), bir uygulamanın temel işlevini sunmak için hesap açmayı zorunlu kılmamasını önerir: *"Give people a way to experience your app before asking them to sign up or provide personal information."* (`https://developer.apple.com/design/human-interface-guidelines/onboarding`).
* Ninnly'nin mimarisinde harici bir sunucu yoktur; veriler yerel Core Data + kullanıcının zaten telefonunda açık olan iCloud (`NSPersistentCloudKitContainer`) hesabında saklanır (`docs/PLAN.md` §3).
* **Sonuç:** Ninnly'de **"Kayıt Ol", "Giriş Yap", "E-posta Gir", "Şifre Belirle" veya "E-postanı Doğrula" ekranı KESİNLİKLE YOKTUR.** Uygulama indirildiği saniye çalışmaya hazırdır.

### 8.2. Bebek Profili İçin En Az Bilgi (Minimum Viable Profile)
Uygulamanın tüm akıllı kurallarını (`NinnlyCore`) çalıştırmak için gereken alanların analizi:
1. **Gerçekten Zorunlu Olan Tek Alan — Doğum Tarihi (`birthDate`):**
   * *Neden şart?* Uyku Penceresi (`Wake Window`) yaş tablosu (`docs/arastirma/A1_kaynak_dogrulama.md` §5), T.C. / CDC aşı ve yenidoğan tarama takvimi (`docs/arastirma/A1_kaynak_dogrulama.md` §1–2) ve DSÖ günlük persentil hesabı (`docs/arastirma/A1_kaynak_dogrulama.md` §3) bebeğin gün bazında yaşını bilmek zorundadır. Varsayılan değer **Bugün (`Date.now`)** olarak seçili gelir; doğumhanedeki ebeveyn tarih tekerleğine dokunmadan bile geçebilir.
2. **İsteğe Bağlı (Varsayılanla Geçilebilen) Alanlar:**
   * **Bebek Adı (`name`):** Zorunlu değildir! Türkiye'de ve birçok kültürde bebeğin adı doğumdan sonraki ilk birkaç gün kesinleşmemiş olabilir. Boş bırakılırsa arayüzde otomatik olarak **"Bebeğim"** (*"My Baby"*) yazar.
   * **Cinsiyet (`sex`):** İlk ekranda **sorulmaz**. Yalnızca kullanıcı ileride "Büyüme / Persentil" sekmesine girdiğinde DSÖ Kız/Erkek LMS tablosunu (`docs/arastirma/A1_kaynak_dogrulama.md` §3.1) seçmek için tek dokunuşla sorulur.
   * **Prematüre / Doğum Haftası (`isPremature` / `dueDate`):** İlk ekranda kalabalık yapmaz; yalnızca bir "Prematüre doğdu (Düzeltilmiş yaş hesapla)" küçük anahtarı olarak durur (`docs/arastirma/A1_kaynak_dogrulama.md` §2.4 ROP taraması ve düzeltilmiş uyku penceresi için).

### 8.3. İlk Kaydın En Kısa Yolu (Adım Adım İlk 60 Saniye Akışı)

```
[0. sn] Uygulama Açılışı
   └─ Mercan hilal logo 0,8 sn'de tek çizgiyle çizilir (trim animasyonu, docs/PLAN.md §3).
      Saat 20:00–06:30 arasındaysa doğrudan Gece Fazı (mavisiz/beyazsız koyu tema) açılır.

[1.–10. sn] Tek Ekranlık "Merhaba" Karşılaması (Kaydırmasız, Tek Kart)
   ├─ Bebek Adı (İsteğe bağlı, yer tutucu: "Bebeğim")
   ├─ Doğum Tarihi (Varsayılan: Bugün, tek tekerlek)
   ├─ [ Başla ] (Tam genişlikli, 64 pt yüksekliğinde ana düğme)
   └─ Alt bağlantı (küçük): "Eşimin davetiyle katılıyorum" veya "Huckleberry / Nara CSV aktar"

[11.–15. sn] Doğrudan Ana Ekran (Kutusuz Yüzen Tipografi, Alt Yarıda Başparmak Düğmeleri)
   └─ Hiçbir tanıtım turu (coach-mark balonları), bildirim izni pop-up'ı veya paywall ÇIKMAZ.

[15.–20. sn] İlk Kayıt (Tek Dokunuş)
   └─ Ebeveyn ekranın alt yarısındaki [ Sol Emzirme ] veya [ Islak Bez ] düğmesine BASAR.
      • Sayaç anında başlar, haptik geri bildirim verir ve Live Activity kilit ekranına yerleşir.
      • Bildirim izni (UNUserNotificationCenter) ilk açılışta değil, kullanıcı ilk kez bir
        hatırlatıcı (ör. Uyku Penceresi veya Süt Stoku sayacı) kurduğunda bağlamsal olarak istenir.
```
**Toplam Süre:** Uygulama ikonuna ilk dokunuştan ilk emzirme/bez kaydının başlamasına kadar geçen süre **15–20 saniyedir** (en fazla **2 dokunuş**: `[Başla]` → `[Sol Emzirme]`).

---

## 9. Ninnly İçin Çıkarımlar (Önem Sırasına Göre Somut Karar Önerileri)

Aşağıdaki kararlar, bu araştırmadaki birincil bulguların Ninnly (`iOS 18+`, `watchOS 11+`, tek fiyatlı model) mimarisine doğrudan uygulanması için **önem sırasına (P0 → P2)** göre sıralanmıştır:

### 1. [P0 — Kritik] Gece Fazında Sıfır Mavi Işık (`460–480 nm`) ve Tam Başparmak Ergonomisi
* **Ne Yapılmalı:** Gece fazında (varsayılan 20:00–06:30 veya manuel geçiş, `docs/PLAN.md` §3) arayüzdeki tüm metin ve vurgu renkleri uzun dalga boylu kehribar/mercan ve sıcak krem tonlarında tutulmalı; OLED piksellerin mavi (`B`) kanalı minimumda olmalı ve ana kayıt düğmeleri ekranın alt %50'lik alanında **en az 64–88 pt** yüksekliğinde konumlandırılmalıdır. Kilit ekranı **Live Activity (`AppIntent`)** ve **Apple Watch** üzerinden telefon kilidi açılmadan sayaç başlatılıp durdurulabilmelidir.
* **Ne Yapılmamalı:** Gece fazında saf beyaz (`#FFFFFF`), mavi/camgöbeği vurgu rengi, parlak onay animasyonları, ekranın üst köşesinde ("kırmızı bölge") birincil eylem düğmesi ve sayı girişi için tam ekran klavye **kesinlikle kullanılmamalıdır**.
* **Neden:** Brainard ve ark. (2001, `https://pubmed.ncbi.nlm.nih.gov/11517229/`) ile Chang ve ark. (2015, `https://pubmed.ncbi.nlm.nih.gov/25535358/`) çalışmalarının kanıtladığı üzere 460–480 nm mavi ışık melanopsini uyararak melatonini %55+ baskılar ve ebeveynin emzirme sonrası tekrar uykuya dalmasını geciktirir; Hoober ve Karlson & Bederson (`https://doi.org/10.1145/1240624.1240686`) çalışmaları ise kucakta bebek varken üst ekran köşelerine tek elle ulaşılamadığını göstermektedir.

### 2. [P0 — Kritik] Hesapsız, 2 Dokunuşlu İlk 60 Saniye (Zero-Sign-Up Onboarding)
* **Ne Yapılmalı:** İlk açılışta yalnızca **Doğum Tarihi** (varsayılan: Bugün) ve isteğe bağlı **Bebek Adı** (varsayılan: "Bebeğim") bulunan tek bir ekran gösterilmeli; kullanıcı `[Başla]` düğmesine bastığı anda doğrudan ana kayıt ekranına düşmelidir.
* **Ne Yapılmamalı:** E-posta/şifre kaydı, "Sign in with Apple" zorunluluğu, 10 ekranlık anket hunisi, ilk açılışta bildirim izni pop-up'ı ve balonlu tanıtım turları (*coach marks*) **konulmamalıdır**.
* **Neden:** Apple HIG Onboarding ilkeleri (`https://developer.apple.com/design/human-interface-guidelines/onboarding`) ve Kientz ve ark. (2009, `https://doi.org/10.1145/1518701.1518815`) bulguları, uykusuz ve stresli yeni ebeveynlerin yüksek sürtünmeli kurulum adımlarında uygulamayı terk ettiğini göstermektedir.

### 3. [P0 — Kritik] "Kaygısız Görünüm", Suçlamayan Dil ve Unutulan Sayaç Kurtarma
* **Ne Yapılmalı:**
  * Ayarlar'da ve Büyüme/Uyku ekranlarında **"Kaygısız Görünüm" anahtarı** (`docs/PLAN.md` §3) bulunmalı; açıldığında persentil yüzdeleri ve ortalama/hedef kıyaslamaları gizlenmelidir.
  * Emzirme veya uyku sayacı olağandışı uzun süre (ör. emzirmede >60 dk, gündüz uykusunda >4 saat) açık unutulduğunda, kullanıcıya tek dokunuşla *"Son 7 gün ortalamasına göre bitir ve kaydet"* seçeneği sunulmalıdır.
* **Ne Yapılmamalı:** Tıbbi olmayan sapmalar için kırmızı uyarı rengi kullanılmamalı; "seri bozuldu" (*streak lost*) gibi oyunlaştırma baskıları yapılmamalı ve diğer bebeklerle karşılaştırma ("Bebeğiniz yaşıtlarının %70'inden az uyuyor") **asla gösterilmemelidir**.
* **Neden:** Harries & Brown (2019, `https://pubmed.ncbi.nlm.nih.gov/31222962/`) ve Lupton & Pedersen (2016, `https://pubmed.ncbi.nlm.nih.gov/26896295/`) çalışmaları katı normların ve kıyaslamaların annelerde doğum sonrası depresyon ve kaygıyı artırdığını; Epstein ve ark. (2015, `https://doi.org/10.1145/2750858.2804250`) ise zamanlayıcı unutmanın (*lapsing*) doğal olduğunu kanıtlamıştır.

### 4. [P1 — Yüksek] Türkiye'ye Özgü Karma Beslenme, ASM/Özel Aşı Ayrımı ve Doktor PDF'i
* **Ne Yapılmalı:**
  * Beslenme ekranında **Emzirme + Tamamlayıcı Biberon (Sağılmış Süt / Mama)** kaydı birbirine kesintisiz bağlanabilmelidir.
  * Aşı modülünde **T.C. Sağlık Bakanlığı Ulusal Takvimi (6'lı Karma şeması, ASM'de ücretsiz)** ile **Özel / İsteğe Bağlı Aşılar (Rotavirüs, Meningokok)** ayrı sekmelerde/etiketlerle gösterilmelidir (`docs/arastirma/A1_kaynak_dogrulama.md` §1).
  * Tek sayfalık **Doktor PDF Raporu** (`docs/PLAN.md` §3), ASM veya çocuk doktoru kontrolünde 30 saniyede okunacak şekilde *Son 7/14 Gün Ortalama Beslenme, Günlük Islak/Kirli Bez Sayısı, Son Tartı/Boy Persentili, Uygulanan Aşılar ve Aktif İlaç/Takviyeler (D Vitamini/Demir)* özetini üretmelidir.
* **Ne Yapılmamalı:** Anne sütü dışındaki beslenme biçimleri (mama/karma) ikincil veya kusurlu gibi gösterilmemeli; Türkiye aşı takviminde 14 Nisan 2025 öncesi eski 5'li karma şeması kullanılmamalıdır (`docs/arastirma/A1_kaynak_dogrulama.md` §1.4).
* **Neden:** TNSA-2018 resmi verilerine göre (`http://www.hips.hacettepe.edu.tr/tnsa2018/rapor/TNSA2018_ana_Rapor.pdf`) Türkiye'de bebeklerin %98'i emzirilse de sadece anne sütü ortanca süresi 1,8 aydır ve karma beslenme çok yaygındır.

### 5. [P1 — Yüksek] Eş/Büyükanne Devir Teslimi, Çift Doz İlaç Koruması ve WhatsApp Özeti
* **Ne Yapılmalı:**
  * Ana ekranda son işlemin yanında **hangi bakıcının yaptığı** (`Anne`, `Baba`, `Anneanne`) ve en üstte tek satırlık **Sabitlenmiş Devir Notu** gösterilmelidir.
  * `NSPersistentCloudKitContainer` üzerinde `NSMergeByPropertyObjectTrumpMergePolicy` kullanılmalı; ilaç (`medication`) kayıtlarında yakın zamanlı mükerrer girişlere karşı **Çift Doz Koruması** (0,7 sn basılı tutarak zorla onay) çalışmalıdır (`docs/PLAN.md` §3, §4.5).
  * Uygulama kullanmayan aile büyükleri/bakıcılar için tek dokunuşla Türkçe **"Bakıcı Günlük Özeti Görseli / Metni"** (WhatsApp ile paylaşılabilir kart) üretilmelidir.
* **Ne Yapılmamalı:** Eş veya bakıcı her bez/emzirme girdiğinde diğer ebeveynin telefonuna sesli/titreşimli bildirim gönderilerek uyuyan nöbet dışı ebeveyn **uyandırılmamalıdır** (Live Activity sessizce güncellenmelidir).
* **Neden:** Gece vardiya devir tesliminde uyuyan eşin uykusunu bölmemek ve birden fazla kişinin baktığı bebeklerde yanlışlıkla çift doz ateş düşürücü/vitamin verilmesini önlemek hayati güvenlik ve konfor gereksinimidir.

### 6. [P1 — Yüksek] Doğum Sonrası Depresyon (PPD) İçin Tanı Koymayan Şefkatli Destek Rehberi
* **Ne Yapılmalı:** Uygulama içinde sunucuya hiçbir veri göndermeyen, tamamen bilgilendirici bir **"Ebeveyn Öz-Bakım ve Destek"** sayfası yer almalı; burada lohusalık duygusal değişimleri normalleştirilmeli ve Türkiye (**Aile Hekimi / SHM, ALO 183, 112**) ile ABD (**PSI 1-800-944-4773, 1-833-TLC-MAMA, 988**) resmi ücretsiz destek hatlarına tek dokunuşla arama bağlantısı verilmelidir (`https://www.postpartum.net/get-help/`, `https://www.aile.gov.tr/alo183/`).
* **Ne Yapılmamalı:** Uygulama içinde tanı koyucu depresyon testi sonucu ("Depresyondasınız") üretilmemeli ve ebeveynin ruh hali verisi üçüncü taraflarla paylaşılmamalıdır.
* **Neden:** App Store Review Guideline 1.4.1 ve 5.1.3 (`docs/arastirma/A1_kaynak_dogrulama.md` §7.1–7.2) ile ACOG/AAP klinik rehberleri, tarama ve teşhisin klinik takip gerektirdiğini, tüketici uygulamalarının ise güvenli sevk ve kriz hattı erişimi sağlaması gerektiğini vurgular.

### 7. [P2 — Orta] Yaşa Göre Evrilen Arayüz (0–18 Ay Modül Önceliklendirmesi) ve Tam Erişilebilirlik
* **Ne Yapılmalı:**
  * Bebeğin ayına göre ana ekrandaki modül sıralaması esnek olmalı (veya 6. ayda Ek Gıda modülü otomatik olarak üst sıraya önerilmeli); artık kullanılmayan modüller (ör. 6. aydan sonra günlük bez sayacı) kullanıcı tarafından gizlenebilmelidir.
  * Tüm ekranlar `DynamicTypeSize` (`AX1–AX5`), `VoiceOver` birleşik etiketleri (`accessibilityElement(children: .combine)`), Swift Charts Sesli Grafikler (`AXChartDescriptor`) ve `@Environment(\.accessibilityReduceMotion)` ile tam uyumlu kodlanmalıdır (`https://developer.apple.com/design/human-interface-guidelines/accessibility`).
* **Ne Yapılmamalı:** 10 aylık bir bebeğin ebeveynine hâlâ yenidoğan sarılık/mekonyum odaklı sabit bir arayüz dayatılmamalı; büyük yazı tipi seçildiğinde metinler `...` ile kesilmemelidir.
* **Neden:** Ebeveynlerin 3.–6. aylarda bez ve dakika bazlı emzirme takibini bırakması ("mutlu terk", Epstein ve ark. 2015, `https://doi.org/10.1145/2750858.2804250`) doğal bir gelişim aşamasıdır; uygulamanın 6–24. aylarda da kullanılmaya devam etmesi için odağın Uyku, Ek Gıda, Büyüme, Aşı ve Ateş/İlaç modüllerine kayması gerekir.
