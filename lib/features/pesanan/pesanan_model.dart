import 'package:cloud_firestore/cloud_firestore.dart';

class Pesanan {
  final String id;
  final String nama;
  final String whatsapp;
  final String layanan;   // (misal: 5 Hari, dst)
  final String desc;      // (misal: Reguler, dst)
  final String status;
  final double beratKg;
  final Map<String, int> barangQty;
  final List<Map<String, dynamic>> barangList;
  final int totalHarga;
  final String? kodeLaundry;
  final String? jenisParfum;
  final String? antarJemput;
  final String? diskon;
  final String? catatan;
  final int? hargaKiloan;
  final Map<String, int>? hargaLayanan;
  final Map<String, String>? layananTipe;
  final DateTime? createdAt;

  Pesanan({
    required this.id,
    required this.nama,
    required this.whatsapp,
    required this.layanan,
    required this.desc,
    required this.status,
    required this.beratKg,
    required this.barangQty,
    required this.barangList,
    required this.totalHarga,
    this.kodeLaundry,
    this.jenisParfum,
    this.antarJemput,
    this.diskon,
    this.catatan,
    this.hargaKiloan,
    this.hargaLayanan,
    this.layananTipe,
    this.createdAt,
  });

  /// Getter: Total PCS dihitung dari barangQty
  int get pcs => barangQty.values.fold(0, (a, b) => a + b);

  factory Pesanan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Pesanan(
      id: doc.id,
      nama: data['nama'] ?? '',
      whatsapp: data['whatsapp'] ?? '',
      layanan: data['layanan'] ?? '',
      desc: data['desc'] ?? '',
      status: data['status'] ?? 'belum_mulai',
      beratKg: (data['beratKg'] as num?)?.toDouble() ?? 0.0,
      barangQty: (data['barangQty'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num).toInt())) ?? {},
      barangList: (data['barangList'] as List?)?.map((item) => Map<String, dynamic>.from(item as Map)).toList() ?? [],
      totalHarga: (data['totalHarga'] as num?)?.toInt() ?? 0,
      kodeLaundry: data['kodeLaundry'],
      jenisParfum: data['jenisParfum'],
      antarJemput: data['antarJemput'],
      diskon: data['diskon'],
      catatan: data['catatan'],
      hargaKiloan: (data['hargaKiloan'] as num?)?.toInt(),
      hargaLayanan: (data['hargaLayanan'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
      layananTipe: (data['layananTipe'] as Map?)?.map((k, v) => MapEntry(k.toString(), v.toString())),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Pesanan copyWith({
    String? id,
    String? nama,
    String? whatsapp,
    String? layanan,
    String? desc,
    String? status,
    double? beratKg,
    Map<String, int>? barangQty,
    List<Map<String, dynamic>>? barangList,
    int? totalHarga,
    String? kodeLaundry,
    String? jenisParfum,
    String? antarJemput,
    String? diskon,
    String? catatan,
    int? hargaKiloan,
    Map<String, int>? hargaLayanan,
    Map<String, String>? layananTipe,
    DateTime? createdAt,
  }) {
    return Pesanan(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      whatsapp: whatsapp ?? this.whatsapp,
      layanan: layanan ?? this.layanan,
      desc: desc ?? this.desc,
      status: status ?? this.status,
      beratKg: beratKg ?? this.beratKg,
      barangQty: barangQty ?? this.barangQty,
      barangList: barangList ?? this.barangList,
      totalHarga: totalHarga ?? this.totalHarga,
      kodeLaundry: kodeLaundry ?? this.kodeLaundry,
      jenisParfum: jenisParfum ?? this.jenisParfum,
      antarJemput: antarJemput ?? this.antarJemput,
      diskon: diskon ?? this.diskon,
      catatan: catatan ?? this.catatan,
      hargaKiloan: hargaKiloan ?? this.hargaKiloan,
      hargaLayanan: hargaLayanan ?? this.hargaLayanan,
      layananTipe: layananTipe ?? this.layananTipe,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
