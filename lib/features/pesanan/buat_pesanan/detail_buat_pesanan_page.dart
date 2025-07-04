import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import 'widgets/pdf_nota_laundry.dart';
import 'detail_buat_pesanan_belum_bayar_page.dart';
import 'detail_buat_pesanan_selesai_bayar_page.dart';

class DetailBuatPesananPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String role;
  final String laundryId;
  final String emailUser;
  final String passwordUser;

  const DetailBuatPesananPage({
    super.key,
    required this.data,
    required this.role,
    required this.laundryId,
    required this.emailUser,
    required this.passwordUser,
  });

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
    final String nota = "Nota–${DateTime.now().millisecondsSinceEpoch}";
    final String layanan = data['layanan'] ?? "-";
    final String nama = data['nama'] ?? "-";
    final String noHp = data['whatsapp'] ?? "-";
    final String status = "Dalam Antrian";
    final String tanggalTerima = _nowString();
    final String tanggalSelesai = "-";
    final String jenisParfum =
        (data['jenisParfum']?.toString().trim().isEmpty ?? true)
        ? "-"
        : data['jenisParfum'].toString();
    final String antarJemput =
        (data['antarJemput']?.toString().trim().isEmpty ?? true)
        ? "-"
        : data['antarJemput'].toString();
    final String diskon = (data['diskon']?.toString().trim().isEmpty ?? true)
        ? "-"
        : data['diskon'].toString();
    final String catatan = (data['catatan']?.toString().trim().isEmpty ?? true)
        ? "-"
        : data['catatan'].toString();

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

    final int hargaSebelumDiskon =
        data['hargaSebelumDiskon'] ?? data['totalHarga'] ?? 0;
    final int hargaDiskon = data['totalHarga'] ?? 0;
    final String labelDiskon =
        data['labelDiskon'] ?? (diskon != '-' ? diskon : '');

    List<Map<String, dynamic>> listBarangFinal = [];

    if (beratKg > 0) {
      listBarangFinal.add({
        'nama': "Laundry Kiloan",
        'satuan': "Kg",
        'qty': beratKg,
        'harga': 10000,
        'total': (10000 * beratKg).round(),
      });
    }

    jumlah.forEach((namaLayanan, qty) {
      if (qty > 0) {
        String tipe = (tipeLayanan[namaLayanan] ?? "").toLowerCase();
        String satuan = tipe == "kiloan" ? "Kg" : "Sat";
        int harga = hargaLayanan[namaLayanan] ?? 0;
        if (namaLayanan.toLowerCase() != "laundry kiloan") {
          listBarangFinal.add({
            'nama': namaLayanan,
            'satuan': satuan,
            'qty': qty,
            'harga': harga,
            'total': harga * qty,
          });
        }
      }
    });

    for (final b in barangList) {
      final nama = b['title'] ?? "";
      final qty = barangQty[nama] ?? 0;
      if (qty > 0) {
        listBarangFinal.add({
          'nama': nama,
          'satuan': "Sat",
          'qty': qty,
          'harga': 0,
          'total': 0,
        });
      }
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
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.print,
                                  size: 28,
                                  color: Color(0xFF727272),
                                ),
                                onPressed: () async {
                                  final Uint8List logoBytes = await rootBundle
                                      .load('assets/images/logo.png')
                                      .then((bd) => bd.buffer.asUint8List());
                                  await Printing.layoutPdf(
                                    onLayout: (format) =>
                                        generateNotaLaundryPdf(
                                          logoBytes: logoBytes,
                                          nota: nota,
                                          layanan: layanan,
                                          nama: nama,
                                          noHp: noHp,
                                          status: status,
                                          tanggalTerima: tanggalTerima,
                                          tanggalSelesai: tanggalSelesai,
                                          jenisParfum: jenisParfum,
                                          antarJemput: antarJemput,
                                          diskon: diskon,
                                          catatan: catatan,
                                          listBarangFinal: listBarangFinal,
                                          hargaSebelumDiskon:
                                              hargaSebelumDiskon,
                                          hargaDiskon: hargaDiskon,
                                          labelDiskon: labelDiskon,
                                        ),
                                    name: 'Nota_Laundry_$nota.pdf',
                                  );
                                },
                              ),
                              const SizedBox(height: 2),
                              const Text(
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
                      ...listBarangFinal.map((b) => laundryItemTile(b)),
                      const SizedBox(height: 9),
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
                                if (hargaSebelumDiskon > hargaDiskon) ...[
                                  Text(
                                    "Rp. ${formatRupiah(hargaSebelumDiskon)}",
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.redAccent,
                                      fontSize: 16,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      if (labelDiskon.isNotEmpty)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            right: 6,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF40A2E3),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            labelDiskon,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Poppins",
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      Text(
                                        "-Rp. ${formatRupiah(hargaSebelumDiskon - hargaDiskon)}",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Poppins",
                                          fontSize: 15.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                Text(
                                  "Rp. ${formatRupiah(hargaDiskon)}",
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
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailBuatPesananBelumBayarPage(
                                  data: data,
                                  role: role,
                                  laundryId: laundryId,
                                  emailUser: emailUser,
                                  passwordUser: passwordUser,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: const Color(0xFFE2F4FF),
                            foregroundColor: const Color(0xFF1D90C6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: const Text(
                            "Bayar Nanti",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 17.7,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final String? pesananId = data['id'];
                            if (pesananId == null || pesananId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("ID pesanan tidak ditemukan!"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            await FirebaseFirestore.instance
                                .collection('laundries')
                                .doc(laundryId)
                                .collection('pesanan')
                                .doc(pesananId)
                                .update({'statusTransaksi': 'belum_diambil'});

                            final updatedDoc = await FirebaseFirestore.instance
                                .collection('laundries')
                                .doc(laundryId)
                                .collection('pesanan')
                                .doc(pesananId)
                                .get();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailBuatPesananSelesaiBayarPage(
                                      data: updatedDoc.data()!
                                        ..['id'] = pesananId,
                                      role: role,
                                      emailUser: emailUser,
                                      passwordUser: passwordUser,
                                    ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: const Color(0xFF40A2E3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: const Text(
                            "Bayar Sekarang",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 17.7,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _nowString() {
    final now = DateTime.now();
    final jam = now.hour.toString().padLeft(2, '0');
    final menit = now.minute.toString().padLeft(2, '0');
    return "${now.day}/${now.month}/${now.year} – $jam.$menit";
  }
}

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

Widget laundryItemTile(Map<String, dynamic> b) {
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
                    "Rp. ${formatRupiah(total)}",
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
                    "x Rp. ${formatRupiah(harga)}",
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
