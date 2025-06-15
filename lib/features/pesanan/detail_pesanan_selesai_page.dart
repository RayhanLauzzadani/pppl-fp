import 'package:flutter/material.dart';
import 'pesanan_model.dart';

class DetailPesananSelesaiPage extends StatelessWidget {
  final Pesanan pesanan;
  const DetailPesananSelesaiPage({Key? key, required this.pesanan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ganti dengan data sebenarnya di model kamu
    final List<Map<String, dynamic>> laundryItems = [
      {"nama": "Bed Cover Jumbo", "tipe": "Satuan", "pcs": 1, "harga": 30000},
      {"nama": "Boneka Kecil", "tipe": "Satuan", "pcs": 3, "harga": 10000},
      {"nama": "Cuci Setrika", "tipe": "Kiloan", "pcs": 4, "harga": 24000},
      {"nama": "Selimut Single", "tipe": "Satuan", "pcs": 1, "harga": 10000},
    ];

    int totalBayar = laundryItems.fold(0, (v, item) => v + (item['harga'] as int));

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
                      const SizedBox(width: 44),
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
                                  "Nota–1157.1909.21  ${pesanan.tipe}",
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
                                          'https://randomuser.me/api/portraits/men/32.jpg'),
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
                          ),
                          // Badge Status di kanan
                          Column(
                            children: [
                              Icon(
                                Icons.help_outline_rounded, // status selesai → cek mappingmu
                                color: Color(0xFF40A2E3),
                                size: 26,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Belum diambil", // atau "Sudah diambil"
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                  color: Colors.black.withOpacity(0.66),
                                ),
                              ),
                            ],
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
                      const Text(
                        "Layanan Laundry :",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      ...laundryItems.map((item) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nama'],
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.5,
                                  ),
                                ),
                                Text(
                                  item['tipe'],
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.black54,
                                    fontSize: 12.2,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${item['pcs']} pcs",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 13.5,
                                  ),
                                ),
                                Text(
                                  "Rp. ${(item['harga'] as int).toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.black87,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
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
                                "Rp. ${totalBayar.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19.5,
                                ),
                              ),
                              const Text(
                                "(Sudah Bayar)",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Color(0xFF40A2E3),
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
                      "Sudah Diambil",
                      style: TextStyle(
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
