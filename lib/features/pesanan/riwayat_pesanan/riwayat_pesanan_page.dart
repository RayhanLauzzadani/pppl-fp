import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:laundryin/features/pesanan/pesanan_model.dart';
import 'detail_riwayat_pesanan_page.dart'; // Import halaman detail

class RiwayatPesananPage extends StatefulWidget {
  final String kodeLaundry;
  const RiwayatPesananPage({super.key, required this.kodeLaundry});

  @override
  State<RiwayatPesananPage> createState() => _RiwayatPesananPageState();
}

class _RiwayatPesananPageState extends State<RiwayatPesananPage> {
  String search = "";

  Stream<List<Pesanan>> _streamRiwayatPesanan() {
    return FirebaseFirestore.instance
        .collection('laundries')
        .doc(widget.kodeLaundry)
        .collection('pesanan')
        .where('statusProses', isEqualTo: 'selesai')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Pesanan.fromFirestore(doc)).toList());
  }

  static String _formatTanggal(DateTime? dt) {
    if (dt == null) return "-";
    final DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm');
    return formatter.format(dt);
  }

  String getStatusLabel(String status) {
    switch (status) {
      case 'belum_bayar':
        return "Belum Bayar";
      case 'belum_diambil':
        return "Belum Diambil";
      case 'sudah_diambil':
        return "Sudah Diambil";
      default:
        return "-";
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'belum_bayar':
        return Icons.close_rounded;
      case 'belum_diambil':
        return Icons.help_outline_rounded;
      case 'sudah_diambil':
        return Icons.done_all_rounded;
      default:
        return Icons.info_outline;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'belum_bayar':
        return Colors.redAccent;
      case 'belum_diambil':
        return Colors.orangeAccent;
      case 'sudah_diambil':
        return const Color(0xFF40A2E3);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
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
            padding: const EdgeInsets.only(top: 42, left: 0, right: 0, bottom: 21),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
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
                  const SizedBox(height: 17),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => search = v),
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search_rounded, color: Colors.black45, size: 24),
                          hintText: "Cari nama / nota / tanggal",
                          hintStyle: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 9),
          // List
          Expanded(
            child: StreamBuilder<List<Pesanan>>(
              stream: _streamRiwayatPesanan(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.isEmpty)
                  return const Center(
                    child: Text('Tidak ada riwayat pesanan'),
                  );

                var pesananList = snapshot.data!;
                final filteredList = pesananList.where((item) {
                  final q = search.toLowerCase();
                  return item.nama.toLowerCase().contains(q) ||
                      item.id.toLowerCase().contains(q) ||
                      _formatTanggal(item.createdAt).toLowerCase().contains(q) ||
                      _formatTanggal(item.tanggalSelesai).toLowerCase().contains(q);
                }).toList();

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  itemCount: filteredList.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 13),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        // Navigasi ke halaman detail!
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailRiwayatPesananPage(pesanan: item),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon
                            Container(
                              margin: const EdgeInsets.only(right: 14, top: 2),
                              child: Icon(
                                getStatusIcon(item.statusTransaksi),
                                size: 39,
                                color: getStatusColor(item.statusTransaksi),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: "Nota–${item.id} ",
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 14.8,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: item.tipe,
                                          style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black,
                                            fontSize: 13.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Masuk : ${_formatTanggal(item.createdAt)}\nSelesai : ${_formatTanggal(item.tanggalSelesai)}",
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.black87,
                                      fontSize: 12.7,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            // Harga & status
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Rp ${_formatRupiah(item.total)}",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.5,
                                  ),
                                ),
                                Text(
                                  "${getStatusLabel(item.statusTransaksi)} • ${item.metode}",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54,
                                    fontSize: 12.5,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
    );
  }

  static String _formatRupiah(dynamic number) {
    if (number == null) return "0";
    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => "${m[1]}.",
    );
  }
}
