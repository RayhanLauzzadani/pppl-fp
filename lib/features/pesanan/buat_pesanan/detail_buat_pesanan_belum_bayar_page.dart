import 'package:flutter/material.dart';

class DetailBuatPesananBelumBayarPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const DetailBuatPesananBelumBayarPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ganti dengan data asli dari Map, di sini dummy biar gampang preview
    final String nota = "Nota–1157.1909.21";
    final String layanan = data['layanan'] ?? "Reguler";
    final String nama = data['nama'] ?? "Farhan Laksono";
    final String noHp = data['whatsapp'] ?? "+6281322214567";
    final String status = "Dalam Antrian";
    final String tanggalTerima = "22/10/2024 – 15:37";
    final String tanggalSelesai = "26/10/2024 – 08:00";
    final String jenisParfum = data['parfum'] ?? "Junjung Buih";
    final String antarJemput = data['antarJemput'] ?? "≤ 2 Km";
    final String catatan = data['catatan'] ?? "-";

    final List<Map<String, dynamic>> listBarang = [
      {
        'nama': 'Bed Cover Jumbo',
        'satuan': 'Satuan',
        'qty': 1,
        'harga': 30000,
        'total': 30000,
      },
      {
        'nama': 'Boneka Kecil',
        'satuan': 'Satuan',
        'qty': 3,
        'harga': 5000,
        'total': 15000,
      },
      {
        'nama': 'Cuci Setrika',
        'satuan': 'Kiloan',
        'qty': 4,
        'harga': 6000,
        'total': 24000,
      },
      {
        'nama': 'Selimut Single',
        'satuan': '',
        'qty': 0,
        'harga': 0,
        'total': 0,
      },
    ];
    final int totalHarga = 84000;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      body: Column(
        children: [
          // APPBAR Gradient custom
          _GradientAppBar(
            title: "Detail Pesanan",
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // CARD utama
                Container(
                  margin: const EdgeInsets.only(top: 16, left: 12, right: 12),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 14,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row atas: Nota, Print
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "$nota ",
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.3,
                                ),
                                children: [
                                  TextSpan(
                                    text: layanan,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: const [
                              Icon(Icons.print, size: 28, color: Color(0xFF727272)),
                              SizedBox(height: 2),
                              Text("Print Nota", style: TextStyle(fontFamily: 'Poppins', fontSize: 12.3)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Row profil
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(36),
                            child: Image.network(
                              "https://randomuser.me/api/portraits/men/32.jpg",
                              width: 46, height: 46, fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(nama, style: const TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, fontSize: 15.4)),
                                Text(noHp, style: const TextStyle(fontFamily: "Poppins", fontSize: 13.1, color: Colors.black87)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.grey[300], thickness: 0.7, height: 21),
                      _InfoRow("Status", status, boldValue: true),
                      _InfoRow("Tanggal Terima", tanggalTerima, boldValue: true),
                      _InfoRow("Tanggal Selesai", tanggalSelesai, boldValue: true),
                      _InfoRow("Jenis Parfum", jenisParfum, boldValue: true),
                      _InfoRow("Layanan Antar Jemput", antarJemput, boldValue: true),
                      _InfoRow("Catatan", catatan, boldValue: false),
                      Divider(color: Colors.grey[300], thickness: 0.7, height: 23),

                      // List Item Title
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 7),
                        child: const Text(
                          "Layanan Laundry :",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 14.7,
                          ),
                        ),
                      ),

                      ...listBarang.map((b) => _LaundryItemTile(b)).toList(),

                      const SizedBox(height: 9),

                      // TOTAL BAYAR
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 7),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F6F6),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "Total Pembayaran",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.7,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Rp. ${_currencyFormat(totalHarga)}",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w800,
                                    fontSize: 21,
                                    color: Colors.black,
                                  ),
                                ),
                                const Text(
                                  "(Belum Bayar)",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 13.6,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
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
                const SizedBox(height: 30),
              ],
            ),
          ),
          // Tombol bawah
          Container(
            width: double.infinity,
            color: const Color(0xFFFFF6E9),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBDE8F8),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Batalkan Pesanan",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15.7,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF279AF1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Lihat Proses",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15.7,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
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

  static String _currencyFormat(int price) {
    final s = price.toString();
    return s.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}

// Gradient AppBar khusus untuk detail pesanan
class _GradientAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  const _GradientAppBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 108,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.01, 0.12, 0.83],
          colors: [
            Color(0xFFFFF6E9),
            Color(0xFFBBE2EC),
            Color(0xFF40A2E3),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 21),
                onPressed: onBack,
              ),
            ),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 22.5,
                  letterSpacing: 0.1,
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
          ],
        ),
      ),
    );
  }
}

// Info Row
class _InfoRow extends StatelessWidget {
  final String keyText;
  final String value;
  final bool boldValue;
  const _InfoRow(this.keyText, this.value, {this.boldValue = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Text(
              keyText,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14.3,
                color: Colors.black.withOpacity(0.7),
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
                fontSize: 15.1,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Laundry Item Tile
Widget _LaundryItemTile(Map<String, dynamic> b) {
  return b['qty'] == 0
      ? Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Text(
            b['nama'],
            style: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              fontSize: 15.3,
              color: Colors.black87,
            ),
          ),
        )
      : Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                b['nama'],
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 15.4,
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    b['satuan'],
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13.1,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    "${b['qty']}pcs",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13.4,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Rp. ${_DetailBuatPesananBelumBayarPageState._currencyFormat(b['total'])}",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13.7,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              if (b['satuan'] != '' && b['harga'] != 0)
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 1),
                  child: Text(
                    "x Rp. ${_DetailBuatPesananBelumBayarPageState._currencyFormat(b['harga'])}",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 11.7,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        );
}

// For static method in Widget
class _DetailBuatPesananBelumBayarPageState {
  static String _currencyFormat(int price) {
    final s = price.toString();
    return s.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}
