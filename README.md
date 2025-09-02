# 🎓 EKOS - Kırıkkale Üniversitesi Ekonomi Topluluğu Mobil Uygulaması

<div align="center">
  <img src="assets/images/ekoslogo.png" alt="EKOS Logo" width="200"/>
  <br>
  <strong>Kırıkkale Üniversitesi Ekonomi Topluluğu için geliştirilmiş kapsamlı mobil uygulama</strong>
</div>

## 📱 Proje Hakkında

EKOS, Kırıkkale Üniversitesi Ekonomi Topluluğu için Flutter ile geliştirilmiş modern bir mobil uygulamadır. Uygulama, topluluk etkinlikleri, güncel ekonomi haberleri, ders notları paylaşımı ve sosyal medya entegrasyonu gibi kapsamlı özellikler sunar.

**Sürüm**: 6.0.0  
**Geliştirici**: Arif Kerem  
**Platform**: Android (iOS desteği mevcut)  
**Dil**: Dart/Flutter  
**Veritabanı**: Firebase Firestore

## ✨ Özellikler

### 📚 Eğitim ve Akademik
- **Ders Notu Paylaşım Sistemi**: Üyeler arası ders notu paylaşımı
- **Ders Notlarım**: Kişisel ders notları yönetimi
- **Etkinlik Takvimi**: Akademik ve sosyal etkinlik takibi
- **Yaklaşan Etkinlikler**: Gelecek etkinlikler için bildirimler

### 📰 Haber ve İletişim
- **Topluluk Haberleri**: Güncel topluluk duyuruları
- **Sosyal Medya Entegrasyonu**: Topluluk sosyal medya hesaplarına erişim
- **Geri Bildirim Sistemi**: Uygulama ve topluluk hakkında görüş bildirme
- **Anket Sistemi**: Üye görüşlerini toplama

### 💰 Ekonomi ve Finans
- **Güncel Ekonomi**: Son ekonomik gelişmeler
- **Canlı Piyasa**: Gerçek zamanlı finansal veriler
- **Ekonomik Analizler**: Uzman görüşleri ve analizler

### 👥 Topluluk Yönetimi
- **Üye Kayıt Sistemi**: Yeni üye başvuruları
- **Üye Profilleri**: Topluluk üyesi bilgileri
- **Yönetici Paneli**: Topluluk yöneticileri için özel panel
- **Sponsorlar**: Topluluk sponsorları ve iş birlikleri

### 🔔 Bildirim ve Güvenlik
- **Push Bildirimleri**: Önemli duyurular için anlık bildirimler
- **Hesap Güvenliği**: Güvenli giriş ve hesap yönetimi
- **Çevrimdışı Mod**: İnternet bağlantısı olmadan bazı özellikler
- **Otomatik Güncelleme**: Uygulama güncellemelerini kontrol etme

## 🛠️ Teknolojiler

### Frontend
- **Flutter 3.6.1+** - Cross-platform mobil uygulama geliştirme
- **Dart 3.6.1+** - Programlama dili
- **Material Design 3** - Modern UI/UX tasarımı

### Backend ve Veritabanı
- **Firebase Core** - Backend altyapısı
- **Cloud Firestore** - NoSQL veritabanı
- **Firebase Authentication** - Kullanıcı kimlik doğrulama
- **Firebase Messaging** - Push bildirimleri
- **Firebase Database** - Gerçek zamanlı veritabanı

### Önemli Paketler
- **shared_preferences** - Yerel veri depolama
- **permission_handler** - Sistem izinleri yönetimi
- **url_launcher** - Harici bağlantılar
- **image_picker** - Görsel seçimi ve yükleme
- **syncfusion_flutter_charts** - Grafik ve çizelgeler
- **workmanager** - Arka plan görevleri
- **in_app_update** - Uygulama içi güncelleme
- **flutter_local_notifications** - Yerel bildirimler
- **http** - HTTP istekleri
- **intl** - Uluslararasılaştırma ve tarih formatları
- **share_plus** - İçerik paylaşımı

