import 'package:cloud_firestore/cloud_firestore.dart';

// LaundryItem class (tetap bisa dipakai untuk breakdown layanan)
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

// Pesanan class
class Pesanan {
  final String id;
  final String nama;
  final String whatsapp;
  final String layanan; // contoh: 5 Hari
  final String desc;    // contoh: Reguler

  final String statusProses;     // "belum_mulai" | "proses" | "selesai"
  final String statusTransaksi;  // "belum_bayar" | "belum_diambil" | "sudah_diambil"

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
  final Map<String, int>? jumlah;
  final DateTime? createdAt;
  final DateTime? tanggalSelesai; // <--- Tambahkan field ini!

  Pesanan({
    required this.id,
    required this.nama,
    required this.whatsapp,
    required this.layanan,
    required this.desc,
    required this.statusProses,
    required this.statusTransaksi,
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
    this.jumlah,
    this.createdAt,
    this.tanggalSelesai, // <-- Pastikan ini ada
  });

  int get pcs => barangQty.values.fold(0, (a, b) => a + b);

  // Getter untuk laundryItems (list layanan breakdown)
  List<LaundryItem> get laundryItems {
    final List<LaundryItem> items = [];

    // Laundry Kiloan
    if ((beratKg) > 0 && hargaKiloan != null && hargaKiloan! > 0) {
      items.add(
        LaundryItem(
          nama: "Laundry Kiloan",
          tipe: "Kiloan",
          jumlah: beratKg.toInt(),
          harga: hargaKiloan ?? 0,
          hargaTotal: (hargaKiloan ?? 0) * beratKg.toInt(),
        ),
      );
    }

    // Dari jumlah layanan
    if (jumlah != null && layananTipe != null && hargaLayanan != null) {
      jumlah!.forEach((nama, qty) {
        if (qty > 0) {
          items.add(
            LaundryItem(
              nama: nama,
              tipe: layananTipe![nama] ?? '',
              jumlah: qty,
              harga: hargaLayanan![nama] ?? 0,
              hargaTotal: (hargaLayanan![nama] ?? 0) * qty,
            ),
          );
        }
      });
    }

    // Barang custom/satuan
    if (barangQty.isNotEmpty && barangList.isNotEmpty) {
      for (final barang in barangList) {
        final nama = barang['title'] ?? barang['nama'] ?? '';
        final qty = barangQty[nama] ?? 0;
        if (qty > 0) {
          items.add(
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

    return items;
  }

  factory Pesanan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Pesanan(
      id: doc.id,
      nama: data['nama'] ?? '',
      whatsapp: data['whatsapp'] ?? '',
      layanan: data['layanan'] ?? '',
      desc: data['desc'] ?? '',
      statusProses: data['statusProses'] ?? data['status'] ?? 'belum_mulai',
      statusTransaksi: data['statusTransaksi'] ?? 'belum_bayar',
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
      jumlah: (data['jumlah'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      tanggalSelesai: (data['tanggalSelesai'] as Timestamp?)?.toDate(), // <-- load dari firestore juga!
    );
  }

  Pesanan copyWith({
    String? id,
    String? nama,
    String? whatsapp,
    String? layanan,
    String? desc,
    String? statusProses,
    String? statusTransaksi,
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
    Map<String, int>? jumlah,
    DateTime? createdAt,
    DateTime? tanggalSelesai, // tambahin juga di sini
  }) {
    return Pesanan(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      whatsapp: whatsapp ?? this.whatsapp,
      layanan: layanan ?? this.layanan,
      desc: desc ?? this.desc,
      statusProses: statusProses ?? this.statusProses,
      statusTransaksi: statusTransaksi ?? this.statusTransaksi,
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
      jumlah: jumlah ?? this.jumlah,
      createdAt: createdAt ?? this.createdAt,
      tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
    );
  }
}
