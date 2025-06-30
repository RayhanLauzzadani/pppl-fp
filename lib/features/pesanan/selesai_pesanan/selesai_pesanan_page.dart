import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundryin/features/pesanan/pesanan_model.dart';
import 'package:laundryin/features/pesanan/selesai_pesanan/detail_pesanan_belum_bayar_page.dart';
import 'package:laundryin/features/pesanan/selesai_pesanan/detail_pesanan_belum_diambil_page.dart' as belumDiambil;
import 'package:laundryin/features/pesanan/selesai_pesanan/detail_pesanan_sudah_diambil_page.dart' as sudahDiambil;
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
        .map((snapshot) =>
            snapshot.docs.map((doc) => Pesanan.fromFirestore(doc)).toList());
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
    return WillPopScope(
      onWillPop: () async {
        _goToHomePage();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FB),
        body: Column(
          children: [
            // ===== HEADER STICKY =====
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
              padding: const EdgeInsets.only(top: 42, bottom: 22),
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
                          onPressed: _goToHomePage,
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
                        const SizedBox(width: 44),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Status tab di header
                    StreamBuilder<List<Pesanan>>(
                      stream: _streamPesanan(),
                      builder: (context, snapshot) {
                        int countBelumBayar = 0;
                        int countBelumDiambil = 0;
                        int countSudahDiambil = 0;
                        if (snapshot.hasData) {
                          countBelumBayar = snapshot.data!.where((e) => e.statusTransaksi == 'belum_bayar').length;
                          countBelumDiambil = snapshot.data!.where((e) => e.statusTransaksi == 'belum_diambil').length;
                          countSudahDiambil = snapshot.data!.where((e) => e.statusTransaksi == 'sudah_diambil').length;
                        }
                        return Container(
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
                                iconColor: const Color(0xFFFF6A6A),
                                count: countBelumBayar,
                                label: "Belum Bayar",
                              ),
                              const SizedBox(width: 13),
                              _statusTab(
                                icon: Icons.help_outline_rounded,
                                iconColor: const Color(0xFF52E18C),
                                count: countBelumDiambil,
                                label: "Belum Diambil",
                              ),
                              const SizedBox(width: 13),
                              _statusTab(
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 7),
            // ===== PESANAN LIST =====
            Expanded(
              child: StreamBuilder<List<Pesanan>>(
                stream: _streamPesanan(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());
                  if (!snapshot.hasData || snapshot.data!.isEmpty)
                    return const Center(child: Text('Tidak ada pesanan selesai'));

                  var pesananList = snapshot.data!;
                  final filteredList = pesananList
                      .where((p) => p.nama.toLowerCase().contains(search.toLowerCase()))
                      .toList();

                  filteredList.sort((a, b) {
                    int order(String s) {
                      if (s == 'belum_bayar') return 0;
                      if (s == 'belum_diambil') return 1;
                      if (s == 'sudah_diambil') return 2;
                      return 3;
                    }
                    int cmp = order(a.statusTransaksi).compareTo(order(b.statusTransaksi));
                    if (cmp != 0) return cmp;
                    return pesananList.indexOf(a).compareTo(pesananList.indexOf(b));
                  });

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final p = filteredList[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () async {
                            // NAVIGASI PAGE DETAIL SESUAI STATUS TRANSAKSI
                            if (p.statusTransaksi == 'belum_bayar') {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailPesananBelumBayarPage(
                                    pesanan: p,
                                    onKonfirmasiBayar: () async {
                                      await FirebaseFirestore.instance
                                          .collection('laundries')
                                          .doc(widget.kodeLaundry)
                                          .collection('pesanan')
                                          .doc(p.id)
                                          .update({'statusTransaksi': 'belum_diambil'});
                                      if (mounted) setState(() {});
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            } else if (p.statusTransaksi == 'belum_diambil') {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => belumDiambil.DetailPesananBelumDiambilPage(
                                    pesanan: p,
                                    onKonfirmasiDiambil: () async {
                                      await FirebaseFirestore.instance
                                          .collection('laundries')
                                          .doc(widget.kodeLaundry)
                                          .collection('pesanan')
                                          .doc(p.id)
                                          .update({'statusTransaksi': 'sudah_diambil'});
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
                                  builder: (_) => sudahDiambil.DetailPesananSudahDiambilPage(pesanan: p),
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.11),
                                width: 1.1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.11),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 19, 20, 18),
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
                                      Text(
                                        p.desc.isNotEmpty ? p.desc : "Reguler",
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
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
                                Icon(
                                  p.statusTransaksi == 'belum_bayar'
                                      ? Icons.close_rounded
                                      : p.statusTransaksi == 'belum_diambil'
                                          ? Icons.help_outline_rounded
                                          : Icons.done_all_rounded,
                                  color: p.statusTransaksi == 'belum_bayar'
                                      ? const Color(0xFFFF6A6A)
                                      : p.statusTransaksi == 'belum_diambil'
                                          ? const Color(0xFF52E18C)
                                          : const Color(0xFF40A2E3),
                                  size: 27,
                                ),
                                const SizedBox(width: 7),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.black87,
                                  size: 22,
                                ),
                              ],
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

  Widget _statusTab({
    required IconData icon,
    required Color iconColor,
    required int count,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 1.5),
          Text(
            "$count",
            style: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.black.withOpacity(0.54),
              fontWeight: FontWeight.w500,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}
