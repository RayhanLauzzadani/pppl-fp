import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PesananRiwayat {
  final String nota;
  final String nama;
  final String tipe;
  final DateTime tanggalMasuk;
  final DateTime tanggalSelesai;
  final int total;
  final String pembayaran;
  final String status;

  PesananRiwayat({
    required this.nota,
    required this.nama,
    required this.tipe,
    required this.tanggalMasuk,
    required this.tanggalSelesai,
    required this.total,
    required this.pembayaran,
    required this.status,
  });
}

class RiwayatPesananPage extends StatefulWidget {
  const RiwayatPesananPage({super.key});

  @override
  State<RiwayatPesananPage> createState() => _RiwayatPesananPageState();
}

class _RiwayatPesananPageState extends State<RiwayatPesananPage> {
  final TextEditingController searchController = TextEditingController();

  final List<PesananRiwayat> semuaPesanan = [
    PesananRiwayat(
      nota: "1157.1909.21",
      nama: "Budi",
      tipe: "Reguler",
      tanggalMasuk: DateTime(2024, 9, 3, 19, 37),
      tanggalSelesai: DateTime(2024, 9, 7, 9, 21),
      total: 50000,
      pembayaran: "Lunas - Tunai",
      status: "selesai",
    ),
    PesananRiwayat(
      nota: "1156.1909.23",
      nama: "Joko",
      tipe: "Ekspress",
      tanggalMasuk: DateTime(2024, 9, 3, 19, 37),
      tanggalSelesai: DateTime(2024, 9, 7, 9, 21),
      total: 50000,
      pembayaran: "Lunas - Tunai",
      status: "selesai",
    ),
    PesananRiwayat(
      nota: "1155.1809.21",
      nama: "Siti",
      tipe: "Reguler",
      tanggalMasuk: DateTime(2024, 9, 3, 19, 37),
      tanggalSelesai: DateTime(2024, 9, 7, 9, 21),
      total: 50000,
      pembayaran: "Lunas - Tunai",
      status: "selesai",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<PesananRiwayat> riwayatList = semuaPesanan
        .where((e) => e.status == 'selesai')
        .toList()
      ..sort((a, b) => b.tanggalSelesai.compareTo(a.tanggalSelesai));

    String q = searchController.text.toLowerCase();
    if (q.isNotEmpty) {
      riwayatList = riwayatList.where((p) {
        return p.nama.toLowerCase().contains(q) ||
            p.nota.toLowerCase().contains(q) ||
            DateFormat('dd/MM/yyyy').format(p.tanggalMasuk).contains(q) ||
            DateFormat('dd/MM/yyyy').format(p.tanggalSelesai).contains(q);
      }).toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 42, left: 0, right: 0, bottom: 22),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF40A2E3),
                  Color(0xFFBBE2EC),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Riwayat Pesanan",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 7),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.13),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (v) => setState(() {}),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black54, size: 24),
                  hintText: "Cari nama / nota / tanggal",
                  hintStyle: TextStyle(fontFamily: "Poppins", color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: riwayatList.length,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              separatorBuilder: (_, __) => const SizedBox(height: 7),
              itemBuilder: (context, idx) {
                final p = riwayatList[idx];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFBBE2EC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.shopping_basket_outlined, color: Color(0xFF40A2E3), size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nota–${p.nota} ${p.tipe}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                            Text(
                              "Masuk: ${DateFormat('dd/MM/yyyy – HH:mm').format(p.tanggalMasuk)}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                fontSize: 12.2,
                              ),
                            ),
                            Text(
                              "Selesai: ${DateFormat('dd/MM/yyyy – HH:mm').format(p.tanggalSelesai)}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                fontSize: 12.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Rp ${p.total.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 14.2,
                            ),
                          ),
                          Text(
                            p.pembayaran,
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 12.1,
                              fontStyle: FontStyle.italic,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
