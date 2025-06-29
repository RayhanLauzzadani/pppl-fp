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
  final String kodeLaundry;
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
    required this.kodeLaundry,
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

    // =========== AMBIL DATA KG ==========
    final double beratKg = (data['kg'] ?? data['beratKg']) is num
        ? (data['kg'] ?? data['beratKg']).toDouble()
        : 0.0;

    // =========== HITUNG PCS ==========
    int totalPcs = 0;
    if (data['pcs'] is num) {
      totalPcs = data['pcs'].toInt();
    } else {
      // PCS dari barangQty
      if (data['barangQty'] is Map) {
        final barangQty = Map<String, dynamic>.from(data['barangQty']);
        totalPcs += barangQty.values
            .map((v) => v is num ? v.toInt() : 0)
            .fold(0, (a, b) => a + b);
      }
      // PCS dari jumlah layananTipe = Satuan
      if (data['jumlah'] is Map && data['layananTipe'] is Map) {
        final tipeMap = Map<String, dynamic>.from(data['layananTipe']);
        final jumlahMap = Map<String, dynamic>.from(data['jumlah']);
        jumlahMap.forEach((nama, qty) {
          if ((tipeMap[nama]?.toString().toLowerCase() ?? '') == 'satuan') {
            if (qty is num) totalPcs += qty.toInt();
          }
        });
      }
    }

    // =========== BUILD LAUNDRY LIST ==========
    List<LaundryItem> laundryList = [];

    // Laundry Kiloan
    if (beratKg > 0) {
      int hargaKiloan = (data['hargaKiloan'] is num)
          ? data['hargaKiloan'].toInt()
          : 0;
      laundryList.add(
        LaundryItem(
          nama: 'Laundry Kiloan',
          tipe: 'Kiloan',
          jumlah: beratKg.toInt(),
          harga: hargaKiloan,
          hargaTotal: hargaKiloan * beratKg.toInt(),
        ),
      );
    }

    // Dari jumlah layanan (jenis layanan dari jumlah + tipe + harga)
    if (data['jumlah'] is Map && data['layananTipe'] is Map) {
      final jumlahMap = Map<String, dynamic>.from(data['jumlah']);
      final hargaMap = Map<String, dynamic>.from(data['hargaLayanan'] ?? {});
      final tipeMap = Map<String, dynamic>.from(data['layananTipe'] ?? {});
      jumlahMap.forEach((nama, qty) {
        if (qty is num && qty > 0) {
          final harga = (hargaMap[nama] is num) ? hargaMap[nama].toInt() : 0;
          laundryList.add(
            LaundryItem(
              nama: nama,
              tipe: (tipeMap[nama] ?? '').toString(),
              jumlah: qty.toInt(),
              harga: harga,
              hargaTotal: harga * qty.toInt(),
            ),
          );
        }
      });
    }

    // Barang custom
    if (data['barangQty'] is Map && data['barangList'] is List) {
      final barangQty = Map<String, dynamic>.from(data['barangQty']);
      final barangList = List<Map<String, dynamic>>.from(data['barangList']);
      for (var item in barangList) {
        final nama = item['title'] ?? '';
        final qty = (barangQty[nama] is num) ? barangQty[nama].toInt() : 0;
        if (qty > 0) {
          laundryList.add(
            LaundryItem(
              nama: nama,
              tipe: 'Satuan',
              jumlah: qty,
              harga: 0,
              hargaTotal: 0,
            ),
          );
        }
      }
    }

    // Fallback ke listLaundry lama jika ada (data migrasi baru)
    if (data['listLaundry'] is List && data['listLaundry'].isNotEmpty) {
      laundryList = List<Map<String, dynamic>>.from(
        data['listLaundry'],
      ).map((item) => LaundryItem.fromMap(item)).toList();
    }

    return Pesanan(
      id: doc.id,
      kodeLaundry: data['kodeLaundry'] ?? '',
      noNota: data['noNota'] ?? '',
      nama: data['nama'] ?? '',
      noHp: data['noHp'] ?? '',
      tipe: data['tipe'] ?? data['desc'] ?? '',
      kg: beratKg,
      pcs: totalPcs,
      status: data['status'] ?? '',
      tanggalTerima: (data['tanggalTerima'] is Timestamp)
          ? (data['tanggalTerima'] as Timestamp).toDate()
          : null,
      tanggalSelesai: (data['tanggalSelesai'] is Timestamp)
          ? (data['tanggalSelesai'] as Timestamp).toDate()
          : null,
      jenisParfum: data['jenisParfum']?.toString() ?? '',
      antarJemput: data['antarJemput']?.toString() ?? '',
      totalBayar: (data['totalBayar'] is num)
          ? data['totalBayar'].toInt()
          : (data['totalHarga'] is num)
          ? data['totalHarga'].toInt()
          : 0,
      listLaundry: laundryList,
    );
  }

  Pesanan copyWith({String? status, String? kodeLaundry}) {
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

  Map<String, dynamic> toMap() {
    return {
      'kodeLaundry': kodeLaundry,
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
