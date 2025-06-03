import 'package:flutter/material.dart';
import 'package:ket/BasvuruSorgulama.dart';
import 'Topluluk_Haberleri_Yönetici.dart';
import 'cleaner_admin_page.dart';
import 'UyeKayitAdmin.dart';
import 'oylama.dart';
import 'puanlama_sayfasi.dart';
import 'website_applications_page.dart';
import 'BlackList.dart';
import 'Cerezler.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Paneli',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black), // Varsayılan metin rengi
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.black), // Input label rengi
        ),
      ),
      home: const AdminPanelPage(),
    );
  }
}

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({Key? key}) : super(key: key);

  void _showLoginDialog(BuildContext context, Widget destinationPage) {
    final _formKey = GlobalKey<FormState>();
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();
    final String _correctUsername = 'kkuekonomi71';
    final String _correctPassword = 'kkuekonomi71';
    bool _obscurePassword = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Yönetici Girişi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black, // Başlık rengi siyah
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  style: TextStyle(color: Colors.black), // Input metin rengi
                  decoration: const InputDecoration(
                    labelText: 'Kullanıcı Adı',
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen kullanıcı adınızı girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.black), // Input metin rengi
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black, // Göz ikonu rengi
                      ),
                      onPressed: () {
                        _obscurePassword = !_obscurePassword;
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen şifrenizi girin';
                    }
                    if (value.length < 6) {
                      return 'Şifre en az 6 karakter olmalıdır';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                if (_usernameController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty &&
                    (_usernameController.text != _correctUsername ||
                        _passwordController.text != _correctPassword))
                  const Text(
                    'Kullanıcı adı veya şifre hatalı',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'VAZGEÇ',
                style: TextStyle(color: Colors.black), // Buton metin rengi
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_usernameController.text == _correctUsername &&
                      _passwordController.text == _correctPassword) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => destinationPage),
                    );
                  } else {
                    (context as Element).markNeedsBuild();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'GİRİŞ YAP',
                style: TextStyle(
                    color: Colors.white), // Bu butonun metni beyaz kalsın
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceBetween,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Paneli',
          style: TextStyle(color: Colors.white), // AppBar başlık rengi
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.white), // AppBar ikon rengi
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFFFFA500),
              Color(0xFFFFD700),
              Color(0xFFFF0000),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            _buildAdminButton(
              context,
              'Etkinlik Takvimi',
              Icons.calendar_month_outlined,
              CleanderAdminPage(),
            ),
            _buildAdminButton(
              context,
              'Topluluk Haberleri',
              Icons.newspaper_outlined,
              ToplulukHaberleriSayfasi(),
            ),
            _buildAdminButton(
              context,
              'Üye Kayıtları',
              Icons.person_add_alt_1_outlined,
              UyeKayit(),
            ),
            _buildAdminButton(
              context,
              'Oylama Ekranı',
              Icons.how_to_vote_outlined,
              VotingScreen(),
            ),
            _buildAdminButton(
              context,
              'İnternet Sitesi Başvuruları',
              Icons.web_outlined,
              WebsiteApplicationsPage(),
            ),
            _buildAdminButton(
              context,
              'Öğrenci Veri Tabanı',
              Icons.web_outlined,
              BasvuruSorgulama(),
            ),
            _buildAdminButton(
              context,
              'Karaliste',
              Icons.web_outlined,
              KaraListe(),
            ),
            _buildAdminButton(
              context,
              'Yapay Zeka Öğrenci\nAlgoritma Puanlama Sistemi', 
              Icons.web_outlined,
              PuanlamaSayfasi(),
            ),
            _buildAdminButton(
              context,
              'İnternet Sitesi Çerezleri',
              Icons.web_outlined,
              SiteSessionsWidget(),  // Burası widget olduğu için uygun
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminButton(
    BuildContext context,
    String label,
    IconData icon,
    Widget destinationPage,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showLoginDialog(context, destinationPage),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 28, color: Colors.black), // İkon rengi siyah
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black, // Buton metin rengi siyah
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right,
                  color: Colors.black), // Ok ikonu siyah
            ],
          ),
        ),
      ),
    );
  }
}
