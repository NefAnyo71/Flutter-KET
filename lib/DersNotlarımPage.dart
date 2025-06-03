import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: DersNotlarim(),
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
    ),
  ));
}

class DersNotlarim extends StatefulWidget {
  @override
  _DersNotlarimState createState() => _DersNotlarimState();
}

class _DersNotlarimState extends State<DersNotlarim> {
  List<Ders> dersler = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  void _dersEkle() async {
    final adController = TextEditingController();
    String secilenDonem = 'Güz';

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text('Yeni Ders Ekle', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: adController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Ders Adı',
                  labelStyle: TextStyle(color: Colors.tealAccent),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                ),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                dropdownColor: Colors.grey[800],
                value: secilenDonem,
                items: ['Güz', 'Bahar'].map((d) {
                  return DropdownMenuItem(
                    value: d,
                    child: Text(d, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      secilenDonem = val;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('İptal', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: Text('Ekle', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (adController.text.trim().isNotEmpty) {
                  final yeniDers = Ders(adController.text.trim(), secilenDonem);
                  setState(() {
                    dersler.add(yeniDers);
                  });
                  await _verileriKaydet();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lütfen bir ders adı girin.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );

    adController.dispose();
  }

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/dersler.json');
  }

  Future<void> _verileriKaydet() async {
    try {
      final file = await _getLocalFile();
      final jsonData = dersler.map((d) => d.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Veri kaydetme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veri kaydedilirken hata oluştu.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _verileriYukle() async {
    try {
      setState(() => _isLoading = true);
      final file = await _getLocalFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(contents);

        setState(() {
          dersler = jsonData.map<Ders>((d) => Ders.fromJson(d)).toList();
        });
      }
    } catch (e) {
      print('Veri yükleme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veri yüklenirken hata oluştu.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fotoEkle(Ders ders, String tur, {bool fromGallery = false}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      );

      if (image == null) return;

      final dir = await getApplicationDocumentsDirectory();
      final klasor = Directory('${dir.path}/${ders.ad}_$tur');
      if (!await klasor.exists()) await klasor.create();

      final yeniFoto = File('${klasor.path}/${DateTime.now().millisecondsSinceEpoch}.png');
      await File(image.path).copy(yeniFoto.path);

      setState(() {
        if (tur == 'Vize') {
          ders.vizeFotolar.add(yeniFoto);
        } else {
          ders.finalFotolar.add(yeniFoto);
        }
      });

      await _verileriKaydet();
    } catch (e) {
      print('Fotoğraf ekleme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fotoğraf eklenirken hata oluştu.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showImageOptions(Ders ders, String tur) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[850],
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.tealAccent),
              title: Text('Kamera ile Çek', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _fotoEkle(ders, tur);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.tealAccent),
              title: Text('Galeriden Seç', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _fotoEkle(ders, tur, fromGallery: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.file(image, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fotoSil(Ders ders, String tur, int index) async {
    try {
      bool? onay = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text('Fotoğrafı Sil', style: TextStyle(color: Colors.white)),
          content: Text('Bu fotoğrafı silmek istediğinize emin misiniz?',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: Text('İptal', style: TextStyle(color: Colors.tealAccent)),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('Sil', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

      if (onay == true) {
        await (tur == 'Vize'
            ? ders.vizeFotolar[index]
            : ders.finalFotolar[index]).delete();

        setState(() {
          if (tur == 'Vize') {
            ders.vizeFotolar.removeAt(index);
          } else {
            ders.finalFotolar.removeAt(index);
          }
        });
        await _verileriKaydet();
      }
    } catch (e) {
      print('Fotoğraf silme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fotoğraf silinirken hata oluştu.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _dersSil(int index) async {
    try {
      bool? onay = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text('Dersi Sil', style: TextStyle(color: Colors.white)),
          content: Text('Bu dersi ve tüm notlarını silmek istediğinize emin misiniz?',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: Text('İptal', style: TextStyle(color: Colors.tealAccent)),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('Sil', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

      if (onay == true) {
        final ders = dersler[index];
        final dir = await getApplicationDocumentsDirectory();
        final vizeKlasor = Directory('${dir.path}/${ders.ad}_Vize');
        final finalKlasor = Directory('${dir.path}/${ders.ad}_Final');

        if (await vizeKlasor.exists()) await vizeKlasor.delete(recursive: true);
        if (await finalKlasor.exists()) await finalKlasor.delete(recursive: true);

        setState(() {
          dersler.removeAt(index);
        });
        await _verileriKaydet();
      }
    } catch (e) {
      print('Ders silme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ders silinirken hata oluştu.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget _dersKart(Ders ders, int index) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.grey[850],
      child: ExpansionTile(
        title: Text(
          '${ders.ad} (${ders.donem})',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _dersSil(index),
        ),
        children: [
          _fotoBolumu('Vize', ders.vizeFotolar, () => _showImageOptions(ders, 'Vize')),
          _fotoBolumu('Final', ders.finalFotolar, () => _showImageOptions(ders, 'Final')),
        ],
      ),
    );
  }

  Widget _fotoBolumu(String baslik, List<File> fotolar, VoidCallback onAddPressed) {
    return Column(
      children: [
        ListTile(
          title: Text(
            '$baslik Notları',
            style: TextStyle(color: Colors.tealAccent, fontSize: 16),
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_a_photo, color: Colors.tealAccent),
            onPressed: onAddPressed,
          ),
        ),
        fotolar.isEmpty
            ? Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Henüz fotoğraf yok.',
            style: TextStyle(color: Colors.grey),
          ),
        )
            : Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: fotolar.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showFullScreenImage(fotolar[index]),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.tealAccent, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          fotolar[index],
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.red, size: 20),
                        onPressed: () => _fotoSil(
                          dersler.firstWhere((d) => d.vizeFotolar.contains(fotolar[index]) ||
                              d.finalFotolar.contains(fotolar[index])),
                          baslik,
                          index,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ders Notlarım', style: TextStyle(color: Colors.red)),
        iconTheme: IconThemeData(color: Colors.tealAccent),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.teal))
          : dersler.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_add, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Henüz ders eklenmedi',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: dersler.length,
        itemBuilder: (context, index) => _dersKart(dersler[index], index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _dersEkle,
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
        tooltip: 'Ders Ekle',
      ),
    );
  }
}

class Ders {
  final String ad;
  final String donem;
  List<File> vizeFotolar;
  List<File> finalFotolar;

  Ders(this.ad, this.donem)
      : vizeFotolar = [],
        finalFotolar = [];

  Map<String, dynamic> toJson() => {
    'ad': ad,
    'donem': donem,
    'vizeFotolar': vizeFotolar.map((f) => f.path).toList(),
    'finalFotolar': finalFotolar.map((f) => f.path).toList(),
  };

  factory Ders.fromJson(Map<String, dynamic> json) {
    final ders = Ders(json['ad'], json['donem']);

    ders.vizeFotolar = (json['vizeFotolar'] as List<dynamic>? ?? [])
        .map((path) => File(path as String))
        .toList();

    ders.finalFotolar = (json['finalFotolar'] as List<dynamic>? ?? [])
        .map((path) => File(path as String))
        .toList();

    return ders;
  }
}