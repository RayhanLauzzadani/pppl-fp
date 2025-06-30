import 'package:flutter/material.dart';
import 'package:laundryin/features/pesanan/pesanan_model.dart';
import 'package:laundryin/features/pesanan/components/kendala_modal.dart';

class DetailPesananSudahDiambilPage extends StatelessWidget {
  final Pesanan pesanan;

  const DetailPesananSudahDiambilPage({super.key, required this.pesanan});

  @override
  Widget build(BuildContext context) {
    // Status UI
    final statusColor = Colors.blue[700]!;
    const statusText = "Sudah Diambil";
    const statusIcon = Icons.done_all_rounded;

    // Build list item gabungan
    final List<Map<String, dynamic>> listItem = [];
    if (pesanan.jumlah != null && pesanan.jumlah!.isNotEmpty) {
      pesanan.jumlah!.forEach((nama, qty) {
        if (nama.toLowerCase() == "laundry kiloan") return;
        if ((qty ?? 0) > 0) {
          listItem.add({
            "nama": nama,
            "tipe": pesanan.layananTipe?[nama] ?? "",
            "jumlah": qty,
            "harga": pesanan.hargaLayanan?[nama] ?? 0,
            "hargaTotal": ((pesanan.hargaLayanan?[nama] ?? 0) * (qty ?? 0)),
          });
        }
      });
    }
    pesanan.barangList.where((b) {
      final nama = b['title'] ?? b['nama'] ?? '';
      return (pesanan.barangQty[nama] ?? 0) > 0 && !(listItem.any((item) => item['nama'] == nama));
    }).forEach((b) {
      final nama = b['title'] ?? b['nama'] ?? '';
      final qty = pesanan.barangQty[nama] ?? 0;
      listItem.add({
        "nama": nama,
        "tipe": "",
        "jumlah": qty,
        "harga": 0,
        "hargaTotal": 0,
      });
    });
    if (listItem.isEmpty) {
      listItem.add({
        "nama": "Item Kosong",
        "tipe": "",
        "jumlah": 0,
        "harga": 0,
        "hargaTotal": 0
      });
    }

    // ---------- UI ----------
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(82),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF40A2E3), Color(0xFFBBE2EC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
            boxShadow: [
              BoxShadow(
                color: Color(0x29000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: const Text(
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
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 130),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Nota–${pesanan.id} ",
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.8,
                                      ),
                                    ),
                                    TextSpan(
                                      text: pesanan.desc,
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black54,
                                        fontSize: 13.7,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                pesanan.nama,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              Text(
                                pesanan.whatsapp,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 13.5,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(7),
                                child: Icon(
                                  statusIcon,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 12.8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // TABEL INFO
                    Table(
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        _tableRow("Status", "Selesai", boldRight: true),
                        _tableRow("Tanggal Terima", _formatTanggal(pesanan.createdAt), boldRight: true),
                        _tableRow("Tanggal Selesai", _formatTanggal(pesanan.tanggalSelesai), boldRight: true),
                        _tableRow("Jenis Parfum", pesanan.jenisParfum ?? "-", boldRight: false),
                        _tableRow("Layanan Antar Jemput", pesanan.antarJemput ?? "-", boldRight: false),
                        _tableRow("Catatan", pesanan.catatan ?? "-", boldRight: false),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Divider(color: Colors.grey[400], thickness: 1.1),
                    const SizedBox(height: 7),
                    // LIST ITEM
                    const Text(
                      "Layanan Laundry :",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 14.7,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...listItem.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama
                            Text(
                              item['nama'],
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 15.5,
                              ),
                            ),
                            // Tipe
                            if ((item['tipe'] ?? "").toString().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 1, left: 1, bottom: 1),
                                child: Text(
                                  item['tipe'],
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12.7,
                                  ),
                                ),
                              ),
                            // Jumlah + Harga
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${item['jumlah']} pcs",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 13.3,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Rp. ${_formatRupiah(item['hargaTotal'])}",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14.2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            // Harga satuan
                            if ((item['harga'] ?? 0) > 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 2, top: 2),
                                child: Text(
                                  "x Rp. ${_formatRupiah(item['harga'])}",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12.4,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
          // BOTTOM BAR: Total & Buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF6F8FB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x13000000),
                    blurRadius: 18,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 13, 16, 19),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Total
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
                            "Rp. ${_formatRupiah(pesanan.totalHarga)}",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: statusColor,
                            ),
                          ),
                          const Text(
                            "(Sudah Bayar)",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Color(0xFF1976D2),
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) => KendalaModal(noHp: pesanan.whatsapp),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF40A2E3),
                            side: const BorderSide(color: Color(0xFF40A2E3), width: 1.5),
                            backgroundColor: const Color(0xFFE7F3FB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(fontFamily: "Poppins"),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          icon: const Icon(Icons.phone, size: 20),
                          label: const Text("Hubungi Pelanggan"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(fontFamily: "Poppins"),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: const Text(
                            "Sudah diambil",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helpers
  static TableRow _tableRow(String left, String right, {bool boldRight = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
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
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            right,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 13.4,
              fontWeight: boldRight ? FontWeight.bold : FontWeight.w500,
              color: boldRight ? Colors.blueGrey[900] : Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  static String _formatTanggal(DateTime? dt) {
    if (dt == null) return "-";
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  static String _formatRupiah(dynamic number) {
    if (number == null) return "0";
    return number.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.");
  }
}
