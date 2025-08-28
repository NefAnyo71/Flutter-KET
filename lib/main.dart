import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'feedback.dart';
import 'current_economy.dart';
import 'live_market.dart';
import 'poll.dart';
import 'sponsors_page.dart';
import 'admin_panel_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'social_media_page.dart';
import 'etkinlik_takvimi2.dart';
import 'community_news2_page.dart';
import 'uyekayıt.dart';
import 'DersNotlarımPage.dart';
import 'ders_notlari1.dart';
import 'yaklasan_etkinlikler.dart';
import 'notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_update/in_app_update.dart';

// Bildirimler için bir instance oluşturun
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Firestore instance
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Arka plan görevi için top-level fonksiyon
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    if (taskName == "eventNotificationTask") {
      // Arka plan görevini burada çalıştırıyoruz
      NotificationService.checkForEventsAndSendNotification();
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Önce splash screen göster
  runApp(const SplashScreenApp());

  // Sonra arka planda başlatma işlemlerini yap
  _initializeApp().then((_) async {
    // Uygulama güncelleme kontrolü
    await _checkForAppUpdate();
    runApp(const MyApp());
  }).catchError((error) {
    print('Uygulama başlatma hatası: $error');
    runApp(const ErrorApp());
  });
}

// Uygulama güncelleme kontrolü
Future<void> _checkForAppUpdate() async {
  try {
    final info = await InAppUpdate.checkForUpdate();

    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      // Güncelleme mevcut, esnek güncelleme başlat
      await InAppUpdate.startFlexibleUpdate();
      // Güncelleme tamamlandığında uygulamayı yeniden başlat
      await InAppUpdate.completeFlexibleUpdate();
    }
  } catch (e) {
    print('Güncelleme kontrolü sırasında hata: $e');
  }
}

Future<void> _initializeApp() async {
  // Firebase başlatma
  await Firebase.initializeApp();

  // Temel başlatma işlemleri
  await initializeDateFormatting('tr_TR', null);

  // İzinleri iste (async olarak devam etsin)
  _requestPermissions();

  // Token alma (async olarak devam etsin)
  _getFCMToken();

  // Sistem UI modunu ayarla
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

Future<void> _requestPermissions() async {
  try {
    // Bildirim izni
    PermissionStatus notificationStatus =
    await Permission.notification.request();
    if (notificationStatus.isGranted) {
      print("Bildirim izni verildi!");
    }

    // Depolama izni
    PermissionStatus storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted) {
      print("Depolama izni verildi!");
    }
  } catch (e) {
    print('İzin hatası: $e');
  }
}

Future<void> _getFCMToken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    print("Firebase Token: $token");
  } catch (e) {
    print('FCM Token alma hatası: $e');
  }
}

// Kullanıcıyı Firestore'a kaydetme fonksiyonu
Future<void> _saveUserToFirestore(
    String email, String password, String name, String surname) async {
  try {
    await _firestore.collection('üyelercollection').doc(email).set({
      'email': email,
      'password': password,
      'name': name,
      'surname': surname,
      'hesapEngellendi': 0, // Varsayılan olarak 0 (engellenmemiş)
      'createdAt': FieldValue.serverTimestamp(),
    });
    print('Kullanıcı Firestore\'a kaydedildi: $email');
  } catch (e) {
    print('Firestore kayıt hatası: $e');
  }
}

// Firestore'dan kullanıcı doğrulama ve hesap durumu kontrolü
Future<Map<String, dynamic>> _validateUserFromFirestore(
    String email, String password) async {
  try {
    final doc =
    await _firestore.collection('üyelercollection').doc(email).get();
    if (doc.exists) {
      final userData = doc.data() as Map<String, dynamic>;

      // Hesap engellenmiş mi kontrol et
      final hesapEngellendi = userData['hesapEngellendi'] ?? 0;

      return {
        'isValid': userData['password'] == password,
        'hesapEngellendi': hesapEngellendi,
        'userData': userData
      };
    }
    return {'isValid': false, 'hesapEngellendi': 0};
  } catch (e) {
    print('Firestore doğrulama hatası: $e');
    return {'isValid': false, 'hesapEngellendi': 0};
  }
}

