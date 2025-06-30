import 'package:flutter/material.dart';
import 'package:laundryin/features/pesanan/pesanan_model.dart';
import 'package:laundryin/features/pesanan/components/kendala_modal.dart';

class DetailPesananSudahDiambilPage extends StatelessWidget {
  final Pesanan pesanan;

  const DetailPesananSudahDiambilPage({super.key, required this.pesanan});

  @override
  Widget build(BuildContext context) {
    // STATUS DATA
    final statusColor = Colors.blue[700]!;
    const statusText = "Sudah Diambil";
    const statusIcon = Icons.done_all_rounded;
    final totalColor = Colors.blue[700]!;

    // ITEM LIST
    final List<Map<String, dynamic>> listItem = [];
    if (pesanan.jumlah != null && pesanan.jumlah!.isNotEmpty) {
      pesanan.jumlah!.forEach((nama, qty) {
        if (nama.toLowerCase() == "laundry kiloan") return;
        if (qty > 0) {
          listItem.add({
            "nama": nama,
            "jumlah": qty.toString(),
          });
        }
      });
    }
    for (final barang in pesanan.barangList) {
      final nama = barang['title'] ?? barang['nama'] ?? '';
      final qty = pesanan.barangQty[nama] ?? 0;
      if (nama.toString().isNotEmpty && qty > 0) {
        listItem.add({
          "nama": nama,
          "jumlah": qty.toString(),
        });
      }
    }
    if (listItem.isEmpty) {
      listItem.add({
        "nama": "Item Kosong",
        "jumlah": "0",
      });
    }

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
                              const SizedBox(height: 8),
                              Text(
                                pesanan.nama,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.4,
                                ),
                              ),
                              Text(
                                pesanan.whatsapp,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 13.2,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Icon(
                                  statusIcon,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12.8,
                                color: statusColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Divider(color: Colors.grey[300], thickness: 1.1),
                    const SizedBox(height: 8),
                    // TABEL INFO
                    Table(
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        _tableRow("Status", statusText, isBold: true),
                        _tableRow("Tanggal Terima", _formatTanggal(pesanan.createdAt), isBold: true),
                        _tableRow("Tanggal Selesai", _formatTanggal(pesanan.tanggalSelesai), isBold: true),
                        _tableRow("Jenis Parfum", pesanan.jenisParfum ?? "-"),
                        _tableRow("Layanan Antar Jemput", pesanan.antarJemput ?? "-"),
                        _tableRow("Catatan", pesanan.catatan ?? "-"),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Divider(color: Colors.grey[300], thickness: 1.05),
                    const SizedBox(height: 7),
                    // LIST ITEM
                    Row(
                      children: const [
                        Expanded(
                          flex: 5,
                          child: Text(
                            "List Item",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 14.7,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Jumlah",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 14.7,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ListView.separated(
                      itemCount: listItem.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => Divider(
                        color: Colors.grey[300],
                        thickness: 0.8,
                      ),
                      itemBuilder: (ctx, idx) {
                        final item = listItem[idx];
                        return Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 7,
                                ),
                                child: Text(
                                  item['nama'],
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14.5,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                item['jumlah'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14.3,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Divider(color: Colors.grey[400], thickness: 1.1),
                    const SizedBox(height: 4),
                    // TOTAL
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
                                color: totalColor,
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
                  ],
                ),
              ),
            ),
          ),
          // ===== BOTTOM BAR BUTTONS =====
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
              child: Row(
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
                  // Tidak ada tombol konfirmasi
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static TableRow _tableRow(String label, String value, {bool isBold = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
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
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            value,
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: 13.5,
              color: isBold ? Colors.blue : Colors.black,
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
