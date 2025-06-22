import 'detail_pesanan_selesai_page.dart';
import 'package:flutter/material.dart';

// Import model pesanan, samakan dengan proses
// import 'package:laundryin/features/pesanan/pesanan_model.dart';

class Pesanan {
  final String nama;
  final String tipe;
  final int kg;
  final int pcs;
  final String status; // "belum_diambil", "belum_bayar", "sudah_diambil"
  final DateTime tanggal;
  final bool ekspres;

  Pesanan({
    required this.nama,
    required this.tipe,
    required this.kg,
    required this.pcs,
    required this.status,
    required this.tanggal,
    this.ekspres = false,
  });
}

class SelesaiPesananPage extends StatefulWidget {
  const SelesaiPesananPage({super.key});

  @override
  State<SelesaiPesananPage> createState() => _SelesaiPesananPageState();
}

class _SelesaiPesananPageState extends State<SelesaiPesananPage> {
  String search = "";

  final List<Pesanan> pesananList = [
    Pesanan(
      nama: 'Farhan Laksono',
      tipe: 'Reguler',
      kg: 7,
      pcs: 8,
      status: 'belum_diambil',
      tanggal: DateTime(2024, 6, 12, 9, 0),
    ),
    Pesanan(
      nama: 'Habibullah Adilah P',
      tipe: 'Reguler',
      kg: 6,
      pcs: 9,
      status: 'belum_bayar',
      tanggal: DateTime(2024, 6, 8, 15, 0),
    ),
    Pesanan(
      nama: 'Pak Fazzle Ariwica',
      tipe: 'Ekspress',
      kg: 2,
      pcs: 3,
      status: 'sudah_diambil',
      tanggal: DateTime(2024, 6, 7, 14, 30),
      ekspres: true,
    ),
    Pesanan(
      nama: 'Pak Kresnadana Liu',
      tipe: 'Reguler',
      kg: 10,
      pcs: 11,
      status: 'belum_diambil',
      tanggal: DateTime(2024, 6, 9, 18, 45),
    ),
    Pesanan(
      nama: 'Bu Kim Suili Cak Lo',
      tipe: 'Reguler',
      kg: 9,
      pcs: 8,
      status: 'sudah_diambil',
      tanggal: DateTime(2024, 6, 6, 12, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final countBelumDiambil = pesananList
        .where((e) => e.status == 'belum_diambil')
        .length;
    final countBelumBayar = pesananList
        .where((e) => e.status == 'belum_bayar')
        .length;
    final countSudahDiambil = pesananList
        .where((e) => e.status == 'sudah_diambil')
        .length;

    final filteredList = pesananList
        .where((p) => p.nama.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER & GRADIENT — mengikuti ProsesPesananPage
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.01, 0.38, 0.83],
                colors: [
                  Color(0xFFFFF6E9),
                  Color(0xFFBBE2EC),
                  Color(0xFF40A2E3),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 42,
              left: 0,
              right: 0,
              bottom: 26,
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black87,
                          size: 22,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Pesanan Selesai",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 44),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.70),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.11),
                          blurRadius: 18,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _statusTab(
                          icon: Icons.help_outline_rounded,
                          iconColor: Color(0xFF52E18C),
                          count: countBelumDiambil,
                          label: "Belum Diambil",
                        ),
                        const SizedBox(width: 13),
                        _statusTab(
                          icon: Icons.close_rounded,
                          iconColor: Color(0xFFFF6A6A),
                          count: countBelumBayar,
                          label: "Belum Bayar",
                        ),
                        const SizedBox(width: 13),
                        _statusTab(
                          icon: Icons.done_all_rounded,
                          iconColor: Color(0xFF40A2E3),
                          count: countSudahDiambil,
                          label: "Sudah Diambil",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 19),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6E9),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.19),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) => setState(() => search = value),
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.black54,
                            size: 24,
                          ),
                          hintText: "Cari nama pelanggan",
                          hintStyle: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                ],
              ),
            ),
          ),
          const SizedBox(height: 7),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 0,
                right: 0,
                top: 7,
                bottom: 15,
              ),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final p = filteredList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 19,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.13),
                        width: 1.15,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.13),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.nama,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17.8,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    p.tipe,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black.withOpacity(0.66),
                                    ),
                                  ),
                                  if (p.ekspres)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[200],
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: const Text(
                                        "Ekspres",
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          color: Colors.deepOrange,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Text(
                                    "${p.kg} kgs",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black.withOpacity(0.54),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    "•",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400],
                                      fontSize: 13.7,
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    "${p.pcs} pcs",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black.withOpacity(0.54),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            _statusIcon(p.status),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black87,
                              size: 29,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusTab({
    required IconData icon,
    required Color iconColor,
    required int count,
    required String label,
  }) {
    return Expanded(
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 20.5),
                const SizedBox(width: 2),
                Text(
                  "$count",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.black.withOpacity(0.54),
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusIcon(String status) {
    if (status == 'belum_diambil') {
      return const Icon(
        Icons.close_rounded,
        color: Color(0xFFFF6A6A),
        size: 29,
      );
    } else if (status == 'belum_bayar') {
      return const Icon(
        Icons.radio_button_checked_rounded,
        color: Color(0xFF52E18C),
        size: 29,
      );
    } else {
      // sudah_diambil
      return const Icon(
        Icons.done_all_rounded,
        color: Color(0xFF40A2E3),
        size: 29,
      );
    }
  }
}