## 📂 Proje Yapısı ve Dart Dosyalarının İşlevleri

### 🏠 Ana Dosyalar

#### `main.dart` - Uygulama Giriş Noktası
- **İşlev**: Uygulamanın ana giriş noktası ve başlatma işlemleri
- **Özellikler**:
  - Firebase başlatma ve yapılandırma
  - Kullanıcı kimlik doğrulama sistemi
  - Splash screen ve loading ekranları
  - Uygulama güncelleme kontrolü
  - Push bildirim yapılandırması
  - Workmanager ile arka plan görevleri
  - Ana sayfa grid menü sistemi
  - Hesap engelleme kontrolü

#### `firebase_service.dart` - Firebase İşlemleri
- **İşlev**: Firebase Firestore veritabanı işlemleri
- **Özellikler**:
  - Geri bildirim ekleme/çekme
  - Turnuva başvuru yönetimi
  - Veritabanı CRUD işlemleri
  - Hata yönetimi

### 🎯 Özellik Modülleri

#### `admin_panel_page.dart` - Yönetici Paneli
- **İşlev**: Yönetici girişi ve yönetim araçları
- **Özellikler**:
  - Güvenli yönetici girişi (kullanıcı adı: kkuekonomi71)
  - Etkinlik yönetimi
  - Topluluk haberleri yönetimi
  - Oylama sistemi yönetimi
  - Öğrenci veritabanı
  - Karaliste yönetimi
  - Yapay zeka puanlama sistemi
  - Ders notu yönetimi

#### `current_economy.dart` - Güncel Ekonomi Haberleri
- **İşlev**: Anadolu Ajansı RSS beslemesinden ekonomi haberlerini çekme
- **Özellikler**:
  - RSS feed okuma ve parsing
  - Haber filtreleme sistemi
  - Karanlık/aydınlık mod
  - Haber raporlama sistemi
  - Paylaşım özelliği
  - Yasal uyarı sistemi
  - Otomatik haber güncelleme

#### `live_market.dart` - Canlı Piyasa Takibi
- **İşlev**: Kripto para ve hisse senedi fiyatlarını gerçek zamanlı takip
- **Özellikler**:
  - CoinGecko API entegrasyonu
  - Türk hisse senetleri simülasyonu
  - Favori ekleme sistemi
  - Fiyat grafikleri (Syncfusion Charts)
  - Karşılaştırma özelliği
  - Arama ve filtreleme
  - Mum grafikleri (Candlestick)

#### `ders_notlari1.dart` - Ders Notu Paylaşım Sistemi
- **İşlev**: Öğrenciler arası ders notu paylaşımı
- **Özellikler**:
  - Fakülte/bölüm/ders filtreleme
  - PDF dosya paylaşımı
  - Beğeni/beğenmeme sistemi
  - Favori ekleme
  - İndirme sayacı
  - Yasal uyarı ve kullanım koşulları
  - Anonim kullanıcı sistemi

#### `etkinlik_takvimi2.dart` - Etkinlik Takvimi
- **İşlev**: Topluluk etkinliklerini listeleme
- **Özellikler**:
  - Firebase Firestore entegrasyonu
  - Tarih sıralama
  - Görsel destekli etkinlik kartları
  - Gradient arka plan tasarımı
  - Responsive tasarım

#### `yaklasan_etkinlikler.dart` - Yaklaşan Etkinlikler
- **İşlev**: Gelecekteki etkinlikleri gösterme ve alarm kurma
- **Özellikler**:
  - Kalan süre hesaplama
  - Alarm kurma sistemi (Samsung ve diğer markalar için)
  - Intent sistemi ile saat uygulaması entegrasyonu
  - Gerçek zamanlı güncelleme

#### `social_media_page.dart` - Sosyal Medya
- **İşlev**: Topluluk sosyal medya hesaplarına yönlendirme
- **Özellikler**:
  - Instagram ve Twitter entegrasyonu
  - URL launcher ile harici bağlantılar
  - Responsive kart tasarımı

