class Pesanan {
  final String nama;
  final String noHp;
  final String tipe;
  final int kg;
  final int pcs;
  final String status;
  final DateTime tanggal;

  Pesanan({
    required this.nama,
    required this.noHp,
    required this.tipe,
    required this.kg,
    required this.pcs,
    required this.status,
    required this.tanggal,
  });

  // Tambahkan copyWith:
  Pesanan copyWith({
    String? nama,
    String? noHp,
    String? tipe,
    int? kg,
    int? pcs,
    String? status,
    DateTime? tanggal,
  }) {
    return Pesanan(
      nama: nama ?? this.nama,
      noHp: noHp ?? this.noHp,
      tipe: tipe ?? this.tipe,
      kg: kg ?? this.kg,
      pcs: pcs ?? this.pcs,
      status: status ?? this.status,
      tanggal: tanggal ?? this.tanggal,
    );
  }
}
