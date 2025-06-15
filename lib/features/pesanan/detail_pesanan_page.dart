import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pesanan_model.dart';

class DetailPesananPage extends StatefulWidget {
  final Pesanan pesanan;
  const DetailPesananPage({super.key, required this.pesanan});

  @override
  State<DetailPesananPage> createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  final List<Map<String, dynamic>> listItem = [
    {"nama": "Baju", "jumlah": 11, "konfirmasi": false},
    {"nama": "Bed Cover Jumbo", "jumlah": 1, "konfirmasi": false},
    {"nama": "Boneka Kecil", "jumlah": 3, "konfirmasi": false},
    {"nama": "Celana", "jumlah": 2, "konfirmasi": false},
    {"nama": "Kemeja", "jumlah": 7, "konfirmasi": false},
    {"nama": "Selimut Single", "jumlah": 2, "konfirmasi": false},
    {"nama": "Sprei Single", "jumlah": 2, "konfirmasi": false},
  ];

  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.pesanan.status;
  }

  String get _phoneNumber => "+6281322214567";

  void _showKendalaSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF40A2E3),
                Color(0xFFBBE2EC),
                Color(0xFFFFF6E9),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(27)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Terdapat Kendala?",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 17),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final url = Uri.parse("https://wa.me/$_phoneNumber");
                        try {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Tidak bisa membuka WhatsApp"),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.phone, color: Color(0xFF2B303A)),
                      label: const Text(
                        "Hubungi Pelanggan",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xFF2B303A),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF6E9),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pesanan = widget.pesanan;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
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
                      const SizedBox(width: 44),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // CARD UTAMA
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
                      // HEADER STACK: Nota, user, badge status
                      Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "Nota–1157.1909.21 ",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.3,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: "Reguler",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      'https://randomuser.me/api/portraits/men/32.jpg',
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                    ),
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
                                      const Text(
                                        "+6281322214567",
                                        style: TextStyle(
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
                          // Badge Status di pojok kanan atas
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(13),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.11),
                                    blurRadius: 7,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _status == 'belum_mulai'
                                        ? Icons.close_rounded
                                        : _status == 'proses'
                                            ? Icons.radio_button_checked_rounded
                                            : Icons.done_all_rounded,
                                    color: _status == 'belum_mulai'
                                        ? const Color(0xFFFF6A6A)
                                        : _status == 'proses'
                                            ? const Color(0xFF52E18C)
                                            : const Color(0xFF40A2E3),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _status == 'belum_mulai'
                                        ? "Belum Mulai"
                                        : _status == 'proses'
                                            ? "Proses"
                                            : "Selesai",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.66),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.grey[400], thickness: 0.8, height: 23),
                      _infoRow("Status", "Dalam Antrian", boldValue: true),
                      _infoRow("Tanggal Terima", "22/10/2024 – 15:37", boldValue: true),
                      _infoRow("Tanggal Selesai", "26/10/2024 – 08:00", boldValue: true),
                      _infoRow("Jenis Parfum", "Junjung Buih", boldValue: true),
                      _infoRow("Layanan Antar Jemput", "≤ 2 Km", boldValue: true),
                      _infoRow("Catatan", "-", boldValue: false),
                      Divider(color: Colors.grey[400], thickness: 0.8, height: 24),
                      Row(
                        children: const [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "List Item",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 15.2,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Jumlah",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 15.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Konfirmasi",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 12.1, // biar ga kepotong
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      ...listItem.map((item) => Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                item["nama"],
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14.2,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${item["jumlah"]}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Checkbox(
                                value: item["konfirmasi"],
                                onChanged: (_status == 'proses')
                                    ? (val) {
                                        setState(() {
                                          item["konfirmasi"] = val ?? false;
                                        });
                                      }
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // BOTTOM BUTTONS
          Container(
            color: const Color(0xFFFFF6E9),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showKendalaSheet,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF40A2E3),
                      backgroundColor: const Color(0xFFE2F4FF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: const Text(
                      "Laporkan Kendala",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (_status == 'belum_mulai') {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _status = 'proses';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF40A2E3),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: const Text(
                            "Mulai Proses",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        );
                      } else if (_status == 'proses') {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _status = 'selesai';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF52E18C),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: const Text(
                            "Hentikan Proses",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        );
                      } else {
                        return ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF40A2E3),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: const Text(
                            "Selesaikan Proses",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        );
                      }
                    },
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
