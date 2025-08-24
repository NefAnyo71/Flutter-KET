import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DersNotlariAdmin1 extends StatefulWidget {
  const DersNotlariAdmin1({Key? key}) : super(key: key);

  @override
  _DersNotlariAdmin1State createState() => _DersNotlariAdmin1State();
}

class _DersNotlariAdmin1State extends State<DersNotlariAdmin1> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedFakulte;
  String? selectedBolum;
  String? selectedDonem;
  String? selectedDers;

  final Color primaryColor = const Color(0xFF5E35B1);
  final Color accentColor = const Color(0xFFFBC02D);
  final Color lightBlue = Colors.lightBlue.shade100;
  final Color lightGreen = Colors.lightGreen.shade100;

  final Map<String, Map<String, List<String>>> fakulteBolumDersEslemesi = {
    'Tüm Fakülteler': {
      'Tüm Bölümler': [
        'Tüm Dersler', 'İstatistik', 'Mikro İktisat', 'Veri Yapıları ve Algoritmalar', 'Nesne Yönelimli Programlama',
        'Siyaset Bilimine Giriş', 'Ceza Hukuku', 'Türk Edebiyatı Tarihi', 'Anatomi', 'Fizyoloji',
        'Temel Hemşirelik', 'Anesteziye Giriş', 'Algoritma ve Programlama', 'Yapay Zeka', 'Makine Öğrenimi',
        'Gelişim Psikolojisi', 'İnsan Hakları Hukuku', 'Türk İslam Edebiyatı', 'Biyoteknoloji', 'Nanoteknoloji',
      ],
    },
    'İktisadi ve İdari Bilimler Fakültesi': {
      'Tüm Bölümler': ['Tüm Dersler', 'İktisat', 'İşletme', 'Siyaset Bilimi ve Kamu Yönetimi', 'Uluslararası İlişkiler'],
      'İktisat': ['Tüm Dersler', 'Mikro İktisat', 'Makro İktisat', 'Ekonometri', 'İstatistik', 'Uluslararası Ticaret', 'Parasal İktisat', 'Oyun Teorisi', 'Maliye Politikası', 'Gelişme İktisadı'],
      'İşletme': ['Tüm Dersler', 'İşletme Yönetimi', 'Pazarlama İlkeleri', 'Muhasebe', 'Finansal Yönetim', 'Stratejik Yönetim', 'İnsan Kaynakları Yönetimi', 'Örgütsel Davranış', 'Üretim Yönetimi', 'İş Hukuku'],
      'Siyaset Bilimi ve Kamu Yönetimi': ['Tüm Dersler', 'Siyaset Bilimine Giriş', 'Anayasa Hukuku', 'Yerel Yönetimler', 'Türk Siyasal Hayatı', 'Siyasi Düşünceler Tarihi', 'Karşılaştırmalı Siyaset', 'İdari Yargı', 'Kamu Yönetimi'],
      'Uluslararası İlişkiler': ['Tüm Dersler', 'Uluslararası İlişkiler Teorileri', 'Diplomasi Tarihi', 'Küresel Ekonomi', 'Türk Dış Politikası', 'Uluslararası Hukuk', 'Güvenlik Politikaları', 'Savaş ve Barış Çalışmaları'],
    },
    'Mühendislik Fakültesi': {
      'Tüm Bölümler': ['Tüm Dersler', 'Bilgisayar Mühendisliği', 'Elektrik-Elektronik Mühendisliği', 'Makine Mühendisliği', 'İnşaat Mühendisliği', 'Biyomedikal Mühendisliği'],
      'Bilgisayar Mühendisliği': ['Tüm Dersler', 'Veri Yapıları ve Algoritmalar', 'Nesne Yönelimli Programlama', 'Veritabanı Yönetim Sistemleri', 'İşletim Sistemleri', 'Yazılım Mühendisliği', 'Bilgisayar Ağları', 'Yapay Zeka', 'Makine Öğrenimi', 'Mobil Uygulama Geliştirme'],
      'Elektrik-Elektronik Mühendisliği': ['Tüm Dersler', 'Devre Analizi', 'Elektronik Devreler', 'Sinyaller ve Sistemler', 'Kontrol Sistemleri', 'Mikroişlemciler', 'Sayisal Haberleşme', 'Güç Sistemleri'],
      'Makine Mühendisliği': ['Tüm Dersler', 'Termodinamik', 'Akışkanlar Mekaniği', 'Malzeme Bilimi', 'Dinamik', 'Mekanizma Tekniği', 'Isı Transferi', 'Titresim Analizi', 'Makine Elemanları'],
      'İnşaat Mühendisliği': ['Tüm Dersler', 'Statik', 'Mukavemet', 'Yapı Malzemeleri', 'Hidrolik', 'Zemin Mekaniği', 'Çelik Yapılar', 'Ulaştırma', 'Betonarme'],
      'Biyomedikal Mühendisliği': ['Tüm Dersler', 'Biyofizik', 'Tıbbi Görüntüleme', 'Biyomalzemeler', 'Biyosinyal İşleme', 'Biyomekanik', 'Rehabilitasyon Teknolojileri', 'Klinik Mühendislik'],
    },
    'Fen Edebiyat Fakültesi': {
      'Tüm Bölümler': ['Tüm Dersler', 'Matematik', 'Türk Dili ve Edebiyatı', 'Tarih', 'Sosyoloji', 'Psikoloji', 'Fizik', 'Kimya'],
      'Matematik': ['Tüm Dersler', 'Analiz I', 'Soyut Cebir', 'Diferansiyel Denklemler', 'Lineer Cebir', 'Olasılık ve İstatistik', 'Topoloji', 'Matematiksel Mantık'],
      'Türk Dili ve Edebiyatı': ['Tüm Dersler', 'Türk Edebiyatı Tarihi', 'Osmanlı Türkçesi', 'Eski Türk Edebiyatı', 'Yeni Türk Edebiyatı', 'Çağdaş Türk Lehçeleri', 'Halk Edebiyatı'],
      'Tarih': ['Tüm Dersler', 'Tarih Metodolojisi', 'Türk İnkılap Tarihi', 'Osmanlı Tarihi', 'Genel Dünya Tarihi', 'Yakınçağ Avrupa Tarihi', 'Bizans Tarihi'],
      'Sosyoloji': ['Tüm Dersler', 'Sosyolojiye Giriş', 'Toplumsal Araştırma Yöntemleri', 'Kent Sosyolojisi', 'Aile Sosyolojisi', 'Suç Sosyolojisi', 'Eğitim Sosyolojisi'],
      'Psikoloji': ['Tüm Dersler', 'Gelişim Psikolojisi', 'Bilişsel Psikoloji', 'Klinik Psikoloji', 'Sosyal Psikoloji', 'Psikopatoloji', 'Deneysel Psikoloji'],
      'Fizik': ['Tüm Dersler', 'Klasik Mekanik', 'Elektromanyetik Teori', 'Kuantum Fiziği', 'Termodinamik ve İstatistiksel Fizik', 'Optik'],
      'Kimya': ['Tüm Dersler', 'Genel Kimya', 'Organik Kimya', 'Anorganik Kimya', 'Fiziksel Kimya', 'Analitik Kimya', 'Biyokimya'],
    },
    'Eğitim Fakültesi': {
      'Tüm Bölümler': ['Tüm Dersler', 'Sınıf Öğretmenliği', 'İlköğretim Matematik Öğretmenliği', 'Fen Bilgisi Öğretmenliği'],
      'Sınıf Öğretmenliği': ['Tüm Dersler', 'Öğretim İlke ve Yöntemleri', 'Eğitim Psikolojisi', 'İlköğretim Programları', 'Özel Öğretim Yöntemleri', 'Sınıf Yönetimi', 'Türkçe Öğretimi'],
      'İlköğretim Matematik Öğretmenliği': ['Tüm Dersler', 'Matematik Öğretimi', 'Geometri', 'Soyut Matematik', 'Analitik Geometri', 'Olasılık ve İstatistik'],
      'Fen Bilgisi Öğretmenliği': ['Tüm Dersler', 'Fen Öğretimi', 'Biyoloji', 'Fizik', 'Kimya', 'Çevre Bilimi', 'Bilimsel Araştırma Yöntemleri'],
    },
    'Hukuk Fakültesi': {
      'Tüm Bölümler': ['Tüm Dersler', 'Hukuk'],
      'Hukuk': ['Tüm Dersler', 'Anayasa Hukuku', 'Ceza Hukuku', 'Medeni Hukuk', 'Borçlar Hukuku', 'İdare Hukuku', 'İnsan Hakları Hukuku', 'Milletlerarası Hukuk', 'Ticaret Hukuku'],
    },
    'Tıp Fakültesi': {
      'Tüm Bölümler': ['Tüm Dersler', 'Tıp'],
      'Tıp': ['Tüm Dersler', 'Anatomi', 'Fizyoloji', 'Biyokimya', 'Histoloji', 'Patoloji', 'Farmakoloji', 'Mikrobiyoloji', 'Cerrahi Bilimler', 'Dahili Tıp Bilimleri'],
    },
    'Diş Hekimliği Fakültesi': {
      'Tüm Bölümler': ['Tüm Dersler', 'Diş Hekimliği'],
      'Diş Hekimliği': ['Tüm Dersler', 'Ağız, Diş ve Çene Cerrahisi', 'Periodontoloji', 'Restoratif Diş Tedavisi', 'Protetik Diş Tedavisi', 'Endodonti', 'Ortodonti'],
    },
    'Sağlık Bilimleri Fakültesi': {
      'Tüm Bölümler': ['Tüm Dersler', 'Ebelik', 'Hemşirelik'],
      'Ebelik': ['Tüm Dersler', 'Kadın Sağlığı ve Hastalıkları', 'Doğum ve Doğum Sonrası Bakım', 'Yenidoğan Bakımı', 'Üreme Sağlığı'],
      'Hemşirelik': ['Tüm Dersler', 'Temel Hemşirelik', 'Cerrahi Hastalıklar Hemşireliği', 'İç Hastalıkları Hemşireliği', 'Ruh Sağlığı ve Hastalıkları Hemşireliği', 'Çocuk Sağlığı ve Hastalıkları Hemşireliği'],
    },
    'Meslek Yüksekokulu': {
      'Tüm Bölümler': ['Tüm Dersler', 'Anestezi', 'Bilgisayar Programcılığı', 'Elektronik Teknolojisi', 'Halkla İlişkiler ve Tanıtım', 'Makine Resim ve Konstrüksiyonu'],
      'Anestezi': ['Tüm Dersler', 'Anesteziye Giriş', 'Reanimasyon', 'Farmakoloji', 'Yoğun Bakım', 'İlk ve Acil Yardım'],
      'Bilgisayar Programcılığı': ['Tüm Dersler', 'Algoritma ve Programlama', 'Veritabanı', 'Web Tasarımı', 'Mobil Uygulama Geliştirme', 'Grafik ve Animasyon'],
      'Elektronik Teknolojisi': ['Tüm Dersler', 'Elektrik Devreleri', 'Elektronik Ölçme', 'Sayisal Elektronik', 'Mikrodenetleyiciler', 'Otomasyon'],
      'Halkla İlişkiler ve Tanıtım': ['Tüm Dersler', 'Halkla İlişkiler Teorisi', 'Reklamcılık', 'Medya İlişkileri', 'Pazarlama İletişimi', 'Kurumsal İletişim'],
      'Makine Resim ve Konstrüksiyonu': ['Tüm Dersler', 'Teknik Resim', 'Makine Elemanları', 'Autocad', 'Katı Modelleme', 'Tolerans ve Yüzey Kalitesi'],
    },
  };

  List<String> gosterilenBolumler = [];
  List<String> gosterilenDersler = [];
  final List<String> fakulteler = [
    'Tüm Fakülteler', 'İktisadi ve İdari Bilimler Fakültesi', 'Mühendislik Fakültesi',
    'Fen Edebiyat Fakültesi', 'Eğitim Fakültesi', 'Hukuk Fakültesi', 'Tıp Fakültesi',
    'Diş Hekimliği Fakültesi', 'Sağlık Bilimleri Fakültesi', 'Meslek Yüksekokulu',
  ];

  @override
  void initState() {
    super.initState();
    // Uygulama ilk açıldığında tüm bölümleri ve dersleri göster.
    gosterilenBolumler = fakulteBolumDersEslemesi['Tüm Fakülteler']!['Tüm Bölümler']!;
    gosterilenDersler = fakulteBolumDersEslemesi['Tüm Fakülteler']!['Tüm Bölümler']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ders Notları Yönetim Paneli',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showNotPaylasDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12.0),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Ders Notlarını Filtrele',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E35B1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFiltreDropdown(
                    label: 'Fakülte Seçin',
                    value: selectedFakulte,
                    items: fakulteler,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFakulte = newValue;
                        selectedBolum = null;
                        selectedDers = null;

                        if (newValue != null && fakulteBolumDersEslemesi.containsKey(newValue)) {
                          gosterilenBolumler = fakulteBolumDersEslemesi[newValue]!.keys.toList();
                          gosterilenDersler = fakulteBolumDersEslemesi[newValue]!['Tüm Bölümler'] ?? [];
                        } else {
                          gosterilenBolumler = fakulteBolumDersEslemesi['Tüm Fakülteler']!.keys.toList();
                          gosterilenDersler = fakulteBolumDersEslemesi['Tüm Fakülteler']!['Tüm Bölümler'] ?? [];
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildFiltreDropdown(
                    label: 'Bölüm Seçin',
                    value: selectedBolum,
                    items: gosterilenBolumler,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBolum = newValue;
                        selectedDers = null;
                        if (selectedFakulte != null && newValue != null && fakulteBolumDersEslemesi[selectedFakulte]!.containsKey(newValue)) {
                          gosterilenDersler = fakulteBolumDersEslemesi[selectedFakulte]![newValue]!;
                        } else {
                          gosterilenDersler = fakulteBolumDersEslemesi[selectedFakulte]!['Tüm Bölümler'] ?? [];
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildFiltreDropdown(
                    label: 'Dönem Seçin',
                    value: selectedDonem,
                    items: const [
                      'Tüm Dönemler',
                      'Güz',
                      'Bahar',
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDonem = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildFiltreDropdown(
                    label: 'Ders Seçin',
                    value: selectedDers,
                    items: gosterilenDersler,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDers = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildQuery().snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Veri çekme hatası! Lütfen Firebase dizinlerini kontrol edin.'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Ders notu bulunamadı.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    var data = doc.data() as Map<String, dynamic>;
                    return _buildNotKarti(doc.id, data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltreDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: value,
      items: items.map((String val) {
        return DropdownMenuItem<String>(
          value: val.startsWith('Tüm') ? null : val,
          child: Text(
            val,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black87),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Query _buildQuery() {
    Query query = _firestore.collection('ders_notlari').orderBy('eklenme_tarihi', descending: true);

    if (selectedFakulte != null) {
      query = query.where('fakulte', isEqualTo: selectedFakulte);
    }

    if (selectedBolum != null) {
      query = query.where('bolum', isEqualTo: selectedBolum);
    }

    if (selectedDonem != null) {
      query = query.where('donem', isEqualTo: selectedDonem);
    }

    if (selectedDers != null) {
      query = query.where('ders_adi', isEqualTo: selectedDers);
    }

    return query;
  }

  Widget _buildNotKarti(String docId, Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          // Kartın tıklanma aksiyonu (Admin için düzenleme)
          _showEditNoteDialog(docId, data);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade200, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data['bolum'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E35B1),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Chip(
                      label: Text(data['donem']),
                      backgroundColor: data['donem'] == 'Güz' ? lightGreen : lightBlue,
                      labelStyle: TextStyle(
                        color: data['donem'] == 'Güz' ? Colors.green[800] : Colors.blue[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    data['ders_adi'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.school, color: primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Fakülte: ${data['fakulte']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.assessment, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Sınav Türü: ${data['sinav_turu']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (data['aciklama'] != null && data['aciklama'].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description, color: primaryColor),
                          const SizedBox(width: 8),
                          const Text(
                            'Açıklama:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, top: 4),
                        child: Text(
                          data['aciklama'],
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                if (data['pdf_url'] != null && data['pdf_url'].isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('PDF Görüntüle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 4,
                      ),
                      onPressed: () async {
                        // PDF Görüntüleme fonksiyonu
                      },
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditNoteDialog(docId, data),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteNote(docId),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteNote(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          elevation: 10,
          title: const Text(
            'Notu Sil',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text(
            'Bu ders notunu silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'İPTAL',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _firestore.collection('ders_notlari').doc(docId).delete();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Not başarıyla silindi.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hata oluştu: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
              ),
              child: const Text('SİL'),
            ),
          ],
          actionsAlignment: MainAxisAlignment.end,
        );
      },
    );
  }


  void _showEditNoteDialog(String docId, Map<String, dynamic> data) {
    final _aciklamaController = TextEditingController(text: data['aciklama'] ?? '');
    final _pdfUrlController = TextEditingController(text: data['pdf_url'] ?? '');
    String? selectedFakulteToEdit = data['fakulte'];
    String? selectedBolumToEdit = data['bolum'];
    String? selectedDersToEdit = data['ders_adi'];
    String? selectedDonemToEdit = data['donem'];

    // Fakülteye göre bölümleri doğru şekilde getir
    List<String> gosterilenBolumlerToEdit = fakulteBolumDersEslemesi[selectedFakulteToEdit!]!.keys.toList();
    // Bölüme göre dersleri doğru şekilde getir
    List<String> gosterilenDerslerToEdit = fakulteBolumDersEslemesi[selectedFakulteToEdit]![selectedBolumToEdit] ?? [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              contentPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: const Text(
                  'Ders Notunu Düzenle',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFiltreDropdown(
                      label: 'Fakülte Seçin',
                      value: selectedFakulteToEdit,
                      items: fakulteler,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFakulteToEdit = newValue;
                          selectedBolumToEdit = null;
                          selectedDersToEdit = null;
                          if (newValue != null && fakulteBolumDersEslemesi.containsKey(newValue)) {
                            gosterilenBolumlerToEdit = fakulteBolumDersEslemesi[newValue]!.keys.toList();
                            gosterilenDerslerToEdit = fakulteBolumDersEslemesi[newValue]!['Tüm Bölümler'] ?? [];
                          } else {
                            gosterilenBolumlerToEdit = fakulteBolumDersEslemesi['Tüm Fakülteler']!.keys.toList();
                            gosterilenDerslerToEdit = fakulteBolumDersEslemesi['Tüm Fakülteler']!['Tüm Bölümler'] ?? [];
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildFiltreDropdown(
                      label: 'Bölüm Seçin',
                      value: selectedBolumToEdit,
                      items: gosterilenBolumlerToEdit,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBolumToEdit = newValue;
                          selectedDersToEdit = null;
                          if (selectedFakulteToEdit != null && newValue != null && fakulteBolumDersEslemesi[selectedFakulteToEdit]!.containsKey(newValue)) {
                            gosterilenDerslerToEdit = fakulteBolumDersEslemesi[selectedFakulteToEdit]![newValue]!;
                          } else {
                            gosterilenDerslerToEdit = fakulteBolumDersEslemesi[selectedFakulteToEdit]!['Tüm Bölümler'] ?? [];
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildFiltreDropdown(
                      label: 'Ders Seçin',
                      value: selectedDersToEdit,
                      items: gosterilenDerslerToEdit,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDersToEdit = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildFiltreDropdown(
                      label: 'Dönem Seçin',
                      value: selectedDonemToEdit,
                      items: const ['Güz', 'Bahar'],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDonemToEdit = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _aciklamaController,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'Açıklama (isteğe bağlı)',
                        labelStyle: TextStyle(color: Colors.grey.shade700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        prefixIcon: Icon(Icons.description, color: primaryColor),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _pdfUrlController,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'PDF URL\'si (Gerekli)',
                        labelStyle: TextStyle(color: Colors.grey.shade700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        prefixIcon: Icon(Icons.link, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('İptal'),
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red[600],
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  child: const Text('Kaydet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    if (selectedFakulteToEdit != null && selectedBolumToEdit != null && selectedDersToEdit != null && selectedDonemToEdit != null && _pdfUrlController.text.isNotEmpty) {
                      try {
                        await _firestore.collection('ders_notlari').doc(docId).update({
                          'fakulte': selectedFakulteToEdit,
                          'bolum': selectedBolumToEdit,
                          'ders_adi': selectedDersToEdit,
                          'aciklama': _aciklamaController.text,
                          'donem': selectedDonemToEdit,
                          'pdf_url': _pdfUrlController.text,
                          'eklenme_tarihi': Timestamp.now(),
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Not başarıyla güncellendi.')),
                        );
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Hata oluştu: $e')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lütfen tüm alanları doldurunuz.')),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showNotPaylasDialog(BuildContext context) {
    final _aciklamaController = TextEditingController();
    final _pdfUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        String? selectedFakulteToShare;
        String? selectedBolumToShare;
        String? selectedDersToShare;
        String? selectedDonemToShare;
        List<String> gosterilenBolumlerToShare = fakulteBolumDersEslemesi['Tüm Fakülteler']!.keys.toList();
        List<String> gosterilenDerslerToShare = [];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              contentPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: const Text(
                  'Yeni Not Paylaş',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Yeni bir ders notu eklemek için formu doldurun.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    _buildFiltreDropdown(
                      label: 'Fakülte Seçin',
                      value: selectedFakulteToShare,
                      items: fakulteler,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFakulteToShare = newValue;
                          selectedBolumToShare = null;
                          selectedDersToShare = null;
                          if (newValue != null && fakulteBolumDersEslemesi.containsKey(newValue)) {
                            gosterilenBolumlerToShare = fakulteBolumDersEslemesi[newValue]!.keys.toList();
                            gosterilenDerslerToShare = fakulteBolumDersEslemesi[newValue]!['Tüm Bölümler'] ?? [];
                          } else {
                            gosterilenBolumlerToShare = fakulteBolumDersEslemesi['Tüm Fakülteler']!.keys.toList();
                            gosterilenDerslerToShare = fakulteBolumDersEslemesi['Tüm Fakülteler']!['Tüm Bölümler'] ?? [];
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildFiltreDropdown(
                      label: 'Bölüm Seçin',
                      value: selectedBolumToShare,
                      items: gosterilenBolumlerToShare,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBolumToShare = newValue;
                          selectedDersToShare = null;
                          if (selectedFakulteToShare != null && newValue != null && fakulteBolumDersEslemesi[selectedFakulteToShare]!.containsKey(newValue)) {
                            gosterilenDerslerToShare = fakulteBolumDersEslemesi[selectedFakulteToShare]![newValue]!;
                          } else {
                            gosterilenDerslerToShare = fakulteBolumDersEslemesi[selectedFakulteToShare]!['Tüm Bölümler'] ?? [];
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildFiltreDropdown(
                      label: 'Ders Seçin',
                      value: selectedDersToShare,
                      items: gosterilenDerslerToShare,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDersToShare = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildFiltreDropdown(
                      label: 'Dönem Seçin',
                      value: selectedDonemToShare,
                      items: const ['Güz', 'Bahar'],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDonemToShare = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _aciklamaController,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'Açıklama (isteğe bağlı)',
                        labelStyle: TextStyle(color: Colors.grey.shade700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        prefixIcon: Icon(Icons.description, color: primaryColor),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _pdfUrlController,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'PDF URL\'si (Gerekli)',
                        labelStyle: TextStyle(color: Colors.grey.shade700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        prefixIcon: Icon(Icons.link, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('İptal'),
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red[600],
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  child: const Text('Gönder'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    if (selectedFakulteToShare != null && selectedBolumToShare != null && selectedDersToShare != null && selectedDonemToShare != null && _pdfUrlController.text.isNotEmpty) {
                      try {
                        await _firestore.collection('ders_notlari').add({
                          'fakulte': selectedFakulteToShare,
                          'bolum': selectedBolumToShare,
                          'ders_adi': selectedDersToShare,
                          'aciklama': _aciklamaController.text,
                          'donem': selectedDonemToShare,
                          'sinav_turu': 'Vize', // Ornek deger
                          'pdf_url': _pdfUrlController.text,
                          'eklenme_tarihi': Timestamp.now(),
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Notunuz başarıyla eklendi.')),
                        );
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Hata oluştu: $e')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Lütfen tüm gerekli alanları doldurunuz.')),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}