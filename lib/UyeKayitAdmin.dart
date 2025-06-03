import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UyeKayit extends StatefulWidget {
  @override
  _UyeKayitState createState() => _UyeKayitState();
}

class _UyeKayitState extends State<UyeKayit> {
  // Firestore'dan veri almak için bir stream builder kullanacağız
  Stream<QuerySnapshot> _getData() {
    return FirebaseFirestore.instance.collection('member_join').snapshots();
  }

  // Veriyi Firestore'dan silme fonksiyonu
  Future<void> _deleteData(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('member_join')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veri başarıyla silindi!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silme hatası: $e')),
      );
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Verileri listeleyecek StreamBuilder
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _getData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData) {
                        return Center(child: Text('Veri bulunamadı.'));
                      }

                      var documents = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          var data =
                              documents[index].data() as Map<String, dynamic>;
                          var docId =
                              documents[index].id; // Document ID'yi alıyoruz

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: Text(data['name'] ?? 'Ad Soyad Yok'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'E-posta: ${data['email'] ?? 'E-posta Yok'}'),
                                  Text(
                                      'Telefon: ${data['phone'] ?? 'Telefon Yok'}'),
                                  Text(
                                      'Öğrenci Numarası: ${data['studentId'] ?? 'Numara Yok'}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Silme işlemi
                                  _deleteData(docId);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
