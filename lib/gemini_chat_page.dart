import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';


class GeminiChatPage extends StatefulWidget {
  final String userName;
  final String userSurname;
  final String userEmail;

  const GeminiChatPage({
    Key? key,
    required this.userName,
    required this.userSurname,
    required this.userEmail,
  }) : super(key: key);

  @override
  _GeminiChatPageState createState() => _GeminiChatPageState();
}

class _GeminiChatPageState extends State<GeminiChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  final String _apiKey = 'Your Api Key';
  final FocusNode _messageFocusNode = FocusNode();
  bool _isDarkMode = false;
  
  // Ses özellikleri
  final FlutterTts _flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  final RecorderController _recorderController = RecorderController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ImagePicker _imagePicker = ImagePicker();
  
  bool _isListening = false;
  bool _isRecording = false;
  bool _isSpeaking = false;


  // Kullanıcı sınırları
  int _dailyPromptCount = 0;
  int _fiveMinutePromptCount = 0;
  DateTime? _lastPromptTime;
  DateTime? _dailyResetTime;

  // En çok sorulan sorular
  final List<String> _frequentQuestions = [
    'KET nedir?',
    'Nasıl üye olabilirim?',
    'Etkinlikler ücretsiz mi?',
    'Ders notları nasıl paylaşılır?',
    'Sosyal medya hesapları neler?',
    'İletişim bilgileri neler?',
  ];

  // KET bilgi bankası - Genişletilmiş versiyon
  final Map<String, String> _ketKnowledgeBase = {
    'topluluk': 'Kırıkkale Üniversitesi Ekonomi Topluluğu (KET), 2020 yılında kurulmuş, ekonomi ve finans alanında öğrencilere akademik, sosyal ve profesyonel gelişim imkanları sunan bir öğrenci topluluğudur. Topluluğumuz İİBF bünyesinde faaliyet göstermekte olup, 500\'ü aşkın aktif üyesi bulunmaktadır. Misyonumuz, öğrencilerin akademik bilgilerini pratikle pekiştirmelerini sağlamak ve sektör profesyonelleri ile buluşmalarını kolaylaştırmaktır.',
    'topluluk_tarihçe': 'KET, 15 Ekim 2020 tarihinde 7 kurucu üye tarafından kurulmuştur. İlk yılında 50 üyeye ulaşan topluluk, 2024 itibarıyla 500\'ü aşkın kayıtlı üyesi ile Kırıkkale Üniversitesi\'nin en aktif öğrenci topluluklarından biridir. 2022 yılında "Yılın En İnovatif Topluluğu" ödülünü kazanmıştır.',
    'topluluk_misyon': 'Ekonomi ve finans alanında teorik bilgiyi pratik uygulamalarla birleştiren, sektör deneyimi kazandıran, öğrencilerin kişisel ve profesyonel gelişimlerini destekleyen bir platform olmak. Öğrencileri akademik ve iş dünyasına hazırlamak, network olanakları sunmak ve sosyal sorumluluk projeleri ile topluma katkıda bulunmalarını sağlamak.',
    'topluluk_vizyon': 'Türkiye\'nin önde gelen üniversite ekonomi topluluklarından biri olmak, mezunlarının sektörde fark yaratmasını sağlamak ve sürdürülebilir bir topluluk yapısı oluşturmak.',
    'yönetim_ekibi': 'Topluluk başkanı: Ahmet Yılmaz, Başkan yardımcısı: Mehmet Kaya, Sekreter: Ayşe Demir, Muhasip: Ali Çelik, Sosyal Medya Sorumlusu: Zeynep Korkmaz. Yönetim ekibi her akademik yılın başında yapılan genel kurul ile seçilmektedir.',
    'topluluk_üyelik': 'Topluluğa üye olmak için uygulama içindeki "Üye Kaydı" bölümünden formu doldurmanız yeterlidir. Üyelik ücretsizdir ve tüm fakültelerden öğrenciler başvurabilir. Üye olduktan sonra topluluk etkinliklerine öncelikli katılım, sertifika programlarından indirimli yararlanma ve sektör buluşmalarına katılma hakkı kazanırsınız.',
    'topluluk_iletişim': 'Resmi e-posta: arifkerem71@gmail.com, Telefon: 0318 357 35 35 (dahili 2350). Ofis: İİBF Binası, Zemin Kat, Oda No: Z-105. Hafta içi 10:00-16:00 saatleri arasında ofisimiz açıktır.',
    'topluluk_logo': 'KET logosu, mavi ve altın sarısı renklerinden oluşur. Mavi bilgiyi ve güveni, altın sarısı ekonomiyi ve değeri temsil eder. Logoda yer alan ₺ sembolü ekonomiyi, yaprak figürü ise büyümeyi ve gelişmeyi simgeler.',

    // ETKİNLİKLER VE ORGANİZASYONLAR
    'etkinlikler': 'KET olarak her akademik dönem en az 8 büyük etkinlik düzenliyoruz. Etkinlik türleri: 1) Akademik Seminerler (haftalık), 2) Sektör Sohbetleri (aylık), 3) Workshoplar (iki haftada bir), 4) Sosyal Etkinlikler (dönem başı ve sonu), 5) Saha Gezileri (her dönem 2 defa). Tüm etkinlikler ücretsizdir ve katılım sertifikası verilir. Etkinliklere kayıt uygulama üzerinden yapılır ve kontenjanla sınırlıdır.',
    'yaklaşan_etkinlikler': 'Önümüzdeki 30 gün içindeki etkinlikler: 1) "Kripto Para ve Blokzincir" Workshopu - 15 Nisan 2024, 14:00, İİBF Amfi-3, 2) "Merkez Bankası Politikaları" Semineri - 22 Nisan 2024, 10:00, Kongre Merkezi, 3) "İş Dünyasında Kariyer" Sohbeti - 29 Nisan 2024, 15:00, KET Ofisi. Detaylar ve kayıt için uygulama içi etkinlikler bölümünü takip edin.',
    'etkinlik_kayıt': 'Etkinliklere katılmak için uygulama içindeki ilgili etkinlik sayfasına girip "Katıl" butonuna basmanız yeterlidir. Kayıt yaptırdıktan sonra etkinlik öncesi push bildirim ile hatırlatma alırsınız. Etkinlikten 24 saat öncesine kadar kayıt iptali yapabilirsiniz. Katılım kotası dolduğunda kayıtlar kapanır.',
    'etkinlik_sertifika': 'Etkinliklere en az %80 katılım gösteren üyelere dijital katılım sertifikası verilir. Sertifikalar etkinlikten 3 iş günü sonra uygulama içindeki "Sertifikalarım" bölümünden PDF olarak indirilebilir. Sertifikalarda Kırıkkale Üniversitesi logosu ve resmi onayı bulunur.',
    'geçmiş_etkinlikler': '2023-2024 Güz döneminde düzenlenen etkinlikler: 1) "Küresel Ekonomik Trendler" Konferansı (Prof. Dr. Erdal Tanas Karagöl), 2) "Fintech ve Dijital Bankacılık" Workshopu (Garanti BBVA iş birliğiyle), 3) "Borsa İstanbul" Teknik Gezisi, 4) "Kariyer Günleri" (8 farklı firmanın katılımıyla). Etkinlik fotoğraflarına sosyal medya hesaplarımızdan ulaşabilirsiniz.',
    'özel_etkinlikler': 'Her yıl düzenli olarak gerçekleştirdiğimiz özel etkinlikler: 1) Ekim ayı: Akademik Yıl Açılış Kokteyli, 2) Aralık ayı: KET Yılbaşı Buluşması, 3) Mart ayı: Kariyer Günleri, 4) Mayıs ayı: Yıl Sonu Bahar Şenliği. Bu etkinliklere ön kayıt zorunludur.',

    // DERS NOTLARI SİSTEMİ
    'ders_notları': 'Ders Notu Paylaşım Sistemi, öğrencilerin ders notlarını paylaşabildiği, indirebildiği ve değerlendirebildiği bir platformdur. Sistemde 12 farklı fakülteden 150\'den fazla derse ait not bulunmaktadır. Notlar PDF, JPG ve PNG formatlarında yüklenebilir. Yüklenen her not moderatör onayından geçer ve uygunsa yayınlanır. Not paylaşan kullanıcılar puan kazanır ve aylık en çok not paylaşan ilk 3 kullanıcı ödüllendirilir.',
    'ders_notu_yükleme': 'Ders notu yüklemek için: 1) "Ders Notlarım" bölümüne gidin, 2) "Yeni Not Ekle" butonuna basın, 3) Ders adı, fakülte, bölüm, dönem ve not türünü (vize/final/bütünleme) seçin, 4) Notunuzu galeriden veya kameradan yükleyin, 5) "Paylaş" butonuna basın. Notunuz en geç 24 saat içinde moderatör onayından geçerek yayınlanır. Yüklediğiniz her not için 10 puan kazanırsınız.',
    'ders_notu_indirme': 'Not indirmek için: 1) "Ders Notu Paylaşım Sistemi"ne gidin, 2) Arama kutusuna ders adı veya kodunu yazın, 3) Beğendiğiniz notun üzerine tıklayin, 4) "İndir" butonuna basın. Notlar cihazınızın indirilenler klasörüne PDF olarak kaydedilir. Günde en fazla 10 not indirebilirsiniz. İndirdiğiniz her not için 1 puan harcarsınız.',
    'not_değerlendirme': 'İndirdiğiniz notları 1-5 yıldız arasında değerlendirebilirsiniz. Değerlendirme kriterleri: 1) İçerik kalitesi, 2) Okunabilirlik, 3) Güncellik, 4) Kapsam. En yüksek puan alan notlar "Öne Çıkanlar" bölümünde listelenir. Not sahipleri aldıkları her yıldız için 2 puan kazanır.',
    'kullanım_kuralları': 'Ders notu paylaşım kuralları: 1) Sadece kendi hazırladığınız notları paylaşabilirsiniz, 2) Telif hakkı olan materyaller paylaşılamaz, 3) Notlar eğitim amaçlı kullanılmalıdır, 4) Ticari amaçla kullanım yasaktır, 5) Uygunsuz içerik paylaşımı hesap askıya alınması ile sonuçlanır. Tam kullanım koşulları için "Yasal Uyarılar" bölümünü okuyun.',
    'sık_sorulan_sorular': 'SSS: 1) Notum neden onaylanmadı? - Kalitesiz, okunaksız veya telif içeren notlar onaylanmaz. 2) Puanlarımı nasıl kullanırım? - Not indirmek veya özel etkinliklere katılmak için kullanabilirsiniz. 3) En çok puanı nasıl kazanırım? - Kaliteli not paylaşarak ve aktif olarak değerlendirme yaparak. 4) Puanlarım silinir mi? - Puanlar akademik yıl sonunda sıfırlanır.',

    // EKONOMİ HABERLERİ ve PİYASA TAKİBİ
    'ekonomi_haberleri': '"Güncel Ekonomi" bölümünde Anadolu Ajansı, Bloomberg HT, Reuters ve Trading Economics kaynaklı son ekonomi haberlerini bulabilirsiniz. Haberler her 30 dakikada bir güncellenir. Haberleri kategorilere göre (Merkez Bankası, Borsa, Döviz, Sektörel, Küresel) filtreleyebilir, beğenebilir, kaydedebilir ve paylaşabilirsiniz. Önemli haberler için push bildirim almak için ayarlardan bildirimleri açabilirsiniz.',
    'piyasa_verileri': '"Canlı Piyasa" bölümünde gerçek zamanlı döviz kurları (USD/TRY, EUR/TRY, GBP/TRY), emtia fiyatları (altın, gümüş, petrol, doğalgaz), kripto para fiyatları (Bitcoin, Ethereum, vs.) ve BIST100 endeksi verilerini takip edebilirsiniz. Veriler 10 saniyede bir güncellenir. Favori enstrümanlarınızı takip listesine ekleyebilir ve fiyat alarmları kurabilirsiniz.',
    'grafik_analiz': 'Her finansal enstrüman için detaylı grafiklere erişebilirsiniz. Grafik türleri: 1) Çizgi grafik, 2) Mum grafik, 3) Alan grafik. Zaman aralıkları: 1 dakika, 5 dakika, 1 saat, 1 gün, 1 hafta, 1 ay. Teknik analiz araçları da mevcuttur.',
    'portföy_takip': 'Kişisel portföyünüzü oluşturup takip edebilirsiniz. Portföy özellikleri: 1) Varlık ekleme/çıkarma, 2) Alış-satış işlemleri kaydetme, 3) Kar-zarar durumu takibi, 4) Portföy çeşitlendirme analizi, 5) Geçmiş performans grafikleri. Portföy verileri cihazınızda şifrelenmiş olarak saklanır ve bulut senkronizasyonu yapılmaz.',
    'ekonomik_takvim': 'Ekonomik takvim bölümünde önemli ekonomik verilerin açıklanma tarih ve saatlerini takip edebilirsiniz. Filtreleme özellikleri: 1) Ülkeye göre (Türkiye, ABD, AB, İngiltere, vs.), 2) Öneme göre (Düşük, Orta, Yüksek), 3) Etki alanına göre (Para politikası, Enflasyon, İstihdam, vs.). Takvim etkinliklerine hatırlatıcı ekleyebilirsiniz.',
    'haber_kaynakları': 'Haberler şu kaynaklardan sağlanmaktadır: 1) Anadolu Ajansı (Türkiye odaklı haberler), 2) Reuters (Küresel ekonomi haberleri), 3) Bloomberg HT (Piyasa ve yatırım haberleri), 4) Trading Economics (Ekonomik veri ve istatistikler). Kaynaklar güvenilir ve doğrulanmış kuruluşlardır. Her haberin altında kaynağı belirtilir.',

    // SOSYAL MEDYA ve İLETİŞİM
    'sosyal_medya': 'KET sosyal medya hesapları: Instagram: @kku_ekonomi_toplulugu (4.5K takipçi), Twitter: @KET_KKU (2.3K takipçi), LinkedIn: Kırıkkale Üniversitesi Ekonomi Topluluğu (1.8K bağlantı), YouTube: KET TV (1.2K abone). Sosyal medya hesaplarımızda güncel etkinlik duyuruları, ekonomi haberleri, eğitim içerikleri ve topluluk fotoğrafları paylaşılmaktadır. Hesapları takip etmek için uygulama içindeki ilgili bölümleri kullanabilirsiniz.',
    'iletişim': 'Topluluk ile iletişim kanalları: 1) E-posta: arifkerem71@gmail.com (resmi işler), ket.iletisim@kku.edu.tr (genel iletişim), 2) Telefon: 0318 357 35 35 (dahili 2350), 3) Ofis: İİBF Binası, Zemin Kat, Oda No: Z-105, 4) Sosyal medya DM\'leri. E-posta için yanıt süresi 2 iş günüdür. Acil durumlar için topluluk başkanının kişisel iletişim bilgileri yönetim kadrosu ile paylaşılır.',
    'geri_bildirim': 'Uygulama ve topluluk hakkında geri bildirimlerinizi "Geri Bildirim" bölümünden iletebilirsiniz. Geri bildirim türleri: 1) Hata bildirimi, 2) Özellik önerisi, 3) Şikayet, 4) Genel görüş. Geri bildirimler anonim olarak gönderilebilir ve iletişim bilgilerinizi ekleyebilirsiniz. Geri bildirimler haftalık olarak değerlendirilir ve gerekli durumlarda sizinle iletişime geçilir.',
    'üye_şikayet': 'Herhangi bir üye veya yönetici hakkında şikayette bulunmak için "Geri Bildirim" bölümünü kullanabilirsiniz. Şikayetler gizlilik içinde değerlendirilir ve gerekli işlemler yapılır. Şikayet değerlendirme süreci en fazla 5 iş günü sürer. Sonuç hakkında bilgi verilmez ancak gerekli önlemler alınır.',

    // ÜYELİK ve HESAP YÖNETİMİ
    'üyelik_koşulları': 'KET üyelik koşulları: 1) Kırıkkale Üniversitesi\'nde aktif öğrenci olmak, 2) Üyelik formunu eksiksiz doldurmak, 3) Topluluk tüzüğünü kabul etmek, 4) Aidat ödememek (üyelik ücretsizdir). Üyelik başvuruları 3 iş günü içinde değerlendirilir ve e-posta ile sonuç bildirilir. Reddedilen başvuruların gerekçesi açıklanmaz.',
    'hesap_ayarları': 'Hesap ayarlarında yapabilecekleriniz: 1) Profil bilgilerini güncelleme, 2) Şifre değiştirme, 3) Bildirim tercihlerini yönetme, 4) Gizlilik ayarları, 5) Hesabı silme. Profil bilgileriniz sadece topluluk yöneticileri tarafından görülebilir ve üçüncü taraflarla paylaşılmaz. Hesap silme işlemi geri alınamaz ve tüm verileriniz kalıcı olarak silinir.',
    'bildirim_ayarları': 'Bildirim tercihleri: 1) Etkinlik hatırlatmaları (1 gün önce, 1 saat önce), 2) Yeni etkinlik duyuruları, 3) Önemli haber bildirimleri, 4) Sistem güncellemeleri, 5) Topluluk duyuruları. Bildirimleri gruplar halinde açıp kapatabilirsiniz. Bildirimler sessiz saatlerde (varsayılan: 23:00-08:00) gönderilmez.',
    'gizlilik_ayarları': 'Gizlilik seçenekleri: 1) Profil görünürlüğü (sadece yöneticiler/herkes), 2) Etkinlik katılım bilgisi paylaşımı, 3) Veri toplama izinleri, 4) Reklam kişiselleştirme. Gizlilik politikamız GDPR ve KVKK uyumludur. Verileriniz sadece uygulamanın işleyişi için kullanılır ve üçüncü taraflarla paylaşılmaz.',
    'hesap_silme': 'Hesabınızı silmek için: 1) Hesap ayarlarına gidin, 2) "Hesabımı Sil" seçeneğine tıklayın, 3) Silme nedenini belirtin, 4) Onaylayın. Hesap silindikten sonra: 1) Tüm kişisel verileriniz silinir, 2) Paylaştığınız ders notları kaldırılmaz (anonim olarak kalır), 3) Katıldığınız etkinlik kayıtları silinir, 4) Geri bildirimler anonim olarak kalır. Hesap silme işlemi geri alınamaz.',

    // YÖNETİCİ PANELİ ve İDARİ İŞLEMLER
    'yönetici_paneli': 'Yönetici paneli sadece yetkilendirilmiş topluluk yöneticileri tarafından kullanılabilir. Panel özellikleri: 1) Etkinlik yönetimi (ekleme/düzenleme/silme), 2) Üye yönetimi (listeleme/engelleme/silme), 3) Ders notu moderasyonu, 4) Haber yönetimi, 5) İstatistik ve raporlama, 6) Anket yönetimi. Yönetici girişi için kullanıcı adı: kkuekonomi71, şifre yöneticilerle paylaşılmaktadır.',
    'etkinlik_yönetimi': 'Yöneticiler etkinlik eklerken: 1) Etkinlik adı, tarih, saat, yer, 2) Katılım kontenjanı, 3) Etkinlik açıklaması ve kuralları, 4) Konuşmacı bilgileri, 5) Görsel ekleme. Etkinlikler onaylandıktan sonra otomatik olarak duyurulur ve kayıtlar açılır. Etkinlik iptali durumunda kayıtlı tüm katılımcılara bildirim gönderilir.',
    'üye_yönetimi': 'Üye yönetimi özellikleri: 1) Üye listesi ve detayları görüntüleme, 2) Üye arama ve filtreleme, 3) Üye engelleme/hesap askıya alma, 4) Üye istatistikleri (katılım oranı, not paylaşımı, vs.), 5) Toplu e-posta gönderme. Üye engelleme nedenleri: 1) Uygunsuz davranış, 2) Spam paylaşım, 3) Topluluk kurallarını ihlal. Engellenen üyelere e-posta ile bildirim yapılır.',
    'raporlama': 'Yönetici raporları: 1) Aylık etkinlik katılım raporu, 2) Üye istatistikleri (fakülte/bölüm dağılımı), 3) Ders notu paylaşım istatistikleri, 4) Uygulama kullanım istatistikleri, 5) Geri bildirim analizleri. Raporlar PDF veya Excel formatında indirilebilir. Raporlar aylık olarak topluluk danışman hocası ile paylaşılır.',
    'moderasyon': 'Moderasyon görevleri: 1) Ders notu onay/red işlemleri, 2) Geri bildirimleri okuma ve yanıtlama, 3) Uygunsuz içerikleri kaldırma, 4) Şikayetleri inceleme. Moderasyon ekibi 5 kişiden oluşur ve haftalık nöbet sistemi ile çalışır. Moderasyon kararlarına itiraz "Geri Bildirim" bölümünden yapılabilir.',

    // SPONSORLUK ve İŞ BİRLİKLERİ
    'sponsorlar': 'KET 2023-2024 dönemi sponsorları: 1) Ana Sponsor: X Bankası, 2) Altın Sponsor: Y Finans Şirketi, 3) Gümüş Sponsor: Z Yatırım Firması, 4) Medya Sponsoru: AA Ekonomi. Sponsorlarımız etkinliklerimize maddi destek sağlamakta ve kariyer günlerinde staj/imkan sunmaktadır. Sponsorluk paketleri ve ayrıcalıkları için "Sponsorluk" bölümünden detaylı bilgi alabilirsiniz.',
    'sponsorluk_paketleri': 'Sponsorluk paketleri: 1) Ana Sponsorluk (20.000 TL): Tüm etkinliklerde ana sponsor olma, logo her yerde ön planda, özel etkinlik düzenleme hakkı, 2) Altın Sponsorluk (10.000 TL): 4 büyük etkinlikte sponsorluk, stand açma hakkı, 3) Gümüş Sponsorluk (5.000 TL): 2 etkinlikte sponsorluk, web sitesi ve sosyal medyada logo, 4) Medya Sponsoru (3.000 TL): Haber ve duyurularda logo, sosyal medya tagleme.',
    'iş_birliği': 'KET ile iş birliği imkanları: 1) Etkinlik sponsorluğu, 2) Staj ve iş imkanı sunma, 3) Eğitim içeriği sağlama, 4) Teknik gezi düzenleme, 5) Öğrenci projelerine mentorluk. İş birliği için iletişim: ket.sponsorluk@kku.edu.tr. İş birliği teklifleri 10 iş günü içinde değerlendirilir ve geri dönüş yapılır.',
    'sponsorluk_başvuru': 'Sponsor olmak için: 1) "Sponsorlar" bölümüne gidin, 2) "Sponsorluk Başvurusu" butonuna tıklayın, 3) Formu doldurun (firma bilgileri, iletişim, teklif edilen paket, beklentiler), 4) Başvurunuzu gönderin. Başvurular 5 iş günü içinde değerlendirilir ve sizinle iletişime geçilir. Başvuru sonucu e-posta ile bildirilir.',

    // ANKET ve OYLAMA SİSTEMİ
    'anket_sistemi': 'KET anket sistemi topluluk üyelerinin görüşlerini almak için kullanılır. Anket türleri: 1) Çoktan seçmeli anketler, 2) Açık uçlu anketler, 3) Derecelendirme anketleri, 4) Memnuniyet anketleri. Anketler ortalama 5-10 dakika sürer. Anketlere katılım zorunlu değildir ancak katılım oranı yüksek üyelere ödül verilir.',
    'anket_kuralları': 'Anket katılım kuralları: 1) Her anket sadece bir kez doldurulabilir, 2) Anketler anonim olarak doldurulur, 3) Anket sonuçları toplu halde paylaşılır (bireysel yanıtlar paylaşılmaz), 4) Anket süresi dolduktan sonra katılım yapılamaz, 5) Uygunsuz yanıtlar moderatörler tarafından silinebilir. Anket sonuçları topluluk kararlarını şekillendirmek için kullanılır.',
    'aktif_anketler': 'Şu an aktif anketler: 1) "2024 Bahar Dönemi Etkinlik Tercihleri" Anketi (Süre: 15 gün kaldı, Katılım: 234 üye), 2) "Uygulama Memnuniyet" Anketi (Süre: 7 gün kaldı, Katılım: 187 üye), 3) "Kariyer Beklentileri" Anketi (Süre: 3 gün kaldı, Katılım: 156 üye). Anketlere katılmak için "Anketler" bölümünü ziyaret edin.',
    'anket_sonuçları': 'Tamamlanan anket sonuçları: 1) "2023 Güz Dönemi Değerlendirme" Anketi (Katılım: 345 üye, Memnuniyet: %87), 2) "Yeni Yıl Etkinliği Tercihi" Anketi (Katılım: 278 üye, Kazanan: Karaoke Gecesi), 3) "Uygulama Özellik Önceliklendirme" Anketi (Katılım: 312 üye, Öncelik: Portföy Takibi). Anket sonuçları topluluk Instagram hesabında paylaşılmaktadır.',

    // UYGULAMA TEKNİK DETAYLAR
    'uygulama': 'EKOS uygulaması Flutter 3.6.1 ile geliştirilmiş, Firebase backend altyapısını kullanan bir mobil uygulamadır. Sürüm: 6.0.0, Build: 106. Minimum Android sürümü: API 34 (Android 13), Tavsiye edilen sürüm: API 36 (Android 16). Uygulama boyutu: 28.5 MB (APK), 36.2 MB (App Bundle). Desteklenen diller: Türkçe, İngilizce (kısmi).',
    'teknoloji': 'Kullanılan teknolojiler: 1) Frontend: Flutter/Dart, 2) Backend: Firebase (Auth, Firestore, Storage, Messaging), 3) State Management: Provider, 4) Local Storage: Shared Preferences, 5) HTTP Client: Dio, 6) Image Picker: image_picker, 7) Charts: Syncfusion Flutter Charts, 8) Notifications: flutter_local_notifications. Kaynak kodu private repository\'de saklanmaktadır.',
    'güncellemeler': 'Son güncellemeler: 1) v6.0.0: Yeni arayüz, performans iyileştirmeleri, hata düzeltmeleri, 2) v5.2.1: Ders notu favorileme özelliği, indirme kısıtlamaları, 3) v5.1.0: Portföy takip özelliği, ekonomik takvim, 4) v5.0.0: Firebase entegrasyonu, yeni backend altyapısı. Bir sonraki güncelleme: v6.1.0 (tahmini çıkış: Mayıs 2024).',
    'desteklenen_cihazlar': 'Desteklenen cihazlar: 1) Android: 13 ve üzeri (API 34+), 2) iOS: 15.0 ve üzeri (kısmi destek). Önerilen cihaz özellikleri: 1) RAM: 4GB+, 2) Depolama: 64GB+, 3) İşlemci: Snapdragon 662/Mediatek Helio G85 ve üzeri. Düşük performanslı cihazlarda bazı özellikler (grafikler, gerçek zamanlı veriler) kısıtlanabilir.',
    'gizlilik_politikası': 'Gizlilik politikası özeti: 1) Kişisel veriler sadece uygulamanın çalışması için kullanılır, 2) Veriler üçüncü taraflarla paylaşılmaz, 3) Veriler şifrelenmiş olarak saklanır, 4) Kullanıcılar verilerini silebilir, 5) 18 yaş altı kullanıcılar için ebeveyn onayı gerekir. Tam gizlilik politikası: https://ket.kku.edu.tr/gizlilik (şu anda aktif değil).',
    'kullanım_koşulları': 'Kullanım koşulları özeti: 1) Uygulama sadece eğitim amaçlı kullanılabilir, 2) Telif hakkı ihlali yasaktır, 3) Spam ve uygunsuz içerik paylaşılamaz, 4) Hesap paylaşımı yasaktır, 5) Yönetici kararlarına itiraz hakkı saklıdır. İhlal durumunda hesap askıya alınır. Tam kullanım koşulları: https://ket.kku.edu.tr/kullanim-kosullari (şu anda aktif değil).',

    // SORUN GİDERME ve DESTEK
    'sorun_giderme': 'Genel sorun giderme adımları: 1) İnternet bağlantınızı kontrol edin (Wi-Fi/mobil data), 2) Uygulamayı kapatıp yeniden açın, 3) Cihazınızı yeniden başlatın, 4) Uygulama önbelleğini temizleyin (Ayarlar > Uygulamalar > EKOS > Depolama > Önbelleği temizle), 5) Uygulamayı güncelleyin (Play Store > EKOS > Güncelle). Sorun devam ederse destek ile iletişime geçin.',
    'internet_sorunları': 'İnternet bağlantısı sorunları: 1) Wi-Fi bağlantınızı kontrol edin, 2) Mobil verinizin açık olduğundan emin olun, 3) Uçak modunu kapatın, 4) VPN kullanıyorsanız kapatmayı deneyin, 5) Aşırı veri kullanımı durumunda operatör kısıtlaması olabilir. Uygulama çevrimdışı modda sınırlı özelliklerle çalışabilir (ders notları, kayıtlı haberler).',
    'giriş_sorunları': 'Giriş sorunları: 1) E-posta ve şifrenizi kontrol edin, 2) "Şifremi unuttum" ile şifre sıfırlayın, 3) Hesabınızın engellenmemiş olduğundan emin olun, 4) İnternet bağlantınızı kontrol edin, 5) Uygulama ve işletim sisteminizin güncel olduğundan emin olun. 5 denemeden sonra hesap 30 dakika için kilitlenir.',
    'bildirim_sorunları': 'Bildirim alamama sorunları: 1) Telefon ayarlarından bildirim izinlerini kontrol edin, 2) Uygulama içi bildirim ayarlarını kontrol edin, 3) Sessiz saatler ayarını kontrol edin, 4) Bataryadan tasarruf modunu kapatın, 5) Bildirimlerin sessize alınmadığından emin olun. Test bildirimi göndermek için: Ayarlar > Bildirimler > Test Bildirimi Gönder.',
    'yavaşlama_sorunları': 'Uygulama yavaşlığı sorunları: 1) Cihaz depolama alanınızı kontrol edin (%85\'ten fazla doluysa performans düşer), 2) Arka planda çalışan uygulamaları kapatın, 3) Uygulama önbelleğini temizleyin, 4) Grafik yoğun sayfalarda (Canlı Piyasa) düşük detay modunu deneyin, 5) Cihazınızı yeniden başlatın. Düşük performanslı cihazlar için "Enerji tasarrufu modu" mevcuttur.',
    'çökme_sorunları': 'Uygulama çökmeleri: 1) Uygulamayı güncelleyin, 2) Cihaz işletim sistemini güncelleyin, 3) Uygulama verilerini temizleyin (şifreleriniz kaybolur, yeniden giriş yapmanız gerekir), 4) Uygulamayı kaldırıp yeniden yükleyin. Çökme raporları otomatik olarak geliştiricilere gönderilir. Belirli bir sayfada sürekli çökme oluyorsa lütfen destek ile iletişime geçin.',
    'destek_iletişim': 'Teknik destek için: 1) E-posta: arifkerem71@gmail.com, 2) Geri bildirim bölümünden "Hata Bildirimi" seçeneği, 3) Instagram DM: @kku_ekonomi_toplulugu. Destek talebinde bulunurken: 1) Cihaz modeli ve işletim sistemi sürümü, 2) Uygulama sürüm numarası, 3) Hatayı aldığınız sayfa ve işlem, 4) Hata mesajı (varsa), 5) Ekran görüntüsü/videosu ekleyin. Yanıt süresi: 2-3 iş günü.',

    // SIKÇA SORULAN SORULAR
    'üyelik_ücreti': 'Hayır, KET üyeliği tamamen ücretsizdir. Topluluk etkinliklerine katılım da ücretsizdir. Sadece bazı özel etkinliklerde (konferans, teknik gezi) katılımcı sayısı sınırlı olabilir veya sembolik bir katılım ücreti istenebilir. Bu durumda önceden duyuru yapılır ve katılım isteğe bağlıdır.',
    'mezun_üyelik': 'Evet, Kırıkkale Üniversitesi mezunları KET mezun üyesi olabilir. Mezun üyelik için: 1) Mezuniyet belgesi, 2) Kimlik bilgileri, 3) Güncel iletişim bilgileri gereklidir. Mezun üyeler etkinliklerine katılabilir, network olanaklarından yararlanabilir ve mentorluk programlarına katılabilir. Mezun üyelik de ücretsizdir.',
    'staj_imkanı': 'KET, sponsor firmalar aracılığıyla üyelerine staj imkanları sunar. Staj ilanları uygulama içindeki "Kariyer Fırsatları" bölümünden duyurulur. Staj başvuruları doğrudan firmalara yapılır. Topluluk sadece aracılık yapar, staj sürecini yönetmez. Staj başvurusu için CV ve transkript gereklidir.',
    'sertifika_geçerlilik': 'KET etkinlik katılım sertifikaları Kırıkkale Üniversitesi onaylıdır ve CV\'nize ekleyebilirsiniz. Sertifikalarda etkinlik adı, tarihi, süresi ve Kırıkkale Üniversitesi logosu bulunur. Sertifikaların resmi geçerliliği (AKTS/ECTS kredisi) yoktur, katılım belgesi niteliğindedir.',
    'uygulama_güvenliği': 'EKOS uygulaması güvenlik önlemleri: 1) Veri iletimi SSL şifreleme ile yapılır, 2) Kullanıcı şifreleri hash\'lenerek saklanır, 3) Firebase güvenlik kuralları ile yetkisiz erişim engellenir, 4) Düzenli güvenlik denetimleri yapılır, 5) Veri yedeklemesi otomatik olarak yapılır. Uygulama Google Play Protect tarafından onaylıdır.',
    'veri_saklama': 'Kullanıcı verileri: 1) Profil bilgileri: Hesap aktif olduğu sürece saklanır, 2) Etkinlik kayıtları: Etkinlikten 1 yıl sonra silinir, 3) Ders notları: Hesap silinse bile anonim olarak saklanır, 4) Geri bildirimler: 2 yıl saklanır, 5) Kullanım istatistikleri: Anonim olarak 5 yıl saklanır. Veri silme talepleri için arifkerem71@gmail.com ile iletişime geçin.',
    'rekabet_ve_ödüller': 'KET içi rekabet ve ödüller: 1) Aylık en çok not paylaşan ilk 3 üye ödüllendirilir, 2) En çok etkinliğe katılan üyelere yıl sonunda plaket verilir, 3) Anketlere en çok katılan üyelere sürpriz hediyeler verilir, 4) Topluluğa katkı sağlayan üyelere "Yılın En Aktif Üyesi" ödülü verilir. Ödüller sponsor firmalar tarafından karşılanır.',
    'topluluk_değişim': 'KET, diğer üniversitelerin ekonomi toplulukları ile iş birliği yapar ve öğrenci değişim programları düzenler. Değişim programları için: 1) En az 2 dönem KET üyesi olmak, 2) Etkinliklere düzenli katılım göstermek, 3) Akademik ortalamanın 2.50 ve üzeri olması gerekir. Değişim programları dönem başlarında duyurulur ve mülakat ile seçilir.',
  };

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
    _loadUserLimits();
    _loadThemePreference();
    _initializeTts();
    _initializeSpeech();
    if (_messages.isEmpty) {
      _addMessage('KET', 'Merhaba ${widget.userName} ${widget.userSurname}! 👋 Ben KET, Kırıkkale Üniversitesi Ekonomi Topluluğu asistanınızım. Sana nasıl yardımcı olabilirim?', isWelcome: true);
    }

    // Odak noktasını ayarla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_messageFocusNode);
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _recorderController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _addMessage(String sender, String message, {bool isWelcome = false, String? imagePath, String? audioPath}) {
    setState(() {
      _messages.add({
        'sender': sender,
        'message': message,
        'time': DateTime.now().toIso8601String(),
        'isWelcome': isWelcome,
        'imagePath': imagePath,
        'audioPath': audioPath,
      });
    });
    _saveChatHistory();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    // Sınır kontrolleri
    if (!_checkUserLimits()) return;

    final userMessage = _messageController.text.trim();
    _addMessage('Sen', userMessage);
    _messageController.clear();

    // Prompt sayısını artır
    _incrementPromptCount();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _callGeminiAPI(userMessage);
      _addMessage('KET', response);
    } catch (e) {
      _addMessage('KET', 'Üzgünüm, bir hata oluştu. Lütfen daha sonra tekrar deneyin. Eğer sorun devam ederse arifkerem71@gmail.com adresine bildirimde bulunabilirsiniz.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  String _getRelevantInfo(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    String relevantInfo = '';

    _ketKnowledgeBase.forEach((key, value) {
      if (lowerMessage.contains(key) ||
          lowerMessage.contains(key.replaceAll('_', ' ')) ||
          (key == 'etkinlikler' && (lowerMessage.contains('etkinlik') || lowerMessage.contains('program'))) ||
          (key == 'ders_notları' && (lowerMessage.contains('not') || lowerMessage.contains('ders'))) ||
          (key == 'ekonomi_haberleri' && (lowerMessage.contains('haber') || lowerMessage.contains('ekonomi'))) ||
          (key == 'üyelik' && (lowerMessage.contains('üye') || lowerMessage.contains('kayıt'))) ||
          (key == 'iletişim' && (lowerMessage.contains('iletişim') || lowerMessage.contains('ulaş'))) ||
          (key == 'sorun_giderme' && (lowerMessage.contains('sorun') || lowerMessage.contains('hata') || lowerMessage.contains('çalışmıyor'))) ||
          (key == 'hesap_sorunları' && (lowerMessage.contains('giriş') || lowerMessage.contains('şifre') || lowerMessage.contains('hesap'))) ||
          (key == 'bildirim_sorunları' && (lowerMessage.contains('bildirim') || lowerMessage.contains('uyarı'))) ||
          (key == 'dosya_sorunları' && (lowerMessage.contains('dosya') || lowerMessage.contains('yükle') || lowerMessage.contains('indirme')))) {
        relevantInfo += '$value ';
      }
    });

    return relevantInfo.isNotEmpty ? relevantInfo : _ketKnowledgeBase['topluluk']!;
  }

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final chatKey = 'chat_history_${widget.userName}_${widget.userSurname}';
    final chatData = prefs.getString(chatKey);
    if (chatData != null) {
      final List<dynamic> decoded = jsonDecode(chatData);
      setState(() {
        _messages.clear();
        _messages.addAll(decoded.map((e) => Map<String, dynamic>.from(e)).toList());
      });
    }
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final chatKey = 'chat_history_${widget.userName}_${widget.userSurname}';
    await prefs.setString(chatKey, jsonEncode(_messages));
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('chat_dark_mode') ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('chat_dark_mode', _isDarkMode);
  }

  void _deleteMessage(int index) {
    setState(() {
      _messages.removeAt(index);
    });
    _saveChatHistory();
  }

  void _copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Mesaj kopyalandı'),
        backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Ses özellikleri başlatma
  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage('tr-TR');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _initializeSpeech() async {
    await _speechToText.initialize();
  }

  // Metni sesli okuma
  Future<void> _speakText(String text) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() => _isSpeaking = false);
    } else {
      setState(() => _isSpeaking = true);
      await _flutterTts.speak(text);
      _flutterTts.setCompletionHandler(() {
        setState(() => _isSpeaking = false);
      });
    }
  }

  // Sesli mesaj kaydetme
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _recorderController.stop();
      setState(() {
        _isRecording = false;
      });
      if (path != null) {
        _addMessage('Sen', 'Sesli mesaj gönderildi', audioPath: path);
        // Sesli mesaj için limit kontrolü ve sayaç artırma
        if (_checkUserLimits()) {
          _incrementPromptCount();
          _addMessage('KET', 'Sesli mesajınızı aldım. Size nasıl yardımcı olabilirim?');
        }
      }
    } else {
      if (await _recorderController.checkPermission()) {
        await _recorderController.record(path: '/storage/emulated/0/Download/voice_message_${DateTime.now().millisecondsSinceEpoch}.m4a');
        setState(() => _isRecording = true);
      }
    }
  }

  // Sesli mesaj çalma
  Future<void> _playAudio(String path) async {
    await _audioPlayer.play(DeviceFileSource(path));
  }

  // Sesle soru sorma
  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
    } else {
      if (await _speechToText.initialize()) {
        setState(() => _isListening = true);
        await _speechToText.listen(
          onResult: (result) {
            setState(() {
              _messageController.text = result.recognizedWords;
            });
            if (result.finalResult) {
              setState(() => _isListening = false);
              _sendMessage();
            }
          },
          localeId: 'tr_TR',
        );
      }
    }
  }

  // Fotoğraf gönderme
  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _addMessage('Sen', 'Fotoğraf gönderildi', imagePath: image.path);
      _sendImageToGemini(image.path);
    }
  }

  Future<void> _sendImageToGemini(String imagePath) async {
    // Sınır kontrolleri
    if (!_checkUserLimits()) return;
    
    // Prompt sayısını artır
    _incrementPromptCount();
    
    setState(() => _isLoading = true);
    try {
      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);
      
      final response = await _callGeminiVisionAPI(base64Image);
      _addMessage('KET', response);
    } catch (e) {
      _addMessage('KET', 'Görsel analiz edilemedi. Lütfen tekrar deneyin.');
    }
    setState(() => _isLoading = false);
  }

  Future<String> _callGeminiVisionAPI(String base64Image) async {
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$_apiKey');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [{
          'parts': [
            {'text': 'Bu görseli analiz et ve KET (Kırıkkale Üniversitesi Ekonomi Topluluğu) bağlamında açıkla. Eğer ekonomi, finans veya eğitimle ilgiliyse detaylı bilgi ver.'},
            {'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image}}
          ]
        }]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['content']['parts'][0]['text'];
      }
    }
    throw Exception('Görsel analiz hatası');
  }

  String _formatTime(String timeString) {
    final dateTime = DateTime.parse(timeString);
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }

  void _showFrequentQuestions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'En Çok Sorulan Sorular',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ..._frequentQuestions.map((question) => ListTile(
              leading: Icon(Icons.help_outline, 
                color: _isDarkMode ? Colors.white70 : Colors.deepPurple),
              title: Text(question,
                style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);
                _messageController.text = question;
                _sendMessage();
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  Future<void> _loadUserLimits() async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = '${widget.userName}_${widget.userSurname}';
    _dailyPromptCount = prefs.getInt('daily_prompts_$userKey') ?? 0;
    _fiveMinutePromptCount = prefs.getInt('five_min_prompts_$userKey') ?? 0;

    final dailyResetStr = prefs.getString('daily_reset_$userKey');
    final lastPromptStr = prefs.getString('last_prompt_$userKey');

    if (dailyResetStr != null) {
      _dailyResetTime = DateTime.parse(dailyResetStr);
      if (DateTime.now().difference(_dailyResetTime!).inDays >= 1) {
        _dailyPromptCount = 0;
        _dailyResetTime = DateTime.now();
      }
    } else {
      _dailyResetTime = DateTime.now();
    }

    if (lastPromptStr != null) {
      _lastPromptTime = DateTime.parse(lastPromptStr);
      if (DateTime.now().difference(_lastPromptTime!).inMinutes >= 5) {
        _fiveMinutePromptCount = 0;
      }
    }
  }

  bool _checkUserLimits() {
    final now = DateTime.now();

    // Günlük sınır kontrolü
    if (_dailyPromptCount >= 10) {
      _addMessage('KET', 'Günlük mesaj sınırınıza ulaştınız (10 mesaj). Yarın tekrar deneyebilirsiniz. Eğer acil bir ihtiyacınız varsa arifkerem71@gmail.com adresine e-posta gönderebilirsiniz.');
      return false;
    }

    // 5 dakikalık sınır kontrolü
    if (_lastPromptTime != null && now.difference(_lastPromptTime!).inMinutes < 5) {
      if (_fiveMinutePromptCount >= 10) {
        final remainingTime = 5 - now.difference(_lastPromptTime!).inMinutes;
        _addMessage('KET', '5 dakika içinde 10 mesaj sınırınıza ulaştınız. $remainingTime dakika sonra tekrar deneyebilirsiniz.');
        return false;
      }
    } else {
      _fiveMinutePromptCount = 0;
    }

    return true;
  }

  Future<void> _incrementPromptCount() async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = '${widget.userName}_${widget.userSurname}';
    final now = DateTime.now();

    _dailyPromptCount++;
    _fiveMinutePromptCount++;
    _lastPromptTime = now;

    await prefs.setInt('daily_prompts_$userKey', _dailyPromptCount);
    await prefs.setInt('five_min_prompts_$userKey', _fiveMinutePromptCount);
    await prefs.setString('daily_reset_$userKey', _dailyResetTime!.toIso8601String());
    await prefs.setString('last_prompt_$userKey', now.toIso8601String());
  }

  Future<String> _callGeminiAPI(String userMessage) async {
    final relevantInfo = _getRelevantInfo(userMessage);
    final prompt = '''Sen KET (Kırıkkale Üniversitesi Ekonomi Topluluğu) asistanısın. Kullanıcılara yardımcı ol.

İlgili bilgiler: $relevantInfo

Kullanıcı sorusu: ÖNEMLİ: Sadece yukarıdaki bilgiler çerçevesinde cevap ver. Bu bilgilerin dışına çıkma. Kullanıcı bir topluluk üyesi olduğunu varsay ve uygulamayı yönetme yetkisi olmadığını hatırlat. $userMessage

Yukarıdaki bilgileri kullanarak Türkçe, samimi ve yardımsever bir şekilde cevap ver. Kendini KET asistanı olarak tanıt. Eğer sorun çözemezsen veya teknik bir problem varsa kullanıcıyı arifkerem71@gmail.com adresine yönlendir. Cevabını markdown formatında hazırla, başlıklar için #, listeler için - kullan.''';

    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$_apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Üzgünüm, yanıt oluşturamadım. Lütfen daha sonra tekrar deneyin.';
      }
    } else {
      throw Exception('API hatası: ${response.statusCode} - ${response.body}');
    }
  }

  void _clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final chatKey = 'chat_history_${widget.userName}_${widget.userSurname}';
    await prefs.remove(chatKey);

    setState(() {
      _messages.clear();
    });

    _addMessage('KET', 'Sohbet geçmişi temizlendi. Merhaba ${widget.userName}! 👋 Size nasıl yardımcı olabilirim?', isWelcome: true);
  }

  void _showLimitInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.info_outline, color: Colors.deepPurple.shade600),
            ),
            const SizedBox(width: 12),
            const Text('Kullanım Sınırları', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Günlük mesaj:', style: TextStyle(fontWeight: FontWeight.w500)),
                      Text('$_dailyPromptCount/10', 
                        style: TextStyle(color: Colors.deepPurple.shade600, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _dailyPromptCount / 10,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple.shade600),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('5 dakikadaki:', style: TextStyle(fontWeight: FontWeight.w500)),
                      Text('$_fiveMinutePromptCount/10', 
                        style: TextStyle(color: Colors.deepPurple.shade600, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _fiveMinutePromptCount / 10,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Bu sınırlar, sistem kaynaklarının adil kullanımı için konulmuştur.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                image: DecorationImage(
                  image: AssetImage('assets/images/ketyapayzeka.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('KET Asistan', 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis),
                  Text('Online', 
                    style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.more_vert, color: Colors.white, size: 20),
            ),
            color: _isDarkMode ? Colors.grey[800] : Colors.white,
            onSelected: (value) {
              switch (value) {
                case 'theme':
                  _toggleTheme();
                  break;
                case 'faq':
                  _showFrequentQuestions();
                  break;
                case 'limits':
                  _showLimitInfo();
                  break;
                case 'clear':
                  _clearChatHistory();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode, 
                      color: _isDarkMode ? Colors.white : Colors.black),
                    const SizedBox(width: 12),
                    Text('Tema değiştir', 
                      style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'faq',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, 
                      color: _isDarkMode ? Colors.white : Colors.black),
                    const SizedBox(width: 12),
                    Text('Sık sorulan sorular', 
                      style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'limits',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, 
                      color: _isDarkMode ? Colors.white : Colors.black),
                    const SizedBox(width: 12),
                    Text('Kullanım sınırları', 
                      style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    const Text('Sohbeti temizle', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'Sen';
                final isWelcome = message['isWelcome'] == true;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.deepPurple.shade200, width: 2),
                            image: DecorationImage(
                              image: AssetImage('assets/images/ketyapayzeka.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Flexible(
                        child: GestureDetector(
                          onLongPress: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.copy, color: _isDarkMode ? Colors.white : Colors.black),
                                      title: Text('Kopyala', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _copyMessage(message['message']!);
                                      },
                                    ),
                                    if (!isUser && !isWelcome)
                                      ListTile(
                                        leading: Icon(Icons.volume_up, color: _isDarkMode ? Colors.white : Colors.black),
                                        title: Text('Sesli Oku', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _speakText(message['message']!);
                                        },
                                      ),
                                    if (!isWelcome)
                                      ListTile(
                                        leading: Icon(Icons.delete, color: Colors.red),
                                        title: Text('Sil', style: TextStyle(color: Colors.red)),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _deleteMessage(index);
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: isUser
                                  ? LinearGradient(
                                      colors: [Colors.deepPurple.shade600, Colors.deepPurple.shade500],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : isWelcome
                                      ? LinearGradient(
                                          colors: _isDarkMode 
                                            ? [Colors.deepPurple.shade800, Colors.deepPurple.shade700]
                                            : [Colors.deepPurple.shade50, Colors.deepPurple.shade100],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                              color: isUser || isWelcome ? null : (_isDarkMode ? Colors.grey[800] : Colors.white),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: Radius.circular(isUser ? 20 : 6),
                                bottomRight: Radius.circular(isUser ? 6 : 20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(_isDarkMode ? 0.3 : 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: isUser || isWelcome ? null : Border.all(
                                color: _isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (message['imagePath'] != null)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(message['imagePath']!),
                                        width: 200,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                if (message['audioPath'] != null)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.play_arrow, 
                                            color: isUser ? Colors.white : Colors.deepPurple),
                                          onPressed: () => _playAudio(message['audioPath']!),
                                        ),
                                        Text('Sesli mesaj', 
                                          style: TextStyle(
                                            color: isUser ? Colors.white70 : Colors.grey.shade600,
                                            fontSize: 14,
                                          )),
                                      ],
                                    ),
                                  ),
                                Text(
                                  message['message']!,
                                  style: TextStyle(
                                    color: isUser
                                        ? Colors.white
                                        : isWelcome
                                            ? (_isDarkMode ? Colors.white : Colors.deepPurple.shade800)
                                            : (_isDarkMode ? Colors.white : Colors.black87),
                                    fontSize: 15,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTime(message['time']!),
                                  style: TextStyle(
                                    color: isUser 
                                        ? Colors.white70 
                                        : (_isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 12),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.deepPurple.shade600, Colors.deepPurple.shade500],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.person, color: Colors.white, size: 18),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.deepPurple.shade200, width: 2),
                      image: DecorationImage(
                        image: AssetImage('assets/images/ketyapayzeka.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple.shade600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('KET düşünüyor...', 
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isDarkMode ? Colors.grey[900] : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isDarkMode ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  if (_isRecording || _isListening)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.mic, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(_isRecording ? 'Kaydediliyor...' : 'Dinleniyor...', 
                            style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isListening ? Icons.mic 
                          : _isRecording ? Icons.stop 
                          : Icons.mic_none, 
                          color: (_isListening || _isRecording) ? Colors.red : Colors.grey
                        ),
                        onPressed: _isListening ? _toggleListening : _toggleRecording,
                        onLongPress: _isRecording ? null : _toggleListening,
                        tooltip: _isListening ? 'Dinlemeyi durdur' 
                               : _isRecording ? 'Kaydı durdur' 
                               : 'Kısa bas: Sesli mesaj, Uzun bas: Sesle sor',
                      ),
                      IconButton(
                        icon: Icon(Icons.photo, color: Colors.grey),
                        onPressed: _pickImage,
                        tooltip: 'Fotoğraf gönder',
                      ),
                      IconButton(
                        icon: Icon(_isSpeaking ? Icons.volume_off : Icons.volume_up, 
                          color: _isSpeaking ? Colors.red : Colors.grey),
                        onPressed: () {
                          if (_messages.isNotEmpty) {
                            final lastKetMessage = _messages.reversed.firstWhere(
                              (msg) => msg['sender'] == 'KET' && msg['isWelcome'] != true,
                              orElse: () => {},
                            );
                            if (lastKetMessage.isNotEmpty) {
                              _speakText(lastKetMessage['message']!);
                            }
                          }
                        },
                        tooltip: _isSpeaking ? 'Okumayı durdur' : 'Son mesajı oku',
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isDarkMode ? Colors.grey[800] : const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: _isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: _messageController,
                            focusNode: _messageFocusNode,
                            decoration: InputDecoration(
                              hintText: 'KET\'e bir şey sor...',
                              hintStyle: TextStyle(color: _isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              suffixIcon: Container(
                                margin: const EdgeInsets.all(4),
                                child: CircleAvatar(
                                  backgroundColor: Colors.deepPurple.shade600,
                                  child: IconButton(
                                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                                    onPressed: _sendMessage,
                                  ),
                                ),
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                            maxLines: null,
                            style: TextStyle(fontSize: 15, color: _isDarkMode ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}