// Kullanıcı şifresini güncelleme
Future<void> _updateUserPassword(String email, String newPassword) async {
  try {
    await _firestore.collection('üyelercollection').doc(email).update({
      'password': newPassword,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    print('Şifre güncellendi: $email');
  } catch (e) {
    print('Şifre güncelleme hatası: $e');
  }
}

// Hesap silme fonksiyonu
Future<void> _deleteAccount(String email) async {
  try {
    // Firestore'dan kullanıcıyı sil
    await _firestore.collection('üyelercollection').doc(email).delete();
    print('Hesap silindi: $email');
  } catch (e) {
    print('Hesap silme hatası: $e');
  }
}

// Hesap devre dışı bırakma fonksiyonu
Future<void> _deactivateAccount(String email) async {
  try {
    // Hesabı devre dışı bırak (hesapEngellendi = 1 yaparak)
    await _firestore.collection('üyelercollection').doc(email).update({
      'hesapEngellendi': 1,
      'deactivatedAt': FieldValue.serverTimestamp(),
    });
    print('Hesap devre dışı bırakıldı: $email');
  } catch (e) {
    print('Hesap devre dışı bırakma hatası: $e');
  }
}

// Splash Screen Widget
class SplashScreenApp extends StatelessWidget {
  const SplashScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ekoslogo.png',
                height: 100.0,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 20),
              const Text('KET Yükleniyor...',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

// Hata durumu için Widget
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 20),
              const Text('Uygulama başlatılamadı',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Uygulamayı yeniden başlatmayı dene
                  main();
                },
                child: const Text('Yeniden Dene'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hesap Engellendi Sayfası
class AccountBlockedScreen extends StatelessWidget {
  const AccountBlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.block,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              const Text(
                'Hesabınız Engellendi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Yönetici tarafından engellendiniz.\n\n'
                    'Olası bir sorunda lütfen aşağıdaki e-posta adresi ile iletişime geçiniz:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'arifkerem71@gmail.com',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Çıkış yap ve login sayfasına dön
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const SimpleLoginPage(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Çıkış Yap',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Basit Giriş Sayfası
class SimpleLoginPage extends StatefulWidget {
  const SimpleLoginPage({super.key});

  @override
  _SimpleLoginPageState createState() => _SimpleLoginPageState();
}

class _SimpleLoginPageState extends State<SimpleLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('KET Giriş', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade300, Colors.cyan.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Image.asset(
                  'assets/images/ekoslogo.png',
                  height: 100.0,
                ),
                const SizedBox(height: 20),
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Ad',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Adınızı girin';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _surnameController,
                    decoration: const InputDecoration(
                      labelText: 'Soyad',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Soyadınızı girin';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                ],
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@'))
                      return 'Geçerli e-posta girin';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 4)
                      return 'En az 4 karakter girin';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _isLogin ? _login : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    _isLogin ? 'Giriş Yap' : 'Kayıt Ol',
                    style: const TextStyle(
                        fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin
                        ? 'Hesabınız yok mu? Kayıt olun'
                        : 'Zaten hesabınız var mı? Giriş yapın',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text;
      final password = _passwordController.text;

      // Önce Firestore'dan kontrol et
      final validationResult =
      await _validateUserFromFirestore(email, password);

      if (validationResult['isValid'] == true) {
        // Hesap engellenmiş mi kontrol et
        final hesapEngellendi = validationResult['hesapEngellendi'] ?? 0;

        if (hesapEngellendi == 1) {
          // Hesap engellenmiş, engelli ekranına yönlendir
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const AccountBlockedScreen(),
          ));
          return;
        }

        // Firestore'da doğrulandı, yerel storage'a da kaydet
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);

        // Kullanıcı bilgilerini al ve kaydet
        final userData = validationResult['userData'] as Map<String, dynamic>;
        await prefs.setString('name', userData['name'] ?? '');
        await prefs.setString('surname', userData['surname'] ?? '');

        // Giriş başarılı, üye kayıt sayfasına yönlendir
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => UyeKayit(),
        ));
      } else {
        // Firestore'da bulunamadı, eski yöntemle dene
        final prefs = await SharedPreferences.getInstance();
        final storedEmail = prefs.getString('email');
        final storedPassword = prefs.getString('password');

        if (email == storedEmail && password == storedPassword) {
          // Giriş başarılı, üye kayıt sayfasına yönlendir
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => UyeKayit(),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('E-posta veya şifre hatalı')),
          );
        }
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text;
      final password = _passwordController.text;
      final name = _nameController.text;
      final surname = _surnameController.text;

      try {
        // Firestore'a kaydet
        await _saveUserToFirestore(email, password, name, surname);

        // Yerel storage'a da kaydet
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setString('name', name);
        await prefs.setString('surname', surname);
        await prefs.setBool('hasSeenUyeKayit', true);

        // Kayıt başarılı, üye kayıt sayfasına yönlendir
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => UyeKayit(),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt hatası: $e')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userSurname = '';
  bool _hasSeenUyeKayit = false;

  // Giriş durumunu kontrol et
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final name = prefs.getString('name') ?? '';
    final surname = prefs.getString('surname') ?? '';
    final hasSeenUyeKayit = prefs.getBool('hasSeenUyeKayit') ?? false;

    setState(() {
      _isLoggedIn = email != null;
      _userName = name;
      _userSurname = surname;
      _hasSeenUyeKayit = hasSeenUyeKayit;
    });

    // Eğer giriş yapmış ama üye kayıt sayfasını görmemişse
    if (_isLoggedIn && !_hasSeenUyeKayit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => UyeKayit(),
        ));
      });
    }
  }

  // Bildirim ve workmanager başlatma işlemleri
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _initializeNotifications();
    _initializeWorkmanager();
  }

  Future<void> _initializeNotifications() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
      final InitializationSettings initializationSettings =
      InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received message: ${message.notification?.title}');
      });
    } catch (e) {
      print('Bildirim başlatma hatası: $e');
    }
  }

  void _initializeWorkmanager() {
    try {
      Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: true,
      );

      Workmanager().registerPeriodicTask(
        "eventNotificationTask",
        "eventNotificationCheck",
        frequency: const Duration(minutes: 15),
        initialDelay: const Duration(seconds: 10),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );

      print("✅ Workmanager başlatıldı ve görev kaydedildi");

      Future.delayed(const Duration(seconds: 5), () {
        NotificationService.checkForEventsAndSendNotification();
      });
    } catch (e) {
      print('❌ Workmanager başlatma hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EKOS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: _isLoggedIn ? const MyHomePage() : const SimpleLoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _userName = '';
  String _userSurname = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? '';
      _userSurname = prefs.getString('surname') ?? '';
      _userEmail = prefs.getString('email') ?? '';
    });
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Şifre Değiştir'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Yeni Şifre',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty || value.length < 4)
                    return 'En az 4 karakter girin';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Yeni Şifre Tekrar',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value != newPasswordController.text)
                    return 'Şifreler eşleşmiyor';
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (newPasswordController.text.length >= 4 &&
                    newPasswordController.text ==
                        confirmPasswordController.text) {
                  // Şifreyi güncelle
                  await _updateUserPassword(
                      _userEmail, newPasswordController.text);

                  // Yerel storage'ı da güncelle
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('password', newPasswordController.text);

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Şifre başarıyla güncellendi')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Lütfen geçerli bir şifre girin')),
                  );
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAccountMenu(BuildContext context) async {
    final result = await showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        const PopupMenuItem<String>(
          value: 'profile',
          child: Text('Profil Bilgileri'),
        ),
        const PopupMenuItem<String>(
          value: 'password',
          child: Text('Şifre Değiştir'),
        ),
        const PopupMenuItem<String>(
          value: 'switch',
          child: Text('Hesap Değiştir'),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text('Çıkış Yap'),
        ),
        const PopupMenuItem<String>(
          value: 'delete_account',
          child: Text('Hesabı Sil'),
        ),
        const PopupMenuItem<String>(
          value: 'deactivate_account',
          child: Text('Hesabı Devre Dışı Bırak'),
        ),
        const PopupMenuItem<String>(
          value: 'notifications',
          child: Text('Bildirim Ayarları'),
        ),
      ],
    );

    if (result == 'logout') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.remove('name');
      await prefs.remove('surname');
      await prefs.remove('hasSeenUyeKayit');

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const SimpleLoginPage(),
      ));
    } else if (result == 'switch') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.remove('name');
      await prefs.remove('surname');
      await prefs.remove('hasSeenUyeKayit');

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const SimpleLoginPage(),
      ));
    } else if (result == 'profile') {
      // Profil bilgilerini göster
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Profil Bilgileri'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ad: $_userName'),
                Text('Soyad: $_userSurname'),
                Text('E-posta: $_userEmail'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    } else if (result == 'password') {
      // Şifre değiştir dialogunu göster
      await _showChangePasswordDialog(context);
    } else if (result == 'delete_account') {
      _showDeleteAccountDialog(context);
    } else if (result == 'deactivate_account') {
      _showDeactivateAccountDialog(context);
    } else if (result == 'notifications') {
      _showNotificationSettings(context);
    }
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hesabı Sil'),
          content: const Text(
              'Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz ve tüm verileriniz kalıcı olarak silinecektir.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteAccount();
              },
              child: const Text('Hesabı Sil', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showDeactivateAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hesabı Devre Dışı Bırak'),
          content: const Text(
              'Hesabınızı devre dışı bırakmak istediğinize emin misiniz? Hesabınız geçici olarak kapatılacak ve tekrar giriş yapana kadar kullanılamayacaktır.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                _deactivateAccount();
              },
              child: const Text('Devre Dışı Bırak', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('email');

      if (userEmail != null) {
        // Firestore'dan kullanıcıyı sil
        await _firestore.collection('üyelercollection').doc(userEmail).delete();

        // Yerel verileri temizle
        await prefs.clear();

        // Login sayfasına yönlendir
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SimpleLoginPage()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hesap silinirken bir hata oluştu')),
        );
      }
    }
  }

  Future<void> _deactivateAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('email');

      if (userEmail != null) {
        // Hesabı devre dışı bırak (hesapEngellendi = 1 yaparak)
        await _firestore.collection('üyelercollection').doc(userEmail).update({
          'hesapEngellendi': 1,
          'deactivatedAt': FieldValue.serverTimestamp(),
        });

        // Oturumu kapat
        await prefs.clear();

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SimpleLoginPage()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hesap devre dışı bırakılırken bir hata oluştu')),
        );
      }
    }
  }

  void _showNotificationSettings(BuildContext context) {
    TimeOfDay startTime = const TimeOfDay(hour: 22, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 8, minute: 0);
    bool isEnabled = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Sessiz Saatler'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Sessiz Saatleri Aktif Et'),
                    value: isEnabled,
                    onChanged: (value) {
                      setState(() => isEnabled = value!);
                    },
                  ),
                  if (isEnabled) ...[
                    const SizedBox(height: 10),
                    ListTile(
                      title: Text('Başlangıç: ${startTime.format(context)}'),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (time != null) {
                          setState(() => startTime = time);
                        }
                      },
                    ),
                    ListTile(
                      title: Text('Bitiş: ${endTime.format(context)}'),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (time != null) {
                          setState(() => endTime = time);
                        }
                      },
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('silent_hours_enabled', isEnabled);
                    await prefs.setString('silent_hours_start', '${startTime.hour}:${startTime.minute}');
                    await prefs.setString('silent_hours_end', '${endTime.hour}:${endTime.minute}');
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ayarlar kaydedildi')),
                      );
                    }
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        toolbarHeight: 105, // AppBar yüksekliğini biraz küçülttüm
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Üst kısım: Kullanıcı bilgileri ve çark - YAN YANA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sol tarafta kullanıcı adı soyadı YAN YANA
                if (_userName.isNotEmpty || _userSurname.isNotEmpty)
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          _userName,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _userSurname,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                // Sağ tarafta çark ikonu
                IconButton(
                  icon:
                  const Icon(Icons.settings, color: Colors.white, size: 30),
                  onPressed: () => _showAccountMenu(context),
                  tooltip: 'Hesap Ayarları',
                ),
              ],
            ),
            const SizedBox(height: 5),
            // Alt kısım: Logolar ve üniversite bilgisi - DAHA BÜYÜK
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sol logo - DAHA BÜYÜK
                Image.asset(
                  'assets/images/kkulogo.png',
                  height: 40, // Boyutu büyüttüm
                ),
                const SizedBox(width: 12),
                // Orta metin - DAHA BÜYÜK
                Column(
                  children: [
                    Text(
                      'Kırıkkale Üniversitesi',
                      style: TextStyle(
                        fontSize: 20.0, // Font büyüklüğünü artırdım
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Ekonomi Topluluğu',
                      style: TextStyle(
                        fontSize: 20.0, // Font büyüklüğünü artırdım
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Sağ logo - DAHA BÜYÜK
                Image.asset(
                  'assets/images/ekoslogo.png',
                  height: 40, // Boyutu büyüttüm
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white, // Beyaz arka plan
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16.0),
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: <Widget>[
                  _buildGridButton(
                    context,
                    'Ders Notu Paylaşım Sistemi',
                    Icons.menu_book,
                    DersNotlari1(),
                  ),
                  _buildGridButton(
                    context,
                    'Ders Notlarım',
                    Icons.menu_book,
                    DersNotlarim(),
                  ),
                  _buildGridButton(
                    context,
                    'Etkinlik Takvimi',
                    Icons.calendar_today,
                    EtkinlikJson(),
                  ),
                  _buildGridButton(
                    context,
                    'Yaklaşan Etkinlikler',
                    Icons.calendar_today,
                    EtkinlikJson2(),
                  ),
                  _buildGridButton(
                    context,
                    'Topluluk Haberleri',
                    Icons.newspaper,
                    const CommunityNews2Page(),
                  ),
                  _buildGridButton(
                    context,
                    'Sosyal Medya',
                    Icons.share,
                    const SocialMediaPage(),
                  ),
                  _buildGridButton(
                    context,
                    'Güncel Ekonomi',
                    Icons.bar_chart,
                    const CurrentEconomyPage(),
                  ),
                  _buildGridButton(
                    context,
                    'Canlı Piyasa',
                    Icons.show_chart,
                    LiveMarketPage(),
                  ),
                  _buildGridButton(
                    context,
                    'Sponsorlar',
                    Icons.business,
                    SponsorsPage(),
                  ),
                  _buildGridButton(
                    context,
                    'Anket Butonu',
                    Icons.poll,
                    SurveyPage(),
                  ),
                  _buildGridButton(
                    context,
                    'Yönetici Paneli',
                    Icons.admin_panel_settings,
                    AdminPanelPage(),
                  ),
                  _buildGridButton(
                    context,
                    'Geri Bildirim',
                    Icons.feedback,
                    FeedbackPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(
      BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8.0,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.deepPurple, width: 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: Colors.deepPurple),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

Future<bool> isInSilentHours() async {
  final prefs = await SharedPreferences.getInstance();
  final isEnabled = prefs.getBool('silent_hours_enabled') ?? false;

  if (!isEnabled) return false;

  final startTimeStr = prefs.getString('silent_hours_start')?.split(':');
  final endTimeStr = prefs.getString('silent_hours_end')?.split(':');

  if (startTimeStr == null || endTimeStr == null) return false;

  final now = TimeOfDay.now();
  final startTime = TimeOfDay(
    hour: int.parse(startTimeStr[0]),
    minute: int.parse(startTimeStr[1]),
  );

  var endTime = TimeOfDay(
    hour: int.parse(endTimeStr[0]),
    minute: int.parse(endTimeStr[1]),
  );

  // Eğer bitiş saati başlangıç saatinden önceyse, ertesi günü işaretle
  if (endTime.hour < startTime.hour ||
      (endTime.hour == startTime.hour && endTime.minute <= startTime.minute)) {
    endTime = TimeOfDay(hour: endTime.hour + 24, minute: endTime.minute);
  }

  final nowInMinutes = now.hour * 60 + now.minute;
  final startInMinutes = startTime.hour * 60 + startTime.minute;
  final endInMinutes = endTime.hour * 60 + endTime.minute;

  return nowInMinutes >= startInMinutes && nowInMinutes < endInMinutes;
}