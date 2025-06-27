import 'package:flutter/material.dart';
import 'widgets/barang_custom_tile.dart';
import 'widgets/layanan_satuan_tile.dart';
import 'widgets/info_badge.dart';
import 'widgets/gradient_appbar.dart';
import 'widgets/bottom_sheet_konfirmasi.dart';
import 'detail_buat_pesanan_page.dart';

class PilihLayananPage extends StatefulWidget {
  final String nama;
  final String whatsapp;
  final String layanan;
  final String desc;
  final String kodeLaundry;

  const PilihLayananPage({
    Key? key,
    required this.nama,
    required this.whatsapp,
    required this.layanan,
    required this.desc,
    required this.kodeLaundry,
  }) : super(key: key);

  @override
  State<PilihLayananPage> createState() => _PilihLayananPageState();
}

class _PilihLayananPageState extends State<PilihLayananPage> {
  final TextEditingController beratController = TextEditingController();
  final TextEditingController barangController = TextEditingController();
  String? beratInputError;
  String? barangInputError;

  double beratKg = 0.0;
  List<Map<String, dynamic>> barangList = [];
  Map<String, int> barangQty = {};

  final List<Map<String, dynamic>> layananList = [
    {'title': 'Bed Cover Double', 'price': 20000},
    {'title': 'Bed Cover Jumbo', 'price': 30000},
    {'title': 'Bed Cover Single', 'price': 12500},
    {'title': 'Boneka Besar', 'price': 20000},
    {'title': 'Boneka Kecil', 'price': 5000},
    {'title': 'Boneka Sedang', 'price': 15000},
  ];
  Map<String, int> jumlah = {};
  String search = '';

  @override
  void initState() {
    super.initState();
    for (var l in layananList) {
      jumlah[l['title']] = 0;
    }
  }

  int get totalHarga {
    int total = (beratKg * 10000).round();
    for (var l in layananList) {
      total += (jumlah[l['title']]! * l['price']).toInt();
    }
    return total;
  }

  int get totalSatuan {
    int total = 0;
    for (var v in barangQty.values) {
      total += v;
    }
    for (var v in jumlah.values) {
      total += v;
    }
    return total;
  }

  List<Map<String, dynamic>> get filteredLayanan {
    if (search.trim().isEmpty) return layananList;
    return layananList
        .where(
          (l) => l['title'].toString().toLowerCase().contains(
            search.trim().toLowerCase(),
          ),
        )
        .toList();
  }

  void _addBarangCustom() {
    String barang = barangController.text.trim();
    if (barang.isEmpty) {
      setState(() => barangInputError = "Nama barang tidak boleh kosong");
      return;
    }
    if (!barangQty.containsKey(barang)) {
      setState(() {
        barangList.add({'title': barang});
        barangQty[barang] = 0;
      });
    }
    setState(() {
      barangController.clear();
      barangInputError = null;
    });
  }

