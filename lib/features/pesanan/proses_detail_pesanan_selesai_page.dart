import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './pesanan_model.dart';
import 'components/kendala_modal.dart';
import 'package:laundryin/features/pesanan/selesai pesanan/selesai_pesanan_page.dart';

class ProsesDetailPesananSelesaiPage extends StatefulWidget {
  final Pesanan pesanan;
  final String role;
  final String emailUser;
  final String passwordUser;
  final List<Map<String, dynamic>>? selectedItems;

  const ProsesDetailPesananSelesaiPage({
    Key? key,
    required this.pesanan,
    required this.role,
    required this.emailUser,
    required this.passwordUser,
    this.selectedItems,
  }) : super(key: key);

  @override
  State<ProsesDetailPesananSelesaiPage> createState() =>
      _ProsesDetailPesananSelesaiPageState();
}

class _ProsesDetailPesananSelesaiPageState
    extends State<ProsesDetailPesananSelesaiPage> {
  List<Map<String, dynamic>> listItem = [];
  bool isLoading = false;
  bool isLoaded = false; // Untuk mencegah rebuild berkali-kali

  @override
  void initState() {
    super.initState();
    _loadSelectedItems();
  }

  Future<void> _loadSelectedItems() async {
    final kodeLaundry = widget.pesanan.kodeLaundry ?? '';
    final id = widget.pesanan.id;

    // 1. Jika argumen selectedItems terisi dan tidak kosong, pakai itu!
    if (widget.selectedItems != null && widget.selectedItems!.isNotEmpty) {
      setState(() {
        listItem = widget.selectedItems!.map((e) => {...e, 'konfirmasi': true}).toList();
        isLoaded = true;
      });
      return;
    }

    // 2. Jika tidak, cek Firestore field 'selectedItems'
    if (kodeLaundry.isNotEmpty && id.isNotEmpty) {
      final doc = await FirebaseFirestore.instance
          .collection('laundries')
          .doc(kodeLaundry)
          .collection('pesanan')
          .doc(id)
          .get();

      final data = doc.data() ?? {};
      final List<dynamic>? firestoreSelectedItems = data['selectedItems'];

      if (firestoreSelectedItems != null && firestoreSelectedItems.isNotEmpty) {
        setState(() {
          listItem = firestoreSelectedItems
              .map((e) => Map<String, dynamic>.from(e)..['konfirmasi'] = true)
              .toList();
          isLoaded = true;
        });
        return;
      }
    }

    // 3. Fallback, logika lama (jika selectedItems tetap kosong)
    List<Map<String, dynamic>> fallback = [];
    if (widget.pesanan.jumlah != null && widget.pesanan.jumlah!.isNotEmpty) {
      widget.pesanan.jumlah!.forEach((nama, qty) {
        if (nama.toLowerCase() == "laundry kiloan") return;
        if (qty > 0) {
          fallback.add({
            "nama": nama,
            "jumlah": qty.toString(),
            "konfirmasi": true,
          });
        }
      });
    }
    for (final barang in widget.pesanan.barangList) {
      final nama = barang['title'] ?? barang['nama'] ?? '';
      final qty = widget.pesanan.barangQty[nama] ?? 0;
      if (nama.toString().isNotEmpty && qty > 0) {
        fallback.add({
          "nama": nama,
          "jumlah": qty.toString(),
          "konfirmasi": true,
        });
      }
    }
    if (fallback.isEmpty) {
      fallback = [
        {"nama": "Item Kosong", "jumlah": "0", "konfirmasi": true},
      ];
    }
    setState(() {
      listItem = fallback;
      isLoaded = true;
    });
  }

  void handleLaporkanKendala() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => KendalaModal(noHp: widget.pesanan.whatsapp ?? "-"),
    );
  }

  Future<void> handleSelesaikanProses() async {
    setState(() => isLoading = true);
    try {
      final kodeLaundry = widget.pesanan.kodeLaundry ?? '';
      if (kodeLaundry.isEmpty) throw Exception('Kode laundry kosong!');

      await FirebaseFirestore.instance
          .collection('laundries')
          .doc(kodeLaundry)
          .collection('pesanan')
          .doc(widget.pesanan.id)
          .update({'status': 'selesai'});

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => SelesaiPesananPage(
              kodeLaundry: kodeLaundry,
              role: widget.role,
              emailUser: widget.emailUser,
              passwordUser: widget.passwordUser,
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update status pesanan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

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
        child: isLoaded
            ? Column(
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
                                // ===== HEADER NOTA & NAMA =====
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
                                          Text(
                                            pesanan.nama,
                                            style: const TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15.4,
                                            ),
                                          ),
                                          Text(
                                            pesanan.whatsapp ?? "-",
                                            style: const TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 13.2,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Status badge (BIRU TOSCA)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF40A2E3),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 26,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Selesai",
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
                                // ===== STATUS TABLE =====
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
                                // ===== LIST ITEM TABLE =====
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
                                            item['jumlah'].toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 14.3,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Center(
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 180),
                                              curve: Curves.easeInOut,
                                              child: Checkbox(
                                                value: true,
                                                onChanged: null, // disable
                                                activeColor: const Color(0xFF40A2E3),
                                                checkColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(7),
                                                  side: const BorderSide(
                                                    width: 1.4,
                                                    color: Color(0xFF40A2E3),
                                                  ),
                                                ),
                                                side: const BorderSide(
                                                  color: Color(0xFFBFD9F6),
                                                  width: 1.3,
                                                ),
                                                splashRadius: 22,
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                                              ),
                                            ),
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
                            onPressed: isLoading ? null : handleSelesaikanProses,
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
                              "Selesaikan Proses",
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
              )
            : const Center(child: CircularProgressIndicator()),
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
