import 'package:flutter/material.dart';
import 'package:laundryin/features/pesanan/proses_pesanan_page.dart';

class DetailBuatPesananSelesaiBayarPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String role;
  final String emailUser;      // WAJIB TAMBAH
  final String passwordUser;   // WAJIB TAMBAH

  const DetailBuatPesananSelesaiBayarPage({
    Key? key,
    required this.data,
    required this.role,
    required this.emailUser,      // WAJIB
    required this.passwordUser,   // WAJIB
  }) : super(key: key);

  // Helper agar aman casting Map
  static Map<String, int> _safeMapInt(dynamic val) => (val is Map)
      ? Map<String, int>.from(
          val.map((k, v) => MapEntry(k.toString(), int.tryParse('$v') ?? 0)),
        )
      : {};
  static Map<String, String> _safeMapString(dynamic val) => (val is Map)
      ? Map<String, String>.from(
          val.map((k, v) => MapEntry(k.toString(), v.toString())),
        )
      : {};

  @override
  Widget build(BuildContext context) {
    final String nota =
        data['nota'] ?? "Nota–${DateTime.now().millisecondsSinceEpoch}";
    final String layanan = data['layanan'] ?? "-";
    final String nama = data['nama'] ?? "-";
    final String noHp = data['whatsapp'] ?? "-";
    final String status = data['status'] ?? "Dalam Antrian";
    final String tanggalTerima = data['tanggalTerima'] ?? _nowString();
    final String tanggalSelesai = data['tanggalSelesai'] ?? "-";
    final String jenisParfum =
        (data['parfum']?.toString().trim().isNotEmpty ?? false)
            ? data['parfum'].toString()
            : (data['jenisParfum']?.toString().trim().isNotEmpty ?? false)
                ? data['jenisParfum'].toString()
                : "-";
    final String antarJemput =
        (data['antarJemput']?.toString().trim().isNotEmpty ?? false)
            ? data['antarJemput'].toString()
            : "-";
    final String catatan =
        (data['catatan']?.toString().trim().isNotEmpty ?? false)
            ? data['catatan'].toString()
            : "-";
    // ambil label diskon
    final String diskon = (data['labelDiskon']?.toString().trim().isNotEmpty ?? false)
        ? data['labelDiskon'].toString()
        : ((data['diskon']?.toString().trim().isNotEmpty ?? false)
            ? data['diskon'].toString()
            : "-");

    // Data layanan laundry
    final double beratKg = data['beratKg'] == null
        ? 0.0
        : (data['beratKg'] is double
              ? data['beratKg']
              : double.tryParse(data['beratKg'].toString()) ?? 0.0);
    final Map<String, int> jumlah = _safeMapInt(data['jumlah']);
    final List<Map<String, dynamic>> barangList = (data['barangList'] ?? [])
        .cast<Map<String, dynamic>>();
    final Map<String, int> barangQty = _safeMapInt(data['barangQty']);
    final Map<String, int> hargaLayanan = _safeMapInt(data['hargaLayanan']);
    final Map<String, String> tipeLayanan = _safeMapString(data['layananTipe']);

    List<Map<String, dynamic>> layananLaundry = [];

    // Laundry kiloan (dari bar)
    if (beratKg > 0) {
      layananLaundry.add({
        'nama': "Laundry Kiloan",
        'satuan': "Kg",
        'qty': beratKg,
        'harga': 10000,
        'total': (10000 * beratKg).round(),
      });
    }

    // Layanan paket
    jumlah.forEach((namaLayanan, qty) {
      if (qty > 0) {
        String tipe = (tipeLayanan[namaLayanan] ?? "").toLowerCase();
        String satuan = tipe == "kiloan" ? "Kg" : "Sat";
        int harga = hargaLayanan[namaLayanan] ?? 0;
        if (namaLayanan.toLowerCase() != "laundry kiloan") {
          layananLaundry.add({
            'nama': namaLayanan,
            'satuan': satuan,
            'qty': qty,
            'harga': harga,
            'total': harga * qty,
          });
        }
      }
    });

    // Custom barang
    for (final b in barangList) {
      final nama = b['title'] ?? "";
      final qty = barangQty[nama] ?? 0;
      if (qty > 0) {
        layananLaundry.add({
          'nama': nama,
          'satuan': "Sat",
          'qty': qty,
          'harga': 0,
          'total': 0,
        });
      }
    }

    // Harga total dan harga sebelum diskon
    final int hargaSebelumDiskon = data['hargaSebelumDiskon'] ?? data['totalHarga'] ?? 0;
    int totalHarga = data['totalHarga'] ?? 0;
    if (totalHarga == 0) {
      totalHarga = layananLaundry.fold(
        0,
        (sum, e) => sum + (e['total'] as int? ?? 0),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      body: Column(
        children: [
          _GradientAppBar(
            title: "Detail Pesanan",
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 16, left: 12, right: 12),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
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
                      // Nota + Layanan + Print
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
                              Icon(
                                Icons.print,
                                size: 28,
                                color: Color(0xFF727272),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Print Nota",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12.3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Data nama & WA
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nama,
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.4,
                                  ),
                                ),
                                Text(
                                  noHp,
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 13.1,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 0.7,
                        height: 21,
                      ),
                      _InfoRow("Status", status, boldValue: true),
                      _InfoRow(
                        "Tanggal Terima",
                        tanggalTerima,
                        boldValue: true,
                      ),
                      _InfoRow(
                        "Tanggal Selesai",
                        tanggalSelesai,
                        boldValue: true,
                      ),
                      _InfoRow("Jenis Parfum", jenisParfum, boldValue: true),
                      _InfoRow(
                        "Layanan Antar Jemput",
                        antarJemput,
                        boldValue: true,
                      ),
                      _InfoRow("Diskon", diskon, boldValue: true),
                      _InfoRow("Catatan", catatan, boldValue: false),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 0.7,
                        height: 23,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5, top: 7),
                        child: Text(
                          "Layanan Laundry :",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 14.7,
                          ),
                        ),
                      ),
                      ...layananLaundry
                          .map((b) => _LaundryItemTile(b))
                          .toList(),
                      const SizedBox(height: 9),

                      // Harga sebelum diskon, jika memang diskon
                      if (hargaSebelumDiskon > totalHarga)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2, left: 2, right: 2),
                          child: Row(
                            children: [
                              const Text(
                                "Harga Sebelum Diskon:",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.7,
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                "Rp. ${_currencyFormat(hargaSebelumDiskon)}",
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.redAccent,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // TOTAL BAYAR
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 7),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 13,
                        ),
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
                                  "(Sudah Bayar)",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 13.6,
                                    color: Color(0xFF2096F3),
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProsesPesananPage(
                            kodeLaundry: data['kodeLaundry'] ?? '',
                            role: role,
                            emailUser: emailUser,        // WAJIB!
                            passwordUser: passwordUser,  // WAJIB!
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD5F1FA),
                      foregroundColor: Colors.black87,
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

  static String _currencyFormat(num price) {
    final s = price.toStringAsFixed(0);
    return s.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  static String _nowString() {
    final now = DateTime.now();
    final jam = now.hour.toString().padLeft(2, '0');
    final menit = now.minute.toString().padLeft(2, '0');
    return "${now.day}/${now.month}/${now.year} – $jam.$menit";
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
          colors: [Color(0xFFFFF6E9), Color(0xFFBBE2EC), Color(0xFF40A2E3)],
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
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 21,
                ),
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
  final String satuan = b['satuan'] ?? '';
  final harga = b['harga'] ?? 0;
  final total = b['total'] ?? 0;
  final qty = b['qty'];
  String qtyText = satuan == "Kg" ? "$qty Kg" : "$qty pcs";
  return qty == 0
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
            border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
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
                    satuan,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13.1,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    qtyText,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13.4,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Rp. ${DetailBuatPesananSelesaiBayarPage._currencyFormat(total)}",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13.7,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              if (satuan != '' && harga != 0)
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 1),
                  child: Text(
                    "x Rp. ${DetailBuatPesananSelesaiBayarPage._currencyFormat(harga)}",
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