  @override
  void dispose() {
    beratController.dispose();
    barangController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar Gradient (bisa pakai GradientAppBar kalau mau konsisten!)
            GradientAppBar(
              title: 'Buat Pesanan',
              onBack: () => Navigator.pop(context),
            ),

            // SEARCH BOX
            Padding(
              padding: const EdgeInsets.only(top: 18, left: 18, right: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F3EA),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 15),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF295E52),
                      size: 25,
                    ),
                    border: InputBorder.none,
                    hintText: 'Cari nama layanan',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF5E6D7A),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: 0.1,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 13),
                  ),
                  onChanged: (v) {
                    setState(() {
                      search = v;
                    });
                  },
                ),
              ),
            ),

            // Field Berat
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                left: 18,
                right: 18,
                bottom: 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: beratController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Berat (Kg)',
                        isDense: true,
                        errorText: beratInputError,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Color(0xFFD2D2D2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Color(0xFFD2D2D2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Color(0xFF4EA6ED),
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.7,
                      ),
                      onChanged: (v) {
                        setState(() {
                          try {
                            beratKg = double.parse(v.replaceAll(',', '.'));
                            beratInputError = null;
                          } catch (_) {
                            beratKg = 0.0;
                            beratInputError = "Format berat tidak valid";
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Field Nama Barang (Custom/Satuan)
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                left: 18,
                right: 18,
                bottom: 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: barangController,
                      decoration: InputDecoration(
                        hintText: 'Nama barang (satuan)',
                        isDense: true,
                        errorText: barangInputError,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Color(0xFFD2D2D2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Color(0xFFD2D2D2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Color(0xFF4EA6ED),
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.7,
                      ),
                      onSubmitted: (v) => _addBarangCustom(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addBarangCustom,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      backgroundColor: const Color(0xFF1D90C6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Catat',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.2,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List Barang Custom + Layanan Utama
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Barang Custom
                  if (barangList.isNotEmpty)
                    ...barangList.map(
                      (b) => BarangCustomTile(
                        title: b['title'],
                        qty: barangQty[b['title']] ?? 0,
                        onTambah: () {
                          setState(() {
                            barangQty[b['title']] =
                                (barangQty[b['title']] ?? 0) + 1;
                          });
                        },
                        onKurang: () {
                          setState(() {
                            if ((barangQty[b['title']] ?? 0) > 0) {
                              barangQty[b['title']] =
                                  barangQty[b['title']]! - 1;
                            }
                          });
                        },
                      ),
                    ),

                  // Layanan Utama
                  ...filteredLayanan.map(
                    (item) => LayananSatuanTile(
                      nama: item['title'],
                      harga: item['price'],
                      jumlah: jumlah[item['title']] ?? 0,
                      onTambah: () {
                        setState(() {
                          jumlah[item['title']] =
                              (jumlah[item['title']] ?? 0) + 1;
                        });
                      },
                      onKurang: () {
                        setState(() {
                          if ((jumlah[item['title']] ?? 0) > 0) {
                            jumlah[item['title']] = jumlah[item['title']]! - 1;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // INFO USER
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.nama,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 15.1,
                            color: Color(0xFF222222),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.whatsapp,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13.3,
                            color: Color(0xFF858585),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InfoBadge(
                    beratKg == 0
                        ? '0'
                        : beratKg.toStringAsFixed(1).replaceAll('.0', ''),
                    'Kg',
                  ),
                  const SizedBox(width: 7),
                  InfoBadge('${totalSatuan}', 'Sat'),
                ],
              ),
            ),

            // TOTAL & NEXT BUTTON
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFFCF7F2),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rp. ${_currencyFormat(totalHarga)}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 19.5,
                            color: Color(0xFF252525),
                          ),
                        ),
                        const Text(
                          'Total Pesanan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13.3,
                            color: Color(0xFF6A6A6A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(21),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => BottomSheetKonfirmasi(
                          onSubmit: (konfirmasiData) {
                            // Gabungkan semua data yang kamu butuhkan dari PilihLayananPage dan BottomSheetKonfirmasi
                            final pesananData = {
                              'nama': widget.nama,
                              'whatsapp': widget.whatsapp,
                              'layanan': widget.layanan,
                              'desc': widget.desc,
                              'kodeLaundry': widget.kodeLaundry,
                              'beratKg': beratKg,
                              'barangList': barangList,
                              'barangQty': barangQty,
                              'jumlah': jumlah,
                              'totalHarga': totalHarga,
                              // Data dari bottom sheet:
                              'parfum': konfirmasiData['parfum'],
                              'antarJemput': konfirmasiData['antarJemput'],
                              'diskon': konfirmasiData['diskon'],
                              'catatan': konfirmasiData['catatan'],
                            };

                            Navigator.pop(context); // Tutup bottomsheet dulu

                            // Lanjut navigate ke halaman detail
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailBuatPesananPage(data: pesananData),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4F1FB),
                        borderRadius: BorderRadius.circular(21),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1.5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 9,
                      ),
                      child: Row(
                        children: const [
                          Text(
                            'Next',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1D90C6),
                              fontSize: 15.3,
                            ),
                          ),
                          SizedBox(width: 7),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFF1D90C6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
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
