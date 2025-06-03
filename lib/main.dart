import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received message: ${message.notification?.title}');
  });

  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('tr_TR', null);

  // Bildirim iznini iste
  await _requestNotificationPermission();

  // Depolama iznini iste
  await _requestStoragePermission();

  // FCM Token al
  await _getFCMToken();

  // Durum çubuğunu gizle
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

Future<void> _requestNotificationPermission() async {
  PermissionStatus status = await Permission.notification.request();

  if (status.isGranted) {
    print("Bildirim izni verildi!");
  } else if (status.isDenied) {
    print("Bildirim izni reddedildi.");
  } else if (status.isPermanentlyDenied) {
    print(
        "Bildirim izni kalıcı olarak reddedildi. Ayarlardan izin verebilirsiniz.");

    openAppSettings();
  }
}

Future<void> _requestStoragePermission() async {
  // Depolama iznini kontrol et ve iste
  PermissionStatus status = await Permission.storage.request();

  if (status.isGranted) {
    print("Depolama izni verildi!");
  } else if (status.isDenied) {
    print("Depolama izni reddedildi.");
  } else if (status.isPermanentlyDenied) {
    print(
        "Depolama izni kalıcı olarak reddedildi. Ayarlardan izin verebilirsiniz.");

    openAppSettings();
  }
}

Future<void> _getFCMToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("Firebase Token: $token");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EKOS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C4DFF), Color(0xFF18FFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/kkulogo.png',
                        height: 60.0,
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Kırıkkale Üniversitesi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0, // Font boyutunu biraz büyüttük
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Image.asset(
                        'assets/images/ekoslogo.png',
                        height: 60.0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Ekonomi Topluluğu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              children: <Widget>[
                _buildGridButton(
                  context,
                  'Üye Kayıt',
                  Icons.person_add,
                  UyeKayit(),
                ),
                _buildGridButton(
                  context,
                  'Etkinlik Takvimi',
                  Icons.calendar_today,
                  EtkinlikJson(),
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
                _buildGridButton(
                  context,
                  'Ders Notlarım',
                  Icons.menu_book,
                  DersNotlarim(),
                ),
              ],
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
          gradient: const LinearGradient(
            colors: [Color(0xFF7C4DFF), Color(0xFF18FFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0), // Köşe yuvarlama artırıldı
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8.0, // Gölgeler arttırıldı
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 55.0, color: Colors.white),
            const SizedBox(height: 8.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