#### `feedback.dart` - Geri Bildirim Sistemi
- **İşlev**: Kullanıcı geri bildirimlerini toplama
- **Özellikler**:
  - Anonim geri bildirim
  - Firebase Firestore kayıt
  - E-posta adresi (isteğe bağlı)
  - Form validasyonu

#### `poll.dart` - Anket Sistemi
- **İşlev**: Topluluk anketleri oluşturma ve yönetme
- **Özellikler**:
  - Çoktan seçmeli sorular
  - Açık uçlu sorular
  - Firebase Firestore kayıt
  - Anonim anket sistemi

#### `sponsors_page.dart` - Sponsorlar
- **İşlev**: Sponsorluk bilgileri ve iletişim
- **Özellikler**:
  - E-posta entegrasyonu
  - Sponsorluk başvuru sistemi
  - İletişim formu

#### `account_settings_page.dart` - Hesap Ayarları
- **İşlev**: Kullanıcı hesap yönetimi
- **Özellikler**:
  - Şifre değiştirme
  - Hesap silme/devre dışı bırakma
  - Bildirim ayarları (sessiz saatler)
  - Çıkış yapma
  - Kullanıcı profil bilgileri

### 🔧 Servis Dosyaları

#### `notification_service.dart` - Bildirim Servisi
- **İşlev**: Push bildirim yönetimi ve etkinlik hatırlatmaları
- **Özellikler**:
  - Flutter Local Notifications
  - Etkinlik bazlı otomatik bildirimler
  - 7 gün, 1 gün, 1 saat öncesi hatırlatmalar
  - Bildirim geçmişi yönetimi
  - Debug ve test fonksiyonları

#### `services/local_storage_service.dart` - Yerel Depolama
- **İşlev**: SharedPreferences ile yerel veri yönetimi
- **Özellikler**:
  - Kullanıcı oturum bilgileri
  - Uygulama ayarları
  - Önbellek yönetimi

### 🔐 Yönetici Modülleri

#### `admin_yaklasan_etkinlikler.dart` - Etkinlik Yönetimi
- **İşlev**: Yöneticiler için etkinlik ekleme/düzenleme

#### `admin_survey_page.dart` - Anket Yönetimi
- **İşlev**: Anket sonuçlarını görüntüleme ve yönetme

#### `cleaner_admin_page.dart` - Temizlik Yönetimi
- **İşlev**: Veritabanı temizleme ve bakım işlemleri

#### `Topluluk_Haberleri_Yönetici.dart` - Haber Yönetimi
- **İşlev**: Topluluk haberlerini ekleme/düzenleme

#### `BlackList.dart` - Karaliste Yönetimi
- **İşlev**: Kullanıcı engelleme sistemi

#### `puanlama_sayfasi.dart` - Yapay Zeka Puanlama
- **İşlev**: Öğrenci performans değerlendirme sistemi

### 📊 Veri Modelleri ve Yardımcı Dosyalar

#### `uyekayıt.dart` / `uye_kayit.dart` - Üye Kayıt
- **İşlev**: Yeni üye kayıt işlemleri

#### `member_profiles_account.dart` - Üye Profilleri
- **İşlev**: Üye profil bilgileri yönetimi

#### `website_applications_page.dart` - Web Başvuruları
- **İşlev**: İnternet sitesi başvurularını yönetme

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK 3.6.1 veya üzeri
- Dart SDK 3.6.1 veya üzeri
- Android Studio / VS Code
- Java 17 (Android geliştirme için)
- Gradle 8.12

### Adım Adım Kurulum

1. **Flutter'ı yükleyin**:
   ```bash
   # Flutter'ın yüklü olduğunu kontrol edin
   flutter doctor
   ```

2. **Projeyi klonlayın**:
   ```bash
   git clone [repository-url]
   cd ket
   ```

3. **Bağımlılıkları yükleyin**:
   ```bash
   flutter pub get
   ```

