import 'package:flutter/material.dart';
import 'firebase_service.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  void _submitFeedback() async {
    final feedback = _feedbackController.text;
    final email = _emailController.text;
    if (feedback.isNotEmpty && email.isNotEmpty) {
      try {
        await _firebaseService
            .insertFeedback({'feedback': feedback, 'email': email});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Geri bildiriminiz için teşekkür ederiz!')),
        );
        _feedbackController.clear();
        _emailController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Geri bildirim gönderilirken bir hata oluştu: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geri Bildirim'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A90E2), // Mavi
              Color(0xFFFFA500), // Turuncu
              Color(0xFFFFD700), // Altın Sarısı
              Color(0xFFFF0000), // Kırmızı
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Geri Bildirim',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Geri bildiriminiz',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-posta adresiniz',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}
