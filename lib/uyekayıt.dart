import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UyeKayit extends StatelessWidget {
  final String _formUrl = 'https://docs.google.com/forms/d/e/1FAIpQLSc7Lz4uHJ3IMumETY82UDmycO6csWFtHCmmh0YGNjB_4HbS0Q/viewform';

  void _openFormLink() async {
    final Uri url = Uri.parse(_formUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Bağlantı açılamadı: $_formUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Üye Kayıt Ekranı'),
        backgroundColor: Color(0xFF4A90E2),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A90E2),
              Color(0xFFFFA500),
              Color(0xFFFFD700),
              Color(0xFFFF0000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: _openFormLink,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFD700),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Google Form ile Kayıt Ol'),
          ),
        ),
      ),
    );
  }
}
