import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundryin/features/pesanan/pesanan_model.dart';
import 'package:laundryin/features/pesanan/components/kendala_modal.dart';

class DetailPesananBelumBayarPage extends StatelessWidget {
  final Pesanan pesanan;
  final VoidCallback? onKonfirmasiBayar;

  const DetailPesananBelumBayarPage({
    super.key,
    required this.pesanan,
    this.onKonfirmasiBayar,
  });

  @override
  Widget build(BuildContext context) {
    // List items gabungan layanan dan barang satuan
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
    // Barang custom/satuan
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
    // Jika item kosong
    if (listItem.isEmpty) {
      listItem.add({
        'nama': 'Item Kosong',
        'tipe': '',
        'jumlah': 0,
        'harga': 0,
        'hargaTotal': 0,
      });
    }

    final double screenHeight = 1.sh;

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
                    Color(0xFFFFF6E9),
                    Color(0xFFBBE2EC),
                    Color(0xFF40A2E3),
                  ],
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
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
                          color: Colors.black87, // <-- HITAM
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
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==== MAIN CARD ====
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
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
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.8.sp,
                                            ),
                                          ),
                                          TextSpan(
                                            text: pesanan.desc.isEmpty ? "Reguler" : pesanan.desc,
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black54,
                                              fontSize: 13.7.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      pesanan.nama,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.4.sp,
                                      ),
                                    ),
                                    Text(
                                      pesanan.whatsapp,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 13.2.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Status badge (merah X)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF6A6A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(7.w),
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: Colors.white,
                                        size: 26.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    "Belum Bayar",
                                    style: TextStyle(
                                      color: const Color(0xFFFF6A6A),
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.8.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          // TABEL INFO
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
                                _formatTanggal(pesanan.tanggalSelesai), // <<-- MODIFIKASI DISINI
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
                          SizedBox(height: 14.h),
                          Divider(color: Colors.grey[400], thickness: 1.1),
                          SizedBox(height: 7.h),
                          Text(
                            "Layanan Laundry :",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 14.7.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ...listItem.map((item) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 11.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['nama'],
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.5.sp,
                                    ),
                                  ),
                                  if ((item['tipe'] ?? "").toString().isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 1.h, left: 1.w, bottom: 1.h),
                                      child: Text(
                                        "${item['tipe']}  ${item['jumlah']}pcs",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12.7.sp,
                                        ),
                                      ),
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "x Rp. ${_formatRupiah(item['harga'])}",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12.4.sp,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        "Rp. ${_formatRupiah(item['hargaTotal'])}",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),

                          // Anti overflowed
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
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22.r),
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
                18.w,
                18.h,
                18.w,
                18.h + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch, // Kiri, bukan center
                children: [
                  // Total pembayaran (kiri)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Total Pembayaran",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.1.sp,
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
                              fontSize: 21.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            "(Belum Bayar)",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: const Color(0xFFD32F2F),
                              fontWeight: FontWeight.w600,
                              fontSize: 13.7.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
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
                              borderRadius: BorderRadius.circular(13.r),
                            ),
                            textStyle: TextStyle(fontFamily: "Poppins"),
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                            elevation: 0,
                          ),
                          icon: Icon(Icons.phone, size: 19.sp),
                          label: Text("Hubungi Pelanggan"),
                        ),
                      ),
                      SizedBox(width: 13.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onKonfirmasiBayar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2), // Biru
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.r),
                            ),
                            textStyle: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                          ),
                          child: Text("Konfirmasi Bayar"),
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
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Text(
            left,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 13.2.sp,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Text(
            right,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 13.4.sp,
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
