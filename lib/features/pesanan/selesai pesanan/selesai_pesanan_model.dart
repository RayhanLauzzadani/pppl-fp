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
}

class Pesanan {
  final String noNota;
  final String nama;
  final String noHp;
  final String tipe;
  final int kg;
  final int pcs;
  String status; // BUKAN FINAL!
  final DateTime tanggalTerima;
  final DateTime tanggalSelesai;
  final String jenisParfum;
  final String antarJemput;
  final int totalBayar;
  final List<LaundryItem> listLaundry;

  Pesanan({
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

  Pesanan copyWith({
    String? status,
  }) {
    return Pesanan(
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
}
