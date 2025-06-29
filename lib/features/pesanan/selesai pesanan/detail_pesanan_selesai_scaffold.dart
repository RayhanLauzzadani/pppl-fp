import 'package:flutter/material.dart';
import 'selesai_pesanan_model.dart';
import 'package:laundryin/features/pesanan/components/kendala_modal.dart';

class DetailPesananSelesaiScaffold extends StatelessWidget {
  final Pesanan pesanan;
  final String status; // 'belum_diambil', 'belum_bayar', 'sudah_diambil'
  final VoidCallback? onKonfirmasi;

  const DetailPesananSelesaiScaffold({
    super.key,
    required this.pesanan,
    required this.status,
    this.onKonfirmasi,
  });

  @override
  Widget build(BuildContext context) {
    // Konfigurasi warna dan status berdasarkan status pesanan
    late Color statusColor;
    late IconData statusIcon;
    late String statusText;
    late String statusDetailText;
    late Color totalColor;

    if (status == 'belum_bayar') {
      statusColor = Colors.red[400]!;
      statusIcon = Icons.close_rounded;
      statusText = "Belum Bayar";
      statusDetailText = "(Belum Bayar)";
      totalColor = Colors.red[400]!;
    } else if (status == 'belum_diambil') {
      statusColor = Colors.green[400]!;
      statusIcon = Icons.help_outline_rounded;
      statusText = "Belum Diambil";
      statusDetailText = "(Sudah Bayar)";
      totalColor = Colors.blueGrey[900]!;
    } else {
      // sudah_diambil
      statusColor = Colors.blue[700]!;
      statusIcon = Icons.done_all_rounded;
      statusText = "Sudah Diambil";
      statusDetailText = "(Sudah Bayar)";
      totalColor = Colors.blue[700]!;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6E9),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(86),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF40A2E3), Color(0xFFBBE2EC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(26),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x29000000),
                blurRadius: 14,
                offset: Offset(0, 7),
              )
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Detail Pesanan",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CARD NOTA DAN PELANGGAN
            Container(
              margin: const EdgeInsets.fromLTRB(16, 17, 16, 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 9,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nomor Nota & Reguler
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${pesanan.noNota} ${pesanan.tipe}",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Row(
                          children: [
                            Icon(statusIcon, color: statusColor, size: 18),
                            const SizedBox(width: 2),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pesanan.nama,
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              pesanan.noHp,
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13.5,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // STATUS, TANGGAL, DLL
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 9,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                },
                children: [
                  _tableRow("Status", _getStatusLabel(status), isBold: true),
                  _tableRow("Tanggal Terima", _formatTanggal(pesanan.tanggalTerima)),
                  _tableRow("Tanggal Selesai", _formatTanggal(pesanan.tanggalSelesai)),
                  _tableRow("Jenis Parfum", pesanan.jenisParfum),
                  _tableRow("Layanan Antar Jemput", pesanan.antarJemput),
                ],
              ),
            ),
            // LAUNDRY ITEM
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: const EdgeInsets.fromLTRB(17, 15, 17, 17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 9,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Layanan Laundry :",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 14.7,
                    ),
                  ),
                  const SizedBox(height: 11),
                  ...pesanan.listLaundry.map((item) => _itemLaundry(item)).toList(),
                  const SizedBox(height: 7),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Pembayaran",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.1,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Rp. ${_formatRupiah(pesanan.totalBayar)}",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: totalColor,
                            ),
                          ),
                          Text(
                            statusDetailText,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: statusColor,
                              fontSize: 13.5,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // BUTTON LAPORKAN KENDALA (Hubungi Pelanggan)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Tampilkan modal laporkan kendala (pop up) dari kendala_modal.dart
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => KendalaModal(noHp: pesanan.noHp),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF40A2E3),
                        side: const BorderSide(color: Color(0xFF40A2E3), width: 1.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontFamily: "Poppins"),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: const Color(0xFFE2F4FF),
                      ),
                      icon: const Icon(Icons.phone),
                      label: const Text("Hubungi Pelanggan"),
                    ),
                  ),
                  if (onKonfirmasi != null) const SizedBox(width: 13),
                  if (onKonfirmasi != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onKonfirmasi,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontFamily: "Poppins"),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          status == 'belum_bayar' ? "Konfirmasi Bayar" : "Konfirmasi Diambil",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }

  TableRow _tableRow(String label, String value, {bool isBold = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              fontSize: 13.2,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Text(
            value,
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: 13.5,
              color: isBold ? Colors.orange : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemLaundry(LaundryItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nama,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                  ),
                ),
                Text(
                  "${item.tipe} x Rp. ${_formatRupiah(item.harga)}",
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${item.jumlah} ${item.tipe == 'Kiloan' ? 'kgs' : 'pcs'}",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 13.7,
                    ),
                  ),
                  Text(
                    "Rp. ${_formatRupiah(item.hargaTotal)}",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 13.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatTanggal(DateTime? dt) {
    if (dt == null) return "-";
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  static String _formatRupiah(int? number) {
    if (number == null) return "0";
    return number.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.");
  }

  static String _getStatusLabel(String status) {
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
}
