import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CurrentEconomyPage extends StatefulWidget {
  const CurrentEconomyPage({super.key});

  @override
  CurrentEconomyPageState createState() => CurrentEconomyPageState();
}

class CurrentEconomyPageState extends State<CurrentEconomyPage> {
  final DatabaseReference _newsRef = FirebaseDatabase.instance.ref("news");
  List<Map<String, String>> _newsList = [];

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() {
    _newsRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        List<Map<String, String>> tempList = [];
        data.forEach((key, value) {
          tempList.add({
            "title": value["title"],
            "content": value["content"],
            "date": value["date"]
          });
        });
        // Haberleri tarihe göre sıralama (en yeni tarih üste olacak şekilde)
        tempList.sort((a, b) => b["date"]!.compareTo(a["date"]!));
        setState(() {
          _newsList = tempList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Güncel Ekonomi'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _newsList.isEmpty
          ? const Center(
              child: CircularProgressIndicator()) // Yükleniyor göstergesi
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _newsList.length,
              itemBuilder: (context, index) {
                return _buildNewsCard(
                  context,
                  _newsList[index]["title"] ?? "",
                  _newsList[index]["content"] ?? "",
                  _newsList[index]["date"] ?? "",
                );
              },
            ),
    );
  }

  Widget _buildNewsCard(
      BuildContext context, String title, String content, String date) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NewsDetailPage(title: title, content: content, date: date),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                content,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final String date;

  const NewsDetailPage(
      {super.key,
      required this.title,
      required this.content,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haber Detayları'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              date,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              content,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
