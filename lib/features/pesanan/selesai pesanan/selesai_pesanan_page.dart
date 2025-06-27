import 'package:flutter/material.dart';
import 'selesai_pesanan_model.dart';
import 'detail_pesanan_belum_diambil_page.dart';
import 'detail_pesanan_belum_bayar_page.dart';
import 'detail_pesanan_sudah_diambil_page.dart';

class SelesaiPesananPage extends StatefulWidget {
  const SelesaiPesananPage({super.key});

  @override
  State<SelesaiPesananPage> createState() => _SelesaiPesananPageState();
}

class _SelesaiPesananPageState extends State<SelesaiPesananPage> {
  String search = "";

  List<Pesanan> pesananList = [
    Pesanan(
      noNota: '1157.1909.21',
      nama: 'Farhan Laksono',
      noHp: '+6281322214567',
      tipe: 'Reguler',
      kg: 7,
      pcs: 8,
      status: 'belum_diambil',
      tanggalTerima: DateTime(2024, 6, 10, 15, 37),
      tanggalSelesai: DateTime(2024, 6, 12, 9, 0),
      totalBayar: 84000,
      jenisParfum: 'Junjung Buih',
      antarJemput: '≤ 2 Km',
      listLaundry: [
        LaundryItem(nama: 'Bed Cover Jumbo', tipe: 'Satuan', jumlah: 1, harga: 30000, hargaTotal: 30000),
        LaundryItem(nama: 'Boneka Kecil', tipe: 'Satuan', jumlah: 3, harga: 5000, hargaTotal: 15000),
        LaundryItem(nama: 'Cuci Setrika', tipe: 'Kiloan', jumlah: 4, harga: 6000, hargaTotal: 24000),
        LaundryItem(nama: 'Selimut Single', tipe: 'Satuan', jumlah: 1, harga: 15000, hargaTotal: 15000),
      ],
    ),
    Pesanan(
      noNota: '2221.1909.22',
      nama: 'Habibullah Adilah P',
      noHp: '+6281322299911',
      tipe: 'Reguler',
      kg: 6,
      pcs: 9,
      status: 'belum_bayar',
      tanggalTerima: DateTime(2024, 6, 6, 15, 0),
      tanggalSelesai: DateTime(2024, 6, 8, 9, 0),
      totalBayar: 70000,
      jenisParfum: 'Junjung Buih',
      antarJemput: '≤ 2 Km',
      listLaundry: [
        LaundryItem(nama: 'Bed Cover Jumbo', tipe: 'Satuan', jumlah: 1, harga: 30000, hargaTotal: 30000),
        LaundryItem(nama: 'Boneka Kecil', tipe: 'Satuan', jumlah: 2, harga: 5000, hargaTotal: 10000),
        LaundryItem(nama: 'Cuci Setrika', tipe: 'Kiloan', jumlah: 5, harga: 6000, hargaTotal: 30000),
      ],
    ),
    Pesanan(
      noNota: '1333.1234.23',
      nama: 'Pak Fazzle Ariwica',
      noHp: '+6281322222233',
      tipe: 'Ekspres',
      kg: 2,
      pcs: 3,
      status: 'sudah_diambil',
      tanggalTerima: DateTime(2024, 6, 7, 14, 30),
      tanggalSelesai: DateTime(2024, 6, 8, 9, 0),
      totalBayar: 30000,
      jenisParfum: 'Junjung Buih',
      antarJemput: '≤ 2 Km',
      listLaundry: [
        LaundryItem(nama: 'Cuci Setrika', tipe: 'Kiloan', jumlah: 3, harga: 10000, hargaTotal: 30000),
      ],
    ),
  ];

  void updatePesananStatus(int idx, String newStatus) {
    setState(() {
      pesananList[idx] = pesananList[idx].copyWith(status: newStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = pesananList
        .where((p) => p.nama.toLowerCase().contains(search.toLowerCase()))
        .toList();

    // Sort: belum_diambil > belum_bayar > sudah_diambil
    filteredList.sort((a, b) {
      int order(String s) {
        if (s == 'belum_diambil') return 0;
        if (s == 'belum_bayar') return 1;
        return 2;
      }
      int cmp = order(a.status).compareTo(order(b.status));
      if (cmp != 0) return cmp;
      return pesananList.indexOf(a).compareTo(pesananList.indexOf(b));
    });

    final countBelumDiambil = pesananList.where((e) => e.status == 'belum_diambil').length;
    final countBelumBayar = pesananList.where((e) => e.status == 'belum_bayar').length;
    final countSudahDiambil = pesananList.where((e) => e.status == 'sudah_diambil').length;

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
                      // Pilih detail page berdasarkan status
                      if (p.status == 'belum_diambil') {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPesananBelumDiambilPage(
                              pesanan: p,
                              onKonfirmasiDiambil: () {
                                updatePesananStatus(idxInList, 'sudah_diambil');
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      } else if (p.status == 'belum_bayar') {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPesananBelumBayarPage(
                              pesanan: p,
                              onKonfirmasiBayar: () {
                                updatePesananStatus(idxInList, 'belum_diambil');
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      } else {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPesananSudahDiambilPage(
                              pesanan: p,
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
    if (status == 'belum_diambil') {
      return const Icon(
        Icons.help_outline_rounded,
        color: Color(0xFF52E18C),
        size: 29,
      );
    } else if (status == 'belum_bayar') {
      return const Icon(
        Icons.close_rounded,
        color: Color(0xFFFF6A6A),
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
