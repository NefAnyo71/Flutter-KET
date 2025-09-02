import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'services/local_storage_service.dart';

class DersNotlarim extends StatefulWidget {
  const DersNotlarim({Key? key}) : super(key: key);

  @override
  _DersNotlarimState createState() => _DersNotlarimState();
}

class _DersNotlarimState extends State<DersNotlarim> {
  final List<Map<String, dynamic>> _dersler = [];
  late LocalStorageService _storage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initStorage();
  }

  Future<void> _initStorage() async {
    _storage = await LocalStorageService.getInstance();
    _loadDersler();
  }

  Future<void> _loadDersler() async {
    setState(() => _isLoading = true);
    final dersler = await _storage.getDersler();
    setState(() {
      _dersler.clear();
      _dersler.addAll(dersler);
      _isLoading = false;
    });
  }

  Future<void> _addDers() async {
    final TextEditingController dersAdiController = TextEditingController();
    final TextEditingController donemController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ders Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dersAdiController,
              decoration: const InputDecoration(labelText: 'Ders Adı'),
            ),
            TextField(
              controller: donemController,
              decoration: const InputDecoration(labelText: 'Dönem'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (dersAdiController.text.isNotEmpty &&
                  donemController.text.isNotEmpty) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );

    if (result == true) {
      final newDers = {
        'ad': dersAdiController.text,
        'donem': donemController.text,
        'vizeFotolar': [],
        'finalFotolar': [],
      };
      await _storage.saveDers(newDers);
      await _loadDersler();
    }
  }

  Future<void> _addImage(int index, bool isVize) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final File savedImage = await LocalStorageService.copyFileToAppDir(imageFile);
      
      final updatedDers = Map<String, dynamic>.from(_dersler[index]);
      final List<String> fotolar = List<String>.from(updatedDers[isVize ? 'vizeFotolar' : 'finalFotolar']);
      fotolar.add(savedImage.path);
      updatedDers[isVize ? 'vizeFotolar' : 'finalFotolar'] = fotolar;
      
      await _storage.saveDers(updatedDers);
      await _loadDersler();
    }
  }

  Future<void> _deleteDers(int index) async {
    final ders = _dersler[index];
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dersi Sil'),
        content: Text('${ders['ad']} dersini silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _storage.deleteDers(ders['ad']);
      await _loadDersler();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ders Notlarım'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addDers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dersler.isEmpty
              ? const Center(child: Text('Henüz ders eklenmemiş'))
              : ListView.builder(
                  itemCount: _dersler.length,
                  itemBuilder: (context, index) {
                    final ders = _dersler[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(ders['ad']),
                            subtitle: Text('Dönem: ${ders['donem']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteDers(index),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFotoList(
                                  'Vize Notları',
                                  ders['vizeFotolar'] ?? [],
                                  () => _addImage(index, true),
                                ),
                                const SizedBox(height: 8),
                                _buildFotoList(
                                  'Final Notları',
                                  ders['finalFotolar'] ?? [],
                                  () => _addImage(index, false),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildFotoList(String title, List<dynamic> fotolar, VoidCallback onAdd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_photo_alternate, size: 20),
              onPressed: onAdd,
            ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 100,
          child: fotolar.isEmpty
              ? const Center(child: Text('Henüz fotoğraf eklenmemiş'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: fotolar.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.file(
                        File(fotolar[index]),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
