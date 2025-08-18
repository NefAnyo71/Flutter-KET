import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

// Renk paleti
class AppColors {
  static const Color primary = Color(0xFF4A6EE0);
  static const Color primaryLight = Color(0xFF7B9AFF);
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color background = Color(0xFFF8FAFF);
  static const Color card = Colors.white;
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color border = Color(0xFFE2E8F0);
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFED8936);
  static const Color error = Color(0xFFE53E3E);
}

// Metin stilleri
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

class DersNotlarim extends StatefulWidget {
  const DersNotlarim({Key? key}) : super(key: key);

  @override
  _DersNotlarimState createState() => _DersNotlarimState();
}

class _DersNotlarimState extends State<DersNotlarim> {
  final List<Ders> dersler = [];
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();
  final Set<File> _selectedPhotos = {};
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  Future<void> _verileriYukle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString('dersler');

      if (jsonData != null) {
        final List<dynamic> decoded = jsonDecode(jsonData);
        dersler.clear();
        for (var dersJson in decoded) {
          dersler.add(Ders.fromJson(dersJson));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veriler yüklenirken bir hata oluştu'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _verileriKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(dersler.map((d) => d.toJson()).toList());
    await prefs.setString('dersler', jsonData);
  }

  Future<void> _dersEkle() async {
    final adController = TextEditingController();
    String? secilenDonem;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ders Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: adController,
              decoration: const InputDecoration(
                labelText: 'Ders Adı',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Dönem',
                border: OutlineInputBorder(),
              ),
              items: ['Güz', 'Bahar', 'Yaz'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                secilenDonem = newValue;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (adController.text.trim().isNotEmpty && secilenDonem != null) {
                Navigator.pop(context, {
                  'ad': adController.text.trim(),
                  'donem': secilenDonem!,
                });
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );

    if (result != null) {
      final yeniDers = Ders(result['ad']!, result['donem']!);
      setState(() {
        dersler.add(yeniDers);
      });
      await _verileriKaydet();
    }
  }

  Widget _buildDersItem(Ders ders, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border.withOpacity(0.5), width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRandomColor().withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: _getRandomColor(),
              size: 20,
            ),
          ),
          title: Text(
            ders.ad,
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${ders.donem} Dönemi',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${ders.vizeFotolar.length + ders.finalFotolar.length} Not',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                onPressed: () => _showDersOptions(ders, index),
              ),
            ],
          ),
          children: [
            const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
            _buildFotoBolumu('Vize', ders.vizeFotolar, () => _showImageOptions(ders, 'Vize')),
            _buildFotoBolumu('Final', ders.finalFotolar, () => _showImageOptions(ders, 'Final')),
          ],
        ),
      ),
    );
  }

  Color _getRandomColor() {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      const Color(0xFF805AD5),
      const Color(0xFF0BC5EA),
      const Color(0xFF38B2AC),
    ];
    return colors[math.Random().nextInt(colors.length)];
  }

  Widget _buildFotoBolumu(String baslik, List<File> fotolar, VoidCallback onAddPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$baslik Notları',
                style: AppTextStyles.heading2.copyWith(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (fotolar.isNotEmpty && _isSelecting)
                    IconButton(
                      icon: const Icon(Icons.check_box_outlined, size: 24),
                      onPressed: () {
                        setState(() {
                          final allPhotos = fotolar.toSet();
                          if (_selectedPhotos.containsAll(allPhotos)) {
                            _selectedPhotos.removeAll(allPhotos);
                          } else {
                            _selectedPhotos.addAll(allPhotos);
                          }
                        });
                      },
                    ),
                  TextButton.icon(
                    onPressed: onAddPressed,
                    icon: const Icon(Icons.add_photo_alternate_outlined, size: 20),
                    label: Text(
                      'Ekle',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (fotolar.isEmpty)
          GestureDetector(
            onTap: onAddPressed,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 40,
                    color: AppColors.textSecondary.withOpacity(0.6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Henüz $baslik notu eklenmedi',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Not eklemek için dokunun',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: fotolar.length,
              itemBuilder: (context, index) {
                return _buildFotoItem(fotolar[index], baslik, index);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildFotoItem(File foto, String tur, int index) {
    bool isSelected = _selectedPhotos.contains(foto);

    return GestureDetector(
      onTap: () {
        if (_isSelecting) {
          setState(() {
            if (isSelected) {
              _selectedPhotos.remove(foto);
            } else {
              _selectedPhotos.add(foto);
            }
          });
        } else {
          _showFullScreenImage(foto);
        }
      },
      onLongPress: () {
        if (!_isSelecting) {
          setState(() {
            _isSelecting = true;
            _selectedPhotos.add(foto);
          });
        }
      },
      child: Hero(
        tag: 'image_${foto.path}',
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: isSelected ? Border.all(color: AppColors.primary, width: 3) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  foto,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.note_add_rounded,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Henüz ders eklenmedi',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Text(
              'Ders notlarınızı eklemek için aşağıdaki butona tıklayın',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _dersEkle,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text('Ders Ekle', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dersler.isNotEmpty && !_isSelecting)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              heroTag: "chatGptButton",
              onPressed: () async {
                const url = 'https://play.google.com/store/apps/details?id=com.openai.chatgpt';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication);
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ChatGPT uygulaması açılamadı'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              backgroundColor: Colors.white,
              elevation: 4,
              tooltip: 'ChatGPT\'yi Aç',
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF10A37F),
                      const Color(0xFF10A37F).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.chat, color: Colors.white),
              ),
            ),
          ),
        FloatingActionButton(
          heroTag: "dersEkleButton",
          onPressed: _dersEkle,
          backgroundColor: AppColors.primary,
          tooltip: 'Ders Ekle',
          child: const Icon(Icons.add, size: 28),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          _isSelecting
              ? '${_selectedPhotos.length} Seçili'
              : 'Ders Notlarım',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.primary),
        leading: _isSelecting
            ? IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              _isSelecting = false;
              _selectedPhotos.clear();
            });
          },
        )
            : null,
        actions: _isSelecting
            ? [
          if (_selectedPhotos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share, color: AppColors.primary),
              onPressed: _shareSelectedPhotos,
            ),
          if (_selectedPhotos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: _deleteSelectedPhotos,
            ),
        ]
            : [],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      )
          : dersler.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _verileriYukle,
        color: AppColors.primary,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemCount: dersler.length,
          itemBuilder: (context, index) => _buildDersItem(dersler[index], index),
        ),
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  // Diğer metodlar...
  void _showDersOptions(Ders ders, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ders.ad,
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.primary),
              title: const Text('Düzenle'),
              onTap: () {
                Navigator.pop(context);
                _dersDuzenle(ders, index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Sil', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                _dersSil(index);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _dersDuzenle(Ders ders, int index) async {
    final adController = TextEditingController(text: ders.ad);
    String secilenDonem = ders.donem;

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Dersi Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: adController,
                decoration: const InputDecoration(
                  labelText: 'Ders Adı',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: secilenDonem,
                decoration: const InputDecoration(
                  labelText: 'Dönem',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                items: ['Güz', 'Bahar'].map((d) {
                  return DropdownMenuItem(
                    value: d,
                    child: Text(d),
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (adController.text.trim().isNotEmpty) {
                  setState(() {
                    ders.ad = adController.text.trim();
                    ders.donem = secilenDonem;
                  });
                  _verileriKaydet();
                  if (!mounted) return;
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ders başarıyla güncellendi'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Kaydet', style: AppTextStyles.button),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dersSil(int index) async {
    try {
      bool? onay = await showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Dersi Sil', style: TextStyle(color: Colors.white)),
          content: const Text(
              'Bu dersi ve tüm notlarını silmek istediğinize emin misiniz?',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: const Text('İptal',
                  style: TextStyle(color: Colors.tealAccent)),
              onPressed: () => Navigator.pop(dialogContext, false),
            ),
            TextButton(
              child: const Text('Sil', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(dialogContext, true),
            ),
          ],
        ),
      );

      if (onay == true) {
        final ders = dersler[index];
        final dir = await getApplicationDocumentsDirectory();
        final safeDersAdi = ders.ad.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
        final klasor = Directory('${dir.path}/ders_notlari/$safeDersAdi');

        if (await klasor.exists()) {
          await klasor.delete(recursive: true);
        }

        setState(() {
          dersler.removeAt(index);
        });
        await _verileriKaydet();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ders silinirken hata oluştu.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _fotoEkle(Ders ders, String tur, {bool fromGallery = false}) async {
    try {
      if (fromGallery) {
        final List<XFile>? selectedImages = await _picker.pickMultiImage(
          imageQuality: 85,
          maxWidth: 2000,
          maxHeight: 2000,
        );

        if (selectedImages == null || selectedImages.isEmpty) return;

        final dir = await getApplicationDocumentsDirectory();
        final safeDersAdi = ders.ad.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
        final klasor = Directory('${dir.path}/ders_notlari/$safeDersAdi/$tur');

        if (!await klasor.exists()) {
          await klasor.create(recursive: true);
        }

        int successCount = 0;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        try {
          for (final image in selectedImages) {
            try {
              final timestamp = DateTime.now().millisecondsSinceEpoch + successCount;
              final yeniFoto = File('${klasor.path}/$timestamp.jpg');

              await File(image.path).copy(yeniFoto.path);

              if (await yeniFoto.exists()) {
                setState(() {
                  if (tur == 'Vize') {
                    ders.vizeFotolar.add(yeniFoto);
                  } else {
                    ders.finalFotolar.add(yeniFoto);
                  }
                });
                successCount++;
              }
            } catch (e) {
              debugPrint('Error processing image: $e');
            }
          }

          await _verileriKaydet();

          if (mounted) {
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$successCount adet $tur notu başarıyla eklendi'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } catch (e) {
          if (mounted) Navigator.of(context).pop();
          rethrow;
        }
      } else {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          maxWidth: 2000,
          maxHeight: 2000,
        );

        if (image == null) return;

        final dir = await getApplicationDocumentsDirectory();
        final safeDersAdi = ders.ad.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
        final klasor = Directory('${dir.path}/ders_notlari/$safeDersAdi/$tur');

        if (!await klasor.exists()) {
          await klasor.create(recursive: true);
        }

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final yeniFoto = File('${klasor.path}/$timestamp.jpg');

        try {
          await File(image.path).copy(yeniFoto.path);

          if (!await yeniFoto.exists()) {
            throw Exception('Dosya oluşturulamadı');
          }

          setState(() {
            if (tur == 'Vize') {
              ders.vizeFotolar.add(yeniFoto);
            } else {
              ders.finalFotolar.add(yeniFoto);
            }
          });

          await _verileriKaydet();

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$tur notu başarıyla eklendi'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          if (await yeniFoto.exists()) {
            await yeniFoto.delete();
          }
          rethrow;
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fotoğraf eklenirken hata oluştu.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showImageOptions(Ders ders, String tur) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[850],
      builder: (BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.tealAccent),
              title: const Text('Kamera ile Çek', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _fotoEkle(ders, tur);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.tealAccent),
              title: const Text('Galeriden Seç', style: TextStyle(color: Colors.white)),
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
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () => _shareImage(image),
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Hero(
                tag: 'image_${image.path}',
                child: Image.file(
                  image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.error, color: Colors.white, size: 50),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _shareImage(File image) async {
    try {
      if (image.existsSync()) {
        await Share.shareXFiles([XFile(image.path)], text: 'Ders notumu paylaşıyorum!');
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Paylaşılacak dosya bulunamadı.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paylaşım sırasında bir hata oluştu.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _shareSelectedPhotos() async {
    if (_selectedPhotos.isEmpty) return;
    try {
      final xFiles = _selectedPhotos.map((f) => XFile(f.path)).toList();
      await Share.shareXFiles(xFiles, text: 'Ders notlarımı paylaşıyorum!');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Seçili fotoğraflar paylaşılırken bir hata oluştu.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteSelectedPhotos() async {
    if (_selectedPhotos.isEmpty) return;

    bool? onay = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seçili Fotoğrafları Sil'),
        content: Text(
            'Seçtiğiniz ${_selectedPhotos.length} adet fotoğrafı silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (onay == true) {
      try {
        for (final file in _selectedPhotos) {
          if (await file.exists()) {
            await file.delete();
          }
        }

        // Seçilen fotoğrafları ana listeden kaldır
        for (var ders in dersler) {
          ders.vizeFotolar.removeWhere((foto) => _selectedPhotos.contains(foto));
          ders.finalFotolar.removeWhere((foto) => _selectedPhotos.contains(foto));
        }

        await _verileriKaydet();

        if (mounted) {
          setState(() {
            _selectedPhotos.clear();
            _isSelecting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_selectedPhotos.length} fotoğraf başarıyla silindi.'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fotoğraflar silinirken bir hata oluştu.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  void _showFotoOptions(File foto, String tur, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Not İşlemleri',
                style: AppTextStyles.heading2,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.visibility, color: AppColors.primary),
              title: const Text('Görüntüle'),
              onTap: () {
                Navigator.pop(context);
                _showFullScreenImage(foto);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Sil', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                Ders? containingDers;
                for (var d in dersler) {
                  if (d.vizeFotolar.contains(foto) || d.finalFotolar.contains(foto)) {
                    containingDers = d;
                    break;
                  }
                }
                if (containingDers != null) {
                  _fotoSil(containingDers, tur, index);
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _fotoSil(Ders ders, String tur, int index) async {
    try {
      bool? onay = await showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Fotoğrafı Sil', style: TextStyle(color: Colors.white)),
          content: const Text(
              'Bu fotoğrafı silmek istediğinize emin misiniz?',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: const Text('İptal',
                  style: TextStyle(color: Colors.tealAccent)),
              onPressed: () => Navigator.pop(dialogContext, false),
            ),
            TextButton(
              child: const Text('Sil', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(dialogContext, true),
            ),
          ],
        ),
      );

      if (onay == true) {
        File fileToDelete;
        if (tur == 'Vize') {
          fileToDelete = ders.vizeFotolar[index];
        } else {
          fileToDelete = ders.finalFotolar[index];
        }

        await fileToDelete.delete();

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fotoğraf silinirken hata oluştu.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}

class Ders {
  String ad;
  String donem;
  List<File> vizeFotolar;
  List<File> finalFotolar;

  Ders(this.ad, this.donem, {List<File>? vizeFotolar, List<File>? finalFotolar})
      : vizeFotolar = vizeFotolar ?? [],
        finalFotolar = finalFotolar ?? [];

  factory Ders.fromJson(Map<String, dynamic> json) {
    List<File> loadImagePaths(List<dynamic>? paths) {
      if (paths == null) return [];
      return paths.map((path) {
        try {
          return File(path as String)..existsSync();
        } catch (e) {
          return null;
        }
      }).whereType<File>().toList();
    }

    return Ders(
      json['ad'] as String,
      json['donem'] as String,
      vizeFotolar: loadImagePaths(json['vizeFotolar'] as List<dynamic>?),
      finalFotolar: loadImagePaths(json['finalFotolar'] as List<dynamic>?),
    );
  }

  Map<String, dynamic> toJson() {
    String getValidPath(File file) => file.existsSync() ? file.path : '';

    return {
      'ad': ad,
      'donem': donem,
      'vizeFotolar': vizeFotolar.map(getValidPath).where((p) => p.isNotEmpty).toList(),
      'finalFotolar': finalFotolar.map(getValidPath).where((p) => p.isNotEmpty).toList(),
    };
  }
}