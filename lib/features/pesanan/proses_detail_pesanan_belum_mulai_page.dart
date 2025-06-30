import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './pesanan_model.dart';
import 'proses_detail_pesanan_proses_page.dart';
import 'components/kendala_modal.dart';

class ProsesDetailPesananBelumMulaiPage extends StatefulWidget {
  final Pesanan pesanan;
  final String role;
  final String emailUser;
  final String passwordUser;
  final VoidCallback? onMulaiProses;

  const ProsesDetailPesananBelumMulaiPage({
    Key? key,
    required this.pesanan,
    required this.role,
    required this.emailUser,
    required this.passwordUser,
    this.onMulaiProses,
  }) : super(key: key);

  @override
  State<ProsesDetailPesananBelumMulaiPage> createState() =>
      _ProsesDetailPesananBelumMulaiPageState();
}

class _ProsesDetailPesananBelumMulaiPageState
    extends State<ProsesDetailPesananBelumMulaiPage> {
  late List<Map<String, dynamic>> listItem;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    listItem = [];

    // 1. Jenis Layanan (field jumlah)
    if (widget.pesanan.jumlah != null && widget.pesanan.jumlah!.isNotEmpty) {
      widget.pesanan.jumlah!.forEach((nama, qty) {
        if (nama.toLowerCase() == "laundry kiloan") return;
        if (qty > 0) {
          listItem.add({
            "nama": nama,
            "jumlah": qty.toString(),
            "konfirmasi": false,
          });
        }
      });
    }

    // 2. Barang Custom/Satuan
    for (final barang in widget.pesanan.barangList) {
      final nama = barang['title'] ?? barang['nama'] ?? '';
      final qty = widget.pesanan.barangQty[nama] ?? 0;
      if (nama.toString().isNotEmpty && qty > 0) {
        listItem.add({
          "nama": nama,
          "jumlah": qty.toString(),
          "konfirmasi": false,
        });
      }
    }

    // 3. Jika kosong, tetap tampil placeholder
    if (listItem.isEmpty) {
      listItem = [
        {"nama": "Item Kosong", "jumlah": "0", "konfirmasi": false},
      ];
    }
  }

  Future<void> _updateStatusProsesAndNavigate() async {
    setState(() => isLoading = true);
    try {
      // *** INI BAGIAN KRUSIAL: SIMPAN listItem ke selectedItems di Firestore! ***
      await FirebaseFirestore.instance
          .collection('laundries')
          .doc(widget.pesanan.kodeLaundry)
          .collection('pesanan')
          .doc(widget.pesanan.id)
          .update({
            'statusProses': 'proses',
            'selectedItems': listItem
                .where((item) => item['jumlah'] != "0")
                .toList(), // filter item kosong
          });

      final Pesanan prosesPesanan = widget.pesanan.copyWith(
        statusProses: 'proses',
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProsesDetailPesananProsesPage(
              pesanan: prosesPesanan,
              role: widget.role,
              emailUser: widget.emailUser,
              passwordUser: widget.passwordUser,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update status pesanan: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void handleLaporkanKendala() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => KendalaModal(noHp: widget.pesanan.whatsapp),
    );
  }

  // Helper format tanggal
  String _formatTanggal(DateTime? dt) {
    if (dt == null) return "-";
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final pesanan = widget.pesanan;

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
                  colors: [Color(0xFF52B6EC), Color(0xFFD2EDFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
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
                          color: Colors.white,
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
                  children: [
                    // ==== MAIN CARD ====
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      margin: const EdgeInsets.only(bottom: 22, top: 5),
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
                          // ======================== HEADER NOTA & NAMA ========================
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // No nota
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
                                    // Nama dan nomor
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
                              // Status badge
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6565),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Belum Mulai",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12.8,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 17),
                          Divider(color: Colors.grey[300], thickness: 1.1),
                          const SizedBox(height: 12),
                          // ======================== STATUS TABLE ========================
                          Table(
                            columnWidths: const {
                              0: IntrinsicColumnWidth(),
                              1: FlexColumnWidth(),
                            },
                            children: [
                              _tableRow(
                                "Status",
                                "Dalam Antrian",
                                boldRight: true,
                              ),
                              _tableRow(
                                "Tanggal Terima",
                                _formatTanggal(pesanan.createdAt),
                                boldRight: true,
                              ),
                              _tableRow(
                                "Tanggal Selesai",
                                "-",
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
                          Divider(color: Colors.grey[300], thickness: 1.05),
                          const SizedBox(height: 7),
                          // ======================== LIST ITEM TABLE ========================
                          Row(
                            children: const [
                              Expanded(
                                flex: 4,
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
                                flex: 2,
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
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Konfirmasi",
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
                          const SizedBox(height: 5),
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
                                    flex: 4,
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
                                    flex: 2,
                                    child: Text(
                                      item['jumlah'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14.3,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Checkbox(
                                      value: item['konfirmasi'],
                                      onChanged: null, // otomatis disabled
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      fillColor:
                                          MaterialStateProperty.resolveWith<
                                            Color
                                          >((states) {
                                            if (states.contains(
                                              MaterialState.disabled,
                                            )) {
                                              return Colors
                                                  .grey[300]!; // warna abu saat disabled
                                            }
                                            return Colors
                                                .blue; // warna saat aktif (tapi ini tidak akan kepake)
                                          }),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ===== BOTTOM BAR =====
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 15),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: handleLaporkanKendala,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF40A2E3),
                        side: const BorderSide(
                          color: Color(0xFF40A2E3),
                          width: 1.5,
                        ),
                        backgroundColor: const Color(0xFFE7F3FB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontFamily: "Poppins"),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Laporkan Kendala"),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : _updateStatusProsesAndNavigate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF40A2E3),
                        foregroundColor: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontFamily: "Poppins"),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Mulai Proses",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.23),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  TableRow _tableRow(String left, String right, {bool boldRight = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            left,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 13.1,
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
              fontSize: 13.2,
              fontWeight: boldRight ? FontWeight.bold : FontWeight.w500,
              color: boldRight ? Colors.blueGrey[900] : Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
