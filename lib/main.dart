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
import 'account_settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_update/in_app_update.dart';
import 'gemini_chat_page.dart';


// Bildirimler için bir instance oluşturun
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Firestore instance
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Arka plan görevi için top-level fonksiyon
@pragma('vm:entry-point')
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
              const Text('Ekonomi Topluluğu Güncelleniyor...',
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
  bool _hasSeenUyeKayit = false;

  // Giriş durumunu kontrol et
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final hasSeenUyeKayit = prefs.getBool('hasSeenUyeKayit') ?? false;

    setState(() {
      _isLoggedIn = email != null;
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
  int _eventNotificationCount = 0;
  bool _showKetMessage = false;

  @override
  void initState() {
    super.initState();
    _loadUserData().then((_) {
      // Veriler yüklendikten sonra, widget ağaca bağlıysa ve isim boş değilse
      // hoş geldin mesajını göster.
      if (mounted && _userName.isNotEmpty) {
        // build metodu tamamlandıktan sonra dialog göstermek için callback kullanıyoruz.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showWelcomeDialog(context);
        });
      }
    });
    _loadNotificationCount();
    _listenToNotifications();
    
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    // setState çağırmadan önce widget'ın hala ağaçta olduğundan emin ol
    if (!mounted) return;
    setState(() {
      _userName = prefs.getString('name') ?? '';
      _userSurname = prefs.getString('surname') ?? '';
      _userEmail = prefs.getString('email') ?? '';
    });
  }

  Future<void> _loadNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _eventNotificationCount = prefs.getInt('event_notification_count') ?? 0;
      });
    }
  }

  void _listenToNotifications() {
    // Foreground mesajları dinle
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📱 Bildirim geldi: ${message.notification?.title}');
      print('📱 Data: ${message.data}');
      
      if (message.data['type'] == 'event' || 
          message.notification?.title?.contains('Etkinlik') == true ||
          message.notification?.title?.contains('etkinlik') == true) {
        print('🔔 Etkinlik bildirimi tespit edildi, sayaç artırılıyor');
        _incrementNotificationCount();
      }
    });
    
    // Background/terminated durumdan gelen mesajları dinle
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📱 Arka plan bildirim açıldı: ${message.notification?.title}');
      if (message.data['type'] == 'event' || 
          message.notification?.title?.contains('Etkinlik') == true ||
          message.notification?.title?.contains('etkinlik') == true) {
        _incrementNotificationCount();
      }
    });
    
    // Uygulama kapalıyken gelen mesajları kontrol et
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('📱 Uygulama kapalıyken gelen mesaj: ${message.notification?.title}');
        if (message.data['type'] == 'event' || 
            message.notification?.title?.contains('Etkinlik') == true ||
            message.notification?.title?.contains('etkinlik') == true) {
          _incrementNotificationCount();
        }
      }
    });
  }

  Future<void> _incrementNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _eventNotificationCount++;
      });
      await prefs.setInt('event_notification_count', _eventNotificationCount);
      print('✅ Bildirim sayaç artırıldı: $_eventNotificationCount');
    }
  }

  Future<void> _clearNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('event_notification_count', 0);
    if (mounted) {
      setState(() {
        _eventNotificationCount = 0;
      });
    }
  }

  void _showWelcomeDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, 
      barrierLabel: 'Arka Plan',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500), 
      pageBuilder: (context, animation, secondaryAnimation) {

        return Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.waving_hand_rounded, size: 50, color: Colors.amber),
                  const SizedBox(height: 16),
                  const Text('Hoş Geldin', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('$_userName $_userSurname', style: TextStyle(fontSize: 18, color: Colors.grey.shade700), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Bu kısım giriş ve çıkış animasyonunu yönetir.
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack, 
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );

    // 2.5 saniye sonra dialog'u otomatik olarak kapat
    Future.delayed(const Duration(milliseconds: 2500), () {
      // Dialog'u kapatmadan önce hala ekranda olup olmadığını kontrol et
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
        // Selamlama bittikten sonra KET mesajını göster
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _showKetMessage = true;
            });
            print('KET mesajı gösterildi: $_showKetMessage');
            // 4 saniye sonra mesajı gizle
            Future.delayed(const Duration(seconds: 4), () {
              if (mounted) {
                setState(() {
                  _showKetMessage = false;
                });
                print('KET mesajı gizlendi');
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        elevation: 4.0,
        toolbarHeight: 80,
        title: Row(
          children: [
            Image.asset('assets/images/ekoslogo.png', height: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_userName $_userSurname',
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    'Ekonomi Topluluğu',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountSettingsPage(
                    userName: _userName,
                    userSurname: _userSurname,
                    userEmail: _userEmail,
                  ),
                ),
              );
            },
            tooltip: 'Hesap Ayarları',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
                  _buildGridButtonWithBadge(
                    context,
                    'Yaklaşan Etkinlikler',
                    Icons.calendar_today,
                    EtkinlikJson2(),
                    _eventNotificationCount,
                    _clearNotificationCount, 
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
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeminiChatPage(
                    userName: _userName,
                    userSurname: _userSurname,
                    userEmail: _userEmail,
                  )),
                );
              },
              backgroundColor: Colors.deepPurple.shade700,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/ketyapayzeka.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          if (_showKetMessage)
            Positioned(
              right: 90,
              bottom: 20,
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.deepPurple.shade300, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hoş geldin $_userName!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sana nasıl yardımcı olabilirim?',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Üstüme tıkla!',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
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
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.deepPurple.shade100, width: 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45.0, color: Colors.deepPurple.shade600),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButtonWithBadge(
      BuildContext context, String title, IconData icon, Widget page, int badgeCount, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(color: Colors.deepPurple.shade100, width: 1.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 45.0, color: Colors.deepPurple.shade600),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (badgeCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  badgeCount > 99 ? '99+' : badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
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