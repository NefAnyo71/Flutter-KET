import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class UyeKayit extends StatefulWidget {
  const UyeKayit({Key? key}) : super(key: key);

  @override
  _UyeKayitState createState() => _UyeKayitState();
}

class _UyeKayitState extends State<UyeKayit> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  List<DocumentSnapshot> _users = [];
  final Map<String, bool> _passwordVisible = {};

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      print('Kullanıcılar yükleniyor...');
      final querySnapshot = await _firestore
          .collection('üyelercollection')
          .orderBy('createdAt', descending: true)
          .get();

      print('Toplam ${querySnapshot.docs.length} kullanıcı bulundu');
      if (querySnapshot.docs.isNotEmpty) {
        print('İlk kullanıcı verisi: ${querySnapshot.docs.first.data()}');
      }

      setState(() {
        _users = querySnapshot.docs;
        // Initialize password visibility map
        for (var doc in _users) {
          _passwordVisible[doc.id] = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Kullanıcı yükleme hatası: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcılar yüklenirken hata oluştu: $e')),
      );
    }
  }

  Future<void> _toggleUserBlockStatus(String userId, bool isBlocked) async {
    try {
      await _firestore.collection('üyelercollection').doc(userId).update({
        'hesapEngellendi': isBlocked ? 0 : 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await _loadUsers(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isBlocked ? 'Kullanıcı engeli kaldırıldı' : 'Kullanıcı engellendi'),
          backgroundColor: isBlocked ? Colors.green : Colors.orange,
        ),
      );
    } catch (e) {
      print('Error updating user status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İşlem sırasında hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Üye Yönetimi'),
        centerTitle: true,
        backgroundColor: const Color(0xFF5E35B1),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(
                  child: Text(
                    'Kayıtlı kullanıcı bulunamadı',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('E-posta')),
                        DataColumn(label: Text('Ad')),
                        DataColumn(label: Text('Soyad')),
                        DataColumn(label: Text('Şifre')),
                        DataColumn(label: Text('Kayıt Tarihi')),
                        DataColumn(label: Text('Durum')),
                        DataColumn(label: Text('İşlemler')),
                      ],
                      rows: _users.map((user) {
                        final data = user.data() as Map<String, dynamic>;
                        final createdAt = data['createdAt'] != null
                            ? (data['createdAt'] as Timestamp).toDate()
                            : DateTime.now();
                        final isBlocked = data['hesapEngellendi'] == 1;
                        _passwordVisible[user.id] = _passwordVisible[user.id] ?? false;

                        return DataRow(
                          cells: [
                            DataCell(Text(data['email'] ?? 'N/A')),
                            DataCell(Text(data['name'] ?? 'N/A')),
                            DataCell(Text(data['surname'] ?? 'N/A')),
                            DataCell(
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _passwordVisible[user.id]!
                                          ? data['password'] ?? 'N/A'
                                          : '•' * 8,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _passwordVisible[user.id]!
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible[user.id] =
                                            !_passwordVisible[user.id]!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(
                              '${createdAt.day}.${createdAt.month}.${createdAt.year} ${createdAt.hour}:${createdAt.minute}'
                            )),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isBlocked ? Colors.red[100] : Colors.green[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isBlocked ? 'Engelli' : 'Aktif',
                                  style: TextStyle(
                                    color: isBlocked ? Colors.red[800] : Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              ElevatedButton(
                                onPressed: () => _toggleUserBlockStatus(
                                    user.id, isBlocked),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isBlocked
                                      ? Colors.green
                                      : Colors.orange,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(isBlocked ? 'Engeli Kaldır' : 'Engelle'),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
    );
  }
}
