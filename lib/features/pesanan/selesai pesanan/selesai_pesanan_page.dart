import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'selesai_pesanan_model.dart';
import 'detail_pesanan_selesai_scaffold.dart'; // kalau ada

class SelesaiPesananPage extends StatefulWidget {
  final String kodeLaundry;
  final String role;

  const SelesaiPesananPage({
    Key? key,
    required this.kodeLaundry,
    required this.role,
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
        .where(
          'status',
          whereIn: ['belum_diambil', 'belum_bayar', 'sudah_diambil'],
        )
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Pesanan.fromFirestore(doc)).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Pesanan>>(
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
              if (s == 'belum_diambil') return 0;
              if (s == 'belum_bayar') return 1;
              return 2;
            }

            int cmp = order(a.status).compareTo(order(b.status));
            if (cmp != 0) return cmp;
            return pesananList.indexOf(a).compareTo(pesananList.indexOf(b));
          });

          final countBelumDiambil = pesananList
              .where((e) => e.status == 'belum_diambil')
              .length;
          final countBelumBayar = pesananList
              .where((e) => e.status == 'belum_bayar')
              .length;
          final countSudahDiambil = pesananList
              .where((e) => e.status == 'sudah_diambil')
              .length;

          return Column(
            children: [
              // HEADER
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
                          const SizedBox(width: 44),
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
                              iconColor: const Color(0xFF52E18C),
                              count: countBelumDiambil,
                              label: "Belum Diambil",
                            ),
                            const SizedBox(width: 13),
                            _statusTab(
                              icon: Icons.close_rounded,
                              iconColor: const Color(0xFFFF6A6A),
                              count: countBelumBayar,
                              label: "Belum Bayar",
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
                            onChanged: (value) =>
                                setState(() => search = value),
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
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16,
                              ),
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
              // LIST
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

                    // Badge icon & color
                    IconData badgeIcon;
                    Color badgeColor;
                    if (p.status == 'belum_diambil') {
                      badgeIcon = Icons.help_outline_rounded;
                      badgeColor = const Color(0xFF52E18C);
                    } else if (p.status == 'belum_bayar') {
                      badgeIcon = Icons.close_rounded;
                      badgeColor = const Color(0xFFFF6A6A);
                    } else {
                      badgeIcon = Icons.done_all_rounded;
                      badgeColor = const Color(0xFF40A2E3);
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () async {
                          // Navigasi ke detail pesanan selesai
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPesananSelesaiScaffold(
                                pesanan: p,
                                status: p.status,
                                onKonfirmasi:
                                    (p.status == 'belum_bayar' ||
                                        p.status == 'belum_diambil')
                                    ? () async {
                                        String newStatus =
                                            (p.status == 'belum_bayar')
                                            ? 'belum_diambil'
                                            : 'sudah_diambil';
                                        await FirebaseFirestore.instance
                                            .collection('laundries')
                                            .doc(widget.kodeLaundry)
                                            .collection('pesanan')
                                            .doc(p.id)
                                            .update({'status': newStatus});
                                        if (mounted) setState(() {});
                                        Navigator.pop(context);
                                      }
                                    : null,
                              ),
                            ),
                          );
                        },
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
                                    Text(
                                      p.tipe.isNotEmpty ? p.tipe : "Reguler",
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
                                          "${p.kg} kgs",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black.withOpacity(
                                              0.54,
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
                                            color: Colors.black.withOpacity(
                                              0.54,
                                            ),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(badgeIcon, color: badgeColor, size: 28),
                              const SizedBox(width: 7),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.black87,
                                size: 24,
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
          );
        },
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
                  style: const TextStyle(
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
}
