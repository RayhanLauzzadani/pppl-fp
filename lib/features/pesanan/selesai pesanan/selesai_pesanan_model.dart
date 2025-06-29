import 'package:cloud_firestore/cloud_firestore.dart';

// ===========================
// Model LaundryItem
// ===========================
class LaundryItem {
  final String nama;
  final String tipe;
  final int jumlah;
  final int harga;
  final int hargaTotal;

  LaundryItem({
    required this.nama,
    required this.tipe,
    required this.jumlah,
    required this.harga,
    required this.hargaTotal,
  });

  factory LaundryItem.fromMap(Map<String, dynamic> map) {
    return LaundryItem(
      nama: map['nama'] ?? '',
      tipe: map['tipe'] ?? '',
      jumlah: (map['jumlah'] as num?)?.toInt() ?? 0,
      harga: (map['harga'] as num?)?.toInt() ?? 0,
      hargaTotal: (map['hargaTotal'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'tipe': tipe,
      'jumlah': jumlah,
      'harga': harga,
      'hargaTotal': hargaTotal,
    };
  }
}

// ===========================
// Model Pesanan (FINAL FIRESTORE)
// ===========================
class Pesanan {
  final String id; // Firestore Document ID
  final String kodeLaundry; // TAMBAHKAN INI!
  final String noNota;
  final String nama;
  final String noHp;
  final String tipe;
  final double kg;
  final int pcs;
  String status; // Bisa diedit lewat copyWith
  final DateTime? tanggalTerima;
  final DateTime? tanggalSelesai;
  final String jenisParfum;
  final String antarJemput;
  final int totalBayar;
  final List<LaundryItem> listLaundry;

  Pesanan({
    required this.id,
    required this.kodeLaundry, // TAMBAHKAN INI!
    required this.noNota,
    required this.nama,
    required this.noHp,
    required this.tipe,
    required this.kg,
    required this.pcs,
    required this.status,
    required this.tanggalTerima,
    required this.tanggalSelesai,
    required this.jenisParfum,
    required this.antarJemput,
    required this.totalBayar,
    required this.listLaundry,
  });

  // FACTORY dari Firestore Document
  factory Pesanan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Pesanan(
      id: doc.id,
      kodeLaundry: data['kodeLaundry'] ?? '', // PASTIKAN FIELD INI ADA di Firestore!
      noNota: data['noNota'] ?? '',
      nama: data['nama'] ?? '',
      noHp: data['noHp'] ?? '',
      tipe: data['tipe'] ?? '',
      kg: (data['kg'] as num?)?.toDouble() ?? 0.0,
      pcs: (data['pcs'] as num?)?.toInt() ?? 0,
      status: data['status'] ?? '',
      tanggalTerima: (data['tanggalTerima'] as Timestamp?)?.toDate(),
      tanggalSelesai: (data['tanggalSelesai'] as Timestamp?)?.toDate(),
      jenisParfum: data['jenisParfum'] ?? '',
      antarJemput: data['antarJemput'] ?? '',
      totalBayar: (data['totalBayar'] as num?)?.toInt() ?? 0,
      listLaundry: (data['listLaundry'] as List<dynamic>? ?? [])
          .map((item) => LaundryItem.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Pesanan copyWith({
    String? status,
    String? kodeLaundry, // Agar flexible, walau biasanya tidak perlu diubah
  }) {
    return Pesanan(
      id: id,
      kodeLaundry: kodeLaundry ?? this.kodeLaundry,
      noNota: noNota,
      nama: nama,
      noHp: noHp,
      tipe: tipe,
      kg: kg,
      pcs: pcs,
      status: status ?? this.status,
      tanggalTerima: tanggalTerima,
      tanggalSelesai: tanggalSelesai,
      jenisParfum: jenisParfum,
      antarJemput: antarJemput,
      totalBayar: totalBayar,
      listLaundry: listLaundry,
    );
  }

  // Untuk upload/update Firestore
  Map<String, dynamic> toMap() {
    return {
      'kodeLaundry': kodeLaundry, // PASTIKAN DISIMPAN
      'noNota': noNota,
      'nama': nama,
      'noHp': noHp,
      'tipe': tipe,
      'kg': kg,
      'pcs': pcs,
      'status': status,
      'tanggalTerima': tanggalTerima,
      'tanggalSelesai': tanggalSelesai,
      'jenisParfum': jenisParfum,
      'antarJemput': antarJemput,
      'totalBayar': totalBayar,
      'listLaundry': listLaundry.map((item) => item.toMap()).toList(),
    };
  }
}
