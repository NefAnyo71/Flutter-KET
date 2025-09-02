# 🎓 EKOS - Kırıkkale Üniversitesi Ekonomi Topluluğu Mobil Uygulaması

<div align="center">
  <img src="assets/images/ekoslogo.png" alt="EKOS Logo" width="200"/>
  <br>
  <strong>Kırıkkale Üniversitesi Ekonomi Topluluğu için geliştirilmiş kapsamlı mobil uygulama</strong>
</div>

## 📱 Proje Hakkında

EKOS, Kırıkkale Üniversitesi Ekonomi Topluluğu için Flutter ile geliştirilmiş modern bir mobil uygulamadır. Uygulama, topluluk etkinlikleri, güncel ekonomi haberleri, ders notları paylaşımı ve sosyal medya entegrasyonu gibi kapsamlı özellikler sunar.

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
- **Dart** - Programlama dili
- **Material Design 3** - Modern UI/UX tasarımı

### Backend ve Veritabanı
- **Firebase Core** - Backend altyapısı
- **Cloud Firestore** - NoSQL veritabanı
- **Firebase Authentication** - Kullanıcı kimlik doğrulama
- **Firebase Messaging** - Push bildirimleri

### Önemli Paketler
- **shared_preferences** - Yerel veri depolama
- **permission_handler** - Sistem izinleri yönetimi
- **url_launcher** - Harici bağlantılar
- **image_picker** - Görsel seçimi ve yükleme
- **syncfusion_flutter_charts** - Grafik ve çizelgeler
- **workmanager** - Arka plan görevleri
- **in_app_update** - Uygulama içi güncelleme

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

## 🔧 Geliştirme Notları

### Bilinen Sorunlar
- **Paket Uyumsuzlukları**: Bazı Flutter paketleri arasında uyumsuzluk sorunları nedeniyle proje gelişimi yavaşlamıştır
- **Bağlantısız Dosyalar**: Gelecekteki güncellemeler için bazı Dart sayfalarından kullanılmayan importlar ve metodlar kaldırılmıştır. Bu dosyalar şu anda bağlantısız görünebilir ancak gelecek güncellemelerde daha iyi özellikler eklenecektir

### Gelecek Güncellemeler
- Performans optimizasyonları
- Yeni UI/UX iyileştirmeleri
- Ek topluluk özellikleri
- Daha kapsamlı ekonomi analiz araçları

## 🤝 Katkıda Bulunma

Projeye katkıda bulunmak isteyenler:
1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some AmazingFeature'`)
4. Branch'inizi push edin (`git push origin feature/AmazingFeature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT Lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

## 📞 İletişim

- **Geliştirici**: Arif Kerem
- **E-posta**: arifkerem71@gmail.com
- **Topluluk**: Kırıkkale Üniversitesi Ekonomi Topluluğu

## 🙏 Teşekkürler

- Kırıkkale Üniversitesi Ekonomi Topluluğu
- Flutter ve Firebase ekipleri
- Açık kaynak topluluk katkıcıları

---

<div align="center">
  <strong>EKOS ile ekonomi dünyasında bir adım önde olun! 📈</strong>
</div>
