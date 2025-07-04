import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pesanan_model.dart';

class DetailPesananSelesaiPage extends StatefulWidget {
  final Pesanan pesanan;
  const DetailPesananSelesaiPage({Key? key, required this.pesanan}) : super(key: key);

  @override
  State<DetailPesananSelesaiPage> createState() => _DetailPesananSelesaiPageState();
}

class _DetailPesananSelesaiPageState extends State<DetailPesananSelesaiPage> {
  late Pesanan pesanan;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    pesanan = widget.pesanan;
  }

  // Menampilkan label status proses laundry
  String get statusProsesLabel {
    switch (pesanan.statusProses ?? "") {
      case "belum_mulai":
        return "Belum Diproses";
      case "proses":
        return "Sedang Diproses";
      case "selesai":
        return "Selesai";
      default:
        return pesanan.statusProses ?? "-";
    }
  }

  // Menampilkan label status transaksi
  String get statusTransaksiLabel {
    switch (pesanan.statusTransaksi ?? "") {
      case "belum_bayar":
        return "Belum Bayar";
      case "belum_diambil":
        return "Belum Diambil";
      case "sudah_diambil":
        return "Sudah Diambil";
      default:
        return pesanan.statusTransaksi ?? "-";
    }
  }

  // Fungsi update statusTransaksi jadi "sudah_diambil"
  Future<void> _handleSudahDiambil() async {
    if (pesanan.kodeLaundry == null || pesanan.kodeLaundry!.isEmpty) return;
    setState(() => isUpdating = true);
    try {
      await FirebaseFirestore.instance
          .collection('laundries')
          .doc(pesanan.kodeLaundry)
          .collection('pesanan')
          .doc(pesanan.id)
          .update({'statusTransaksi': 'sudah_diambil'});

      setState(() {
        pesanan = pesanan.copyWith(statusTransaksi: 'sudah_diambil');
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan sudah diambil.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update status: $e')),
      );
    } finally {
      setState(() => isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = pesanan.barangList;
    final qtyMap = pesanan.barangQty;
    int totalBayar = pesanan.totalHarga;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header gradient
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.56, 1],
                colors: [
                  Color(0xFF40A2E3),
                  Color(0xFFBBE2EC),
                  Color(0xFFFFF6E9),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.only(top: 42, left: 0, right: 0, bottom: 18),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Detail Pesanan",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(1, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 44),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Card utama
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nota & user
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nota–${pesanan.id}  ${pesanan.desc}",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.3,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        'https://randomuser.me/api/portraits/men/32.jpg',
                                      ),
                                      radius: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pesanan.nama,
                                          style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.4,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          pesanan.whatsapp,
                                          style: const TextStyle(
                                            fontFamily: "Poppins",
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Badge Status di kanan
                          Column(
                            children: [
                              Icon(
                                pesanan.statusTransaksi == "sudah_diambil"
                                    ? Icons.verified_rounded
                                    : Icons.done_all_rounded,
                                color: Color(0xFF40A2E3),
                                size: 28,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                statusProsesLabel,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                  color: Colors.black.withOpacity(0.66),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: pesanan.statusTransaksi == "sudah_diambil"
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Text(
                                  statusTransaksiLabel,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: pesanan.statusTransaksi == "sudah_diambil"
                                        ? Colors.green[700]
                                        : Colors.orange[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.grey[400], thickness: 0.8, height: 23),
                      _infoRow("Status Laundry", statusProsesLabel, boldValue: true),
                      _infoRow("Status Transaksi", statusTransaksiLabel, boldValue: true),
                      _infoRow(
                        "Tanggal Terima",
                        pesanan.createdAt != null
                            ? "${pesanan.createdAt!.day}/${pesanan.createdAt!.month}/${pesanan.createdAt!.year}"
                            : "-",
                        boldValue: true,
                      ),
                      // Tambah field lain sesuai kebutuhan
                      Divider(color: Colors.grey[400], thickness: 0.8, height: 24),
                      const Text(
                        "Layanan Laundry :",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Tidak ada barang."),
                        )
                      else
                        ...items.map((item) {
                          String nama = item['title'] ?? '-';
                          int jumlah = qtyMap[nama] ?? 0;
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  nama,
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.5,
                                  ),
                                ),
                                Text(
                                  "$jumlah pcs",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 13.5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      Divider(color: Colors.grey[400], thickness: 0.8, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Pembayaran",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 15.5,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Rp. ${totalBayar.toString()}",
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19.5,
                                ),
                              ),
                              Text(
                                pesanan.statusTransaksi == "belum_bayar"
                                    ? "(Belum Bayar)"
                                    : "(Sudah Bayar)",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: pesanan.statusTransaksi == "belum_bayar"
                                      ? Colors.red
                                      : Color(0xFF40A2E3),
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tombol bawah
          Container(
            color: const Color(0xFFFFF6E9),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // WA atau call
                    },
                    icon: const Icon(Icons.phone, color: Color(0xFF40A2E3)),
                    label: const Text(
                      "Hubungi Pelanggan",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF40A2E3),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2F4FF),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (pesanan.statusTransaksi == "sudah_diambil" || isUpdating)
                        ? null
                        : _handleSudahDiambil,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pesanan.statusTransaksi == "sudah_diambil"
                          ? Colors.green[300]
                          : Color(0xFF40A2E3),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: isUpdating
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            pesanan.statusTransaksi == "sudah_diambil"
                                ? "Sudah Diambil"
                                : "Sudah Diambil",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String key, String value, {bool boldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.7),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(
              key,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14.3,
                color: Colors.black.withOpacity(0.74),
              ),
            ),
          ),
          Expanded(
            flex: 11,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: boldValue ? FontWeight.w700 : FontWeight.w400,
                fontSize: 14.5,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
