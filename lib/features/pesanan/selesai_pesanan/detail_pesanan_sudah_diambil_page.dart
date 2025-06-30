import 'package:flutter/material.dart';
import 'package:laundryin/features/pesanan/pesanan_model.dart';
import 'package:laundryin/features/pesanan/components/kendala_modal.dart';

class DetailPesananSudahDiambilPage extends StatelessWidget {
  final Pesanan pesanan;

  const DetailPesananSudahDiambilPage({super.key, required this.pesanan});

  @override
  Widget build(BuildContext context) {
    final statusColor = const Color(0xFF40A2E3);
    const statusText = "Sudah Diambil";
    const statusIcon = Icons.done_all_rounded;

    // List items gabungan layanan & barang satuan
    final List<Map<String, dynamic>> listItem = [];
    if (pesanan.jumlah != null) {
      pesanan.jumlah!.forEach((nama, qty) {
        if (qty > 0) {
          final harga = pesanan.hargaLayanan?[nama] ?? 0;
          final tipe = pesanan.layananTipe?[nama] ?? '';
          listItem.add({
            'nama': nama,
            'tipe': tipe,
            'jumlah': qty,
            'harga': harga,
            'hargaTotal': harga * qty,
          });
        }
      });
    }
    for (final barang in pesanan.barangList) {
      final nama = barang['title'] ?? barang['nama'] ?? '';
      final qty = pesanan.barangQty[nama] ?? 0;
      if (nama.toString().isNotEmpty && qty > 0) {
        listItem.add({
          'nama': nama,
          'tipe': 'Satuan',
          'jumlah': qty,
          'harga': 0,
          'hargaTotal': 0,
        });
      }
    }
    if (listItem.isEmpty) {
      listItem.add({
        'nama': 'Item Kosong',
        'tipe': '',
        'jumlah': 0,
        'harga': 0,
        'hargaTotal': 0,
      });
    }

    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 8, bottom: 15),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.02, 0.38, 0.83],
                  colors: [
                    Color(
                      0xFFFFF6E9,
                    ), // <<== sama kayak selesai_pesanan_page.dart
                    Color(0xFFBBE2EC),
                    Color(0xFF40A2E3),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(26),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x29000000),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, top: 4),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black87,
                          size: 22,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(height: 12),
                        Text(
                          "Detail Pesanan",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ===== CONTENT =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==== MAIN CARD ====
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1F88A5B4),
                            blurRadius: 16,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ===== HEADER NOTA & NAMA =====
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
                                            text: pesanan.desc.isEmpty
                                                ? "Reguler"
                                                : pesanan.desc,
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
                                    child: const Padding(
                                      padding: EdgeInsets.all(7),
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
                          const SizedBox(height: 15),
                          // TABEL INFO
                          Table(
                            columnWidths: const {
                              0: IntrinsicColumnWidth(),
                              1: FlexColumnWidth(),
                            },
                            children: [
                              _tableRow("Status", statusText, boldRight: true),
                              _tableRow(
                                "Tanggal Terima",
                                _formatTanggal(pesanan.createdAt),
                                boldRight: true,
                              ),
                              _tableRow(
                                "Tanggal Selesai",
                                _formatTanggal(pesanan.tanggalSelesai),
                                boldRight: true,
                              ),
                              _tableRow(
                                "Jenis Parfum",
                                pesanan.jenisParfum ?? "-",
                                boldRight: false,
                              ),
                              _tableRow(
                                "Layanan Antar Jemput",
                                pesanan.antarJemput ?? "-",
                                boldRight: false,
                              ),
                              _tableRow(
                                "Catatan",
                                pesanan.catatan ?? "-",
                                boldRight: false,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Divider(color: Colors.grey[400], thickness: 1.1),
                          const SizedBox(height: 7),
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
                                  Text(
                                    item['nama'],
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.5,
                                    ),
                                  ),
                                  if ((item['tipe'] ?? "")
                                      .toString()
                                      .isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 1,
                                        left: 1,
                                        bottom: 1,
                                      ),
                                      child: Text(
                                        "${item['tipe']}  ${item['jumlah']}pcs",
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12.7,
                                        ),
                                      ),
                                    ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "x Rp. ${_formatRupiah(item['harga'])}",
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12.4,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        "Rp. ${_formatRupiah(item['hargaTotal'])}",
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          SizedBox(height: screenHeight * 0.01),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ===== BOTTOM BAR =====
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.23),
                    blurRadius: 18,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(
                18,
                18,
                18,
                18 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Total pembayaran
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            "(Sudah Bayar)",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.w600,
                              fontSize: 13.7,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) =>
                                  KendalaModal(noHp: pesanan.whatsapp),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1976D2),
                            side: const BorderSide(
                              color: Color(0xFF1976D2),
                              width: 1.5,
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            textStyle: const TextStyle(fontFamily: "Poppins"),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.phone, size: 19),
                          label: const Text("Hubungi Pelanggan"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static TableRow _tableRow(
    String left,
    String right, {
    bool boldRight = false,
  }) {
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
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => "${m[1]}.",
    );
  }
}
