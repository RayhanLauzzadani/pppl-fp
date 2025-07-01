import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundryin/features/pesanan/pesanan_model.dart';

class DetailRiwayatPesananPage extends StatelessWidget {
  final Pesanan pesanan;
  const DetailRiwayatPesananPage({super.key, required this.pesanan});

  static String _formatTanggal(DateTime? dt) {
    if (dt == null) return "-";
    return DateFormat('dd/MM/yyyy - HH:mm').format(dt);
  }

  static String _formatRupiah(dynamic number) {
    if (number == null) return "0";
    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => "${m[1]}.",
    );
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
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF40A2E3),
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F88A5B4),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Nota, Tipe, dan Nama
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "Nota–${pesanan.id} ",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: pesanan.tipe,
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.person, size: 19, color: Colors.grey[700]),
                    const SizedBox(width: 4),
                    Text(
                      pesanan.nama,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: 14.4,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.phone_android, size: 16, color: Colors.grey[500]),
                    Text(
                      pesanan.whatsapp,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12.9,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Status Badge
                Row(
                  children: [
                    Chip(
                      label: Text(
                        getStatusLabel(pesanan.status),
                        style: const TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500),
                      ),
                      backgroundColor: getStatusColor(pesanan.status).withOpacity(0.16),
                      labelStyle: TextStyle(color: getStatusColor(pesanan.status)),
                    ),
                  ],
                ),
                const SizedBox(height: 7),

                // Info Table
                Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    _tableRow("Tanggal Masuk", _formatTanggal(pesanan.createdAt)),
                    _tableRow("Tanggal Selesai", _formatTanggal(pesanan.tanggalSelesai)),
                    _tableRow("Jenis Layanan", pesanan.layanan),
                    _tableRow("Keterangan", pesanan.desc),
                    _tableRow("Parfum", pesanan.jenisParfum ?? "-"),
                    _tableRow("Antar Jemput", pesanan.antarJemput ?? "-"),
                    _tableRow("Catatan", pesanan.catatan ?? "-"),
                  ],
                ),
                const SizedBox(height: 10),

                Divider(color: Colors.grey[400], thickness: 1.1),
                const SizedBox(height: 6),
                // Layanan breakdown
                const Text(
                  "Daftar Layanan",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 14.7,
                  ),
                ),
                const SizedBox(height: 7),
                ...pesanan.laundryItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(
                        "${item.nama} (${item.tipe}) x${item.jumlah}",
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 13.5,
                        ),
                      )),
                      Text(
                        "Rp. ${_formatRupiah(item.hargaTotal)}",
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      ),
                    ],
                  ),
                )),

                // Diskon badge
                if ((pesanan.diskon != null && pesanan.diskon!.isNotEmpty) || (pesanan.labelDiskon != null && pesanan.labelDiskon!.isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.discount, color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (pesanan.labelDiskon != null && pesanan.labelDiskon!.isNotEmpty)
                                  Text(
                                    pesanan.labelDiskon!,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 13.8,
                                    ),
                                  ),
                                if (pesanan.diskon != null && pesanan.diskon!.isNotEmpty)
                                  Text(
                                    pesanan.diskon!,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Total Pembayaran
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F88A5B4),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Pembayaran",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 16.5,
                  ),
                ),
                Text(
                  "Rp. ${_formatRupiah(pesanan.total)}",
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _tableRow(String left, String right) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            left,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 13.2,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            right,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 13.4,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