4. **Firebase yapılandırması**:
   - `android/app/google-services.json` dosyasını ekleyin
   - Firebase Console'da projenizi yapılandırın

5. **Uygulamayı çalıştırın**:
   ```bash
   flutter run
   ```

## 📋 Yapılandırma

### Firebase Kurulumu
1. Firebase Console'da yeni proje oluşturun
2. Android uygulaması ekleyin (com.example.ekos)
3. `google-services.json` dosyasını `android/app/` klasörüne ekleyin
4. Authentication, Firestore ve Messaging servislerini etkinleştirin

### Android İmzalama
- `android/key.properties` dosyasını yapılandırın
- Keystore dosyanızı güvenli bir yerde saklayın

## 📱 APK İndirme

**Güncel Sürüm**: v6.0.0

[📥 APK İndir (Dropbox)](https://www.dropbox.com/scl/fi/35pt025320e19sggttkz9/app-release.apk?rlkey=8x358q021noqsqerxpwyc88gv&st=ks9ypcxw&dl=0)

*Not: APK dosyası VirusTotal tarafından taranmış ve güvenli olduğu doğrulanmıştır.*

## 🏗️ Kod Yapısı ve Organizasyon

### Klasör Yapısı
```
lib/
├── main.dart                    # Ana uygulama giriş noktası
├── services/                    # Servis katmanı
│   ├── firebase_service.dart    # Firebase işlemleri
│   ├── notification_service.dart # Bildirim servisleri
│   └── local_storage_service.dart # Yerel depolama
├── pages/                       # Sayfa bileşenleri
│   ├── admin/                   # Yönetici sayfaları
│   ├── user/                    # Kullanıcı sayfaları
│   └── shared/                  # Ortak sayfalar
└── utils/                       # Yardımcı fonksiyonlar
```

### Veri Akışı
1. **Kullanıcı Girişi**: SharedPreferences + Firebase Auth
2. **Veri Çekme**: Firebase Firestore + HTTP API
3. **Yerel Depolama**: SharedPreferences + Cache
4. **Bildirimler**: Firebase Messaging + Local Notifications
5. **Dosya İşlemleri**: Firebase Storage + Local Storage

### API Entegrasyonları
- **Anadolu Ajansı RSS**: Ekonomi haberleri
- **CoinGecko API**: Kripto para verileri
- **Firebase APIs**: Tüm backend işlemleri
- **Google Services**: Kimlik doğrulama

## 🔧 Geliştirme Notları

### Mimari Yapı
- **MVC Pattern**: Model-View-Controller mimarisi
- **State Management**: StatefulWidget ve setState kullanımı
- **Firebase Integration**: Tam Firebase ekosistemi entegrasyonu
- **Responsive Design**: Farklı ekran boyutları için uyumlu tasarım

### Güvenlik Özellikleri
- Yönetici paneli için güvenli giriş sistemi
- Kullanıcı hesap engelleme mekanizması
- Yasal uyarı ve kullanım koşulları
- Anonim geri bildirim sistemi
- Veri şifreleme ve güvenli depolama

### Performans Optimizasyonları
- Lazy loading ile sayfa yükleme
- Image caching ve optimizasyon
- Efficient Firebase queries
- Background task management
- Memory leak prevention

### Bilinen Sorunlar
- **Paket Uyumsuzlukları**: Bazı Flutter paketleri arasında uyumsuzluk sorunları
- **Bağlantısız Dosyalar**: Gelecekteki güncellemeler için hazırlanan ancak henüz aktif olmayan modüller
- **Bağlantısız Dosyalar**: Tasarımsal olarak her telefonda orantılı değil malesef şu anlık için main.dart kodunda orantıladım tasarımları yakında düzelteceğim.


### Gelecek Güncellemeler
- iOS platform desteği genişletme
- Performans optimizasyonları
- Yeni UI/UX iyileştirmeleri
- Ek topluluk özellikleri
- Daha kapsamlı ekonomi analiz araçları
- Offline mode desteği

## 🤝 Katkıda Bulunma

Projeye katkıda bulunmak isteyenler:
1. Fork yapın
2. Feature branch oluşturun 
3. Değişikliklerinizi commit edin 
4. Branch'inizi push edin 
5. Pull Request oluşturun

### Geliştirme Kuralları
- Dart/Flutter best practices'i takip edin
- Kod yorumlarını Türkçe yazın
- Commit mesajlarını açıklayıcı yapın
- Test yazımına önem verin
- UI/UX tutarlılığını koruyun

## 📊 Teknik Detaylar

### Veritabanı Şeması
```
Firestore Collections:
├── üyelercollection/           # Kullanıcı hesapları
├── ders_notlari/              # Ders notları
├── etkinlikler/               # Etkinlik takvimi
├── yaklasan_etkinlikler/      # Yaklaşan etkinlikler
├── toplulukhaberleri2/        # Topluluk haberleri
├── surveys/                   # Anket verileri
├── feedback/                  # Geri bildirimler
├── haber_raporlari/          # Haber raporları
└── users/                     # Kullanıcı tercihleri
```

### Kullanılan Paketler ve Sürümleri
```yaml
dependencies:
  flutter: sdk
  firebase_core: latest
  cloud_firestore: latest
  firebase_auth: latest
  firebase_messaging: latest
  shared_preferences: latest
  http: latest
  url_launcher: latest
  image_picker: latest
  syncfusion_flutter_charts: ^26.1.35
  workmanager: latest
  flutter_local_notifications: latest
  in_app_update: ^4.2.3
  permission_handler: latest
  intl: latest
  share_plus: latest
```

### Performans Metrikleri
- **Uygulama Boyutu**: ~50MB (APK)
- **Başlatma Süresi**: <3 saniye
- **Firebase Latency**: <500ms
- **Memory Usage**: <100MB
- **Battery Optimization**: Background tasks optimized

## 🔒 Güvenlik ve Gizlilik

### Veri Koruma
- Kullanıcı şifreleri hash'lenerek saklanır
- Kişisel veriler şifrelenir
- GDPR uyumlu veri işleme
- Anonim geri bildirim sistemi

### İzinler
- **İnternet**: API çağrıları için
- **Depolama**: Dosya indirme için
- **Bildirim**: Push notification için
- **Kamera**: Profil fotoğrafı için (opsiyonel)

## 📄 Lisans

Bu proje MIT Lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

## 📞 İletişim

- **Geliştirici**: Arif Kerem
- **E-posta**: arifkerem71@gmail.com
- **Topluluk**: Kırıkkale Üniversitesi Ekonomi Topluluğu
- **Instagram**: [@kkuekonomi](https://www.instagram.com/kkuekonomi/)
- **Twitter**: [@kkuekonomi1](https://x.com/kkuekonomi1)

## 🙏 Teşekkürler

- Kırıkkale Üniversitesi Ekonomi Topluluğu
- Flutter ve Firebase ekipleri
- Açık kaynak topluluk katkıcıları
- Anadolu Ajansı (RSS feed için)
- CoinGecko (Kripto para verileri için)
- Syncfusion (Chart kütüphanesi için)

## 📈 İstatistikler

- **Toplam Kod Satırı**: ~21.000+ satır
- **Dart Dosya Sayısı**: 30+ dosya
- **Özellik Sayısı**: 25+ ana özellik
- **Desteklenen Dil**: Türkçe
- **Platform**: Android 
- **Platform**: Bazı dart dosyalarını push'lamadım.

---

<div align="center">
  <strong>EKOS ile ekonomi dünyasında bir adım önde olun! 📈</strong>
  <br><br>
  <img src="https://img.shields.io/badge/Flutter-3.6.1+-blue?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.6.1+-blue?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Firebase-Latest-orange?logo=firebase" alt="Firebase">
  <img src="https://img.shields.io/badge/Version-6.0.0-green" alt="Version">
</div>
