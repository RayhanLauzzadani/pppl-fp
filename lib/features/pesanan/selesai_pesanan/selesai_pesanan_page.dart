import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundryin/features/pesanan/pesanan_model.dart';
import 'package:laundryin/features/pesanan/selesai_pesanan/detail_pesanan_belum_bayar_page.dart';
import 'package:laundryin/features/pesanan/selesai_pesanan/detail_pesanan_belum_diambil_page.dart'
    as belumDiambil;
import 'package:laundryin/features/pesanan/selesai_pesanan/detail_pesanan_sudah_diambil_page.dart'
    as sudahDiambil;
import 'package:laundryin/features/home/home_page.dart';

class SelesaiPesananPage extends StatefulWidget {
  final String kodeLaundry;
  final String role;
  final String emailUser;
  final String passwordUser;

  const SelesaiPesananPage({
    Key? key,
    required this.kodeLaundry,
    required this.role,
    required this.emailUser,
    required this.passwordUser,
  }) : super(key: key);

  @override
  State<SelesaiPesananPage> createState() => _SelesaiPesananPageState();
}

class _SelesaiPesananPageState extends State<SelesaiPesananPage> {
  String search = "";

  Stream<List<Pesanan>> _streamPesanan() {
    return FirebaseFirestore.instance
        .collection('laundries')
        .doc(widget.kodeLaundry)
        .collection('pesanan')
        .where('statusProses', isEqualTo: 'selesai')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Pesanan.fromFirestore(doc)).toList(),
        );
  }

  void _goToHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          role: widget.role,
          laundryId: widget.kodeLaundry,
          emailUser: widget.emailUser,
          passwordUser: widget.passwordUser,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        _goToHomePage();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FB),
        body: Column(
          children: [
            // ===== HEADER (GRADIENT SESUAI KODE AWAL) =====
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 42 + MediaQuery.of(context).padding.top,
                bottom: 16,
              ),
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
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 13,
                    offset: Offset(0, 7),
                  ),
                ],
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
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
                        onPressed: _goToHomePage,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Pesanan Selesai",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.13),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 44), // same width as back button
                    ],
                  ),
                  const SizedBox(height: 6),
                  // CARD STATUS
                  StreamBuilder<List<Pesanan>>(
                    stream: _streamPesanan(),
                    builder: (context, snapshot) {
                      int countBelumBayar = 0;
                      int countBelumDiambil = 0;
                      int countSudahDiambil = 0;
                      if (snapshot.hasData) {
                        countBelumBayar = snapshot.data!
                            .where((e) => e.statusTransaksi == 'belum_bayar')
                            .length;
                        countBelumDiambil = snapshot.data!
                            .where((e) => e.statusTransaksi == 'belum_diambil')
                            .length;
                        countSudahDiambil = snapshot.data!
                            .where((e) => e.statusTransaksi == 'sudah_diambil')
                            .length;
                      }
                      return Container(
                        width: screenWidth - 36,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 11,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x13000000),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _statusCard(
                              icon: Icons.help_outline_rounded,
                              iconColor: const Color(0xFF52E18C),
                              count: countBelumDiambil,
                              label: "Belum Diambil",
                            ),
                            _statusCard(
                              icon: Icons.close_rounded,
                              iconColor: const Color(0xFFFF6A6A),
                              count: countBelumBayar,
                              label: "Belum Bayar",
                            ),
                            _statusCard(
                              icon: Icons.done_all_rounded,
                              iconColor: const Color(0xFF40A2E3),
                              count: countSudahDiambil,
                              label: "Sudah Diambil",
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  // SEARCH BOX
                  Container(
                    width: screenWidth - 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.11),
                          blurRadius: 13,
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
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // ===== PESANAN LIST =====
            Expanded(
              child: StreamBuilder<List<Pesanan>>(
                stream: _streamPesanan(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());
                  if (!snapshot.hasData || snapshot.data!.isEmpty)
                    return const Center(
                      child: Text('Tidak ada pesanan selesai'),
                    );

                  var pesananList = snapshot.data!;
                  final filteredList = pesananList
                      .where(
                        (p) =>
                            p.nama.toLowerCase().contains(search.toLowerCase()),
                      )
                      .toList();

                  filteredList.sort((a, b) {
                    int order(String s) {
                      if (s == 'belum_diambil') return 0;
                      if (s == 'belum_bayar') return 1;
                      if (s == 'sudah_diambil') return 2;
                      return 3;
                    }

                    int cmp = order(
                      a.statusTransaksi,
                    ).compareTo(order(b.statusTransaksi));
                    if (cmp != 0) return cmp;
                    return pesananList
                        .indexOf(a)
                        .compareTo(pesananList.indexOf(b));
                  });

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    itemCount: filteredList.length,
                    separatorBuilder: (context, i) =>
                        const SizedBox(height: 13),
                    itemBuilder: (context, index) {
                      final p = filteredList[index];

                      // Card status icon
                      IconData statusIcon;
                      Color statusColor;
                      if (p.statusTransaksi == 'belum_diambil') {
                        statusIcon = Icons.help_outline_rounded;
                        statusColor = const Color(0xFF52E18C);
                      } else if (p.statusTransaksi == 'belum_bayar') {
                        statusIcon = Icons.close_rounded;
                        statusColor = const Color(0xFFFF6A6A);
                      } else {
                        statusIcon = Icons.done_all_rounded;
                        statusColor = const Color(0xFF40A2E3);
                      }

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 0,
                        ),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          elevation: 2,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () async {
                              // NAVIGASI PAGE DETAIL SESUAI STATUS TRANSAKSI
                              if (p.statusTransaksi == 'belum_bayar') {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailPesananBelumBayarPage(
                                      pesanan: p,
                                      onKonfirmasiBayar: () async {
                                        Navigator.pop(context);
                                        await FirebaseFirestore.instance
                                            .collection('laundries')
                                            .doc(widget.kodeLaundry)
                                            .collection('pesanan')
                                            .doc(p.id)
                                            .update({
                                              'statusTransaksi':
                                                  'belum_diambil',
                                            });
                                      },
                                    ),
                                  ),
                                );
                              } else if (p.statusTransaksi == 'belum_diambil') {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        belumDiambil.DetailPesananBelumDiambilPage(
                                          pesanan: p,
                                          onKonfirmasiDiambil: () async {
                                            await FirebaseFirestore.instance
                                                .collection('laundries')
                                                .doc(widget.kodeLaundry)
                                                .collection('pesanan')
                                                .doc(p.id)
                                                .update({
                                                  'statusTransaksi':
                                                      'sudah_diambil',
                                                });
                                            if (mounted) setState(() {});
                                            Navigator.pop(context);
                                          },
                                        ),
                                  ),
                                );
                              } else {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        sudahDiambil.DetailPesananSudahDiambilPage(
                                          pesanan: p,
                                        ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.15),
                                  width: 1.1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 9,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                14,
                                14,
                                14,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.nama,
                                          style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w900,
                                            fontSize: 17.2,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          p.desc.isNotEmpty
                                              ? p.desc
                                              : "Reguler",
                                          style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.7,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Text(
                                              "${p.beratKg} kgs",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 12.6,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black.withOpacity(
                                                  0.52,
                                                ),
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
                                                fontSize: 13.5,
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Text(
                                              "${p.pcs} pcs",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 12.6,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black.withOpacity(
                                                  0.52,
                                                ),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    statusIcon,
                                    color: statusColor,
                                    size: 25,
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black45,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusCard({
    required IconData icon,
    required Color iconColor,
    required int count,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.11),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: iconColor.withOpacity(0.21),
                width: 1.6,
              ),
            ),
            child: Center(child: Icon(icon, color: iconColor, size: 26)),
          ),
          const SizedBox(height: 6),
          Text(
            "$count",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.black.withOpacity(0.60),
              fontWeight: FontWeight.w500,
              fontSize: 12.7,
            ),
          ),
        ],
      ),
    );
  }
}
