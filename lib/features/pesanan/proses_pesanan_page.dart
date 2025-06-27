import 'package:flutter/material.dart';
import 'package:laundryin/features/pesanan/pesanan_model.dart';
import 'package:laundryin/features/pesanan/proses_detail_pesanan_belum_mulai_page.dart';
import 'package:laundryin/features/pesanan/proses_detail_pesanan_proses_page.dart';
import 'package:laundryin/features/pesanan/proses_detail_pesanan_selesai_page.dart';

class ProsesPesananPage extends StatefulWidget {
  const ProsesPesananPage({super.key});

  @override
  State<ProsesPesananPage> createState() => _ProsesPesananPageState();
}

class _ProsesPesananPageState extends State<ProsesPesananPage> {
  String search = "";

  List<Pesanan> pesananList = [
    Pesanan(
      nama: 'Farhan Laksono',
      noHp: '+6281322214567',
      tipe: 'Reguler',
      kg: 7,
      pcs: 8,
      status: 'proses',
      tanggal: DateTime(2024, 6, 10, 9, 0),
    ),
    Pesanan(
      nama: 'Habibullah Adilah P',
      noHp: '+6281322111999',
      tipe: 'Reguler',
      kg: 6,
      pcs: 9,
      status: 'belum_mulai',
      tanggal: DateTime(2024, 6, 8, 15, 0),
    ),
    Pesanan(
      nama: 'Pak Fazzle Ariwica',
      noHp: '+6281322100099',
      tipe: 'Ekspress',
      kg: 2,
      pcs: 3,
      status: 'belum_mulai',
      tanggal: DateTime(2024, 6, 9, 13, 30),
    ),
    Pesanan(
      nama: 'Pak Kresnadana Liu',
      noHp: '+6281322200022',
      tipe: 'Reguler',
      kg: 10,
      pcs: 11,
      status: 'belum_mulai',
      tanggal: DateTime(2024, 6, 7, 8, 45),
    ),
    Pesanan(
      nama: 'Bu Kim Suili Cak Lo',
      noHp: '+6281322300033',
      tipe: 'Reguler',
      kg: 9,
      pcs: 8,
      status: 'proses',
      tanggal: DateTime(2024, 6, 12, 10, 10),
    ),
    Pesanan(
      nama: 'Budi Santoso',
      noHp: '+6281322400044',
      tipe: 'Reguler',
      kg: 8,
      pcs: 9,
      status: 'selesai',
      tanggal: DateTime(2024, 6, 5, 17, 40),
    ),
  ];

  void updatePesananStatus(int idx, String newStatus) {
    setState(() {
      pesananList[idx] = pesananList[idx].copyWith(status: newStatus);
    });
  }

  void hapusPesanan(int idx) {
    setState(() {
      pesananList.removeAt(idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    final countBelumMulai = pesananList.where((e) => e.status == 'belum_mulai').length;
    final countProses = pesananList.where((e) => e.status == 'proses').length;
    final countSelesai = pesananList.where((e) => e.status == 'selesai').length;

    final filteredList = pesananList
        .where((p) => p.nama.toLowerCase().contains(search.toLowerCase()))
        .toList()
      ..sort((a, b) {
        int getOrder(String status) {
          if (status == 'belum_mulai') return 0;
          if (status == 'proses') return 1;
          return 2;
        }
        int cmp = getOrder(a.status).compareTo(getOrder(b.status));
        if (cmp != 0) return cmp;
        return a.tanggal.compareTo(b.tanggal);
      });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER & GRADIENT
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
            padding: const EdgeInsets.only(top: 42, left: 0, right: 0, bottom: 26),
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
                            "Proses Pesanan",
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
                    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 9),
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
                          icon: Icons.close_rounded,
                          iconColor: Color(0xFFFF6A6A),
                          count: countBelumMulai,
                          label: "Belum Mulai",
                        ),
                        const SizedBox(width: 13),
                        _statusTab(
                          icon: Icons.radio_button_checked_rounded,
                          iconColor: Color(0xFF52E18C),
                          count: countProses,
                          label: "Proses",
                        ),
                        const SizedBox(width: 13),
                        _statusTab(
                          icon: Icons.done_all_rounded,
                          iconColor: Color(0xFF40A2E3),
                          count: countSelesai,
                          label: "Selesai",
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
              padding: const EdgeInsets.only(left: 0, right: 0, top: 7, bottom: 15),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final p = filteredList[index];
                final idxInList = pesananList.indexOf(p);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () async {
                      if (p.status == 'belum_mulai') {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProsesDetailPesananBelumMulaiPage(
                              pesanan: p,
                              onMulaiProses: () {
                                setState(() {
                                  pesananList[idxInList] = pesananList[idxInList].copyWith(status: 'proses');
                                });
                              },
                            ),
                          ),
                        );
                      } else if (p.status == 'proses') {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProsesDetailPesananProsesPage(
                              pesanan: p,
                              onHentikanProses: () {
                                setState(() {
                                  pesananList[idxInList] = pesananList[idxInList].copyWith(status: 'selesai');
                                });
                              },
                            ),
                          ),
                        );
                      } else if (p.status == 'selesai') {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProsesDetailPesananSelesaiPage(
                              pesanan: p,
                              onSelesaikanPesanan: () {
                                setState(() {
                                  pesananList.removeAt(idxInList);
                                });
                              },
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 18),
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
    if (status == 'belum_mulai') {
      return const Icon(Icons.close_rounded, color: Color(0xFFFF6A6A), size: 29);
    } else if (status == 'proses') {
      return const Icon(Icons.radio_button_checked_rounded, color: Color(0xFF52E18C), size: 29);
    } else {
      return const Icon(Icons.done_all_rounded, color: Color(0xFF40A2E3), size: 29);
    }
  }
}
