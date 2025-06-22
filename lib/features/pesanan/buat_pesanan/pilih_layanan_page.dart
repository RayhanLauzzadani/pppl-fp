import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/gradient_appbar.dart';
import 'widgets/layanan_satuan_tile.dart';
import 'widgets/bottom_sheet_detail_pesanan.dart';

class PilihLayananPage extends StatefulWidget {
  final String nama;
  final String whatsapp;
  final String layanan;
  final String desc;
  final String kodeLaundry;

  const PilihLayananPage({
    super.key,
    required this.nama,
    required this.whatsapp,
    required this.layanan,
    required this.desc,
    required this.kodeLaundry,
  });

  @override
  State<PilihLayananPage> createState() => _PilihLayananPageState();
}

class _PilihLayananPageState extends State<PilihLayananPage> {
  final searchController = TextEditingController();

  // State jumlah item dipilih
  final Map<String, int> jumlahDipilih = {};
  // Simpan harga layanan supaya bisa dipakai di bottom bar summary!
  final Map<String, int> _hargaLayanan = {};

  // Kiloan
  double kiloan = 0.0;
  final int hargaPerKg = 10000;
  final Map<String, int> kiloanJenis = {
    "Atasan": 0,
    "Bawahan": 0,
    "Lain-lain": 0,
  };

  int get totalJenisKiloan => kiloanJenis.values.fold(0, (a, b) => a + b);
  int get totalQty => jumlahDipilih.values.fold(0, (a, b) => a + b);
  int get totalKiloanHarga => (kiloan > 0 ? (kiloan * hargaPerKg).round() : 0);

  int get totalHargaSatuan {
    int total = 0;
    jumlahDipilih.forEach((nama, qty) {
      final harga = _hargaLayanan[nama] ?? 0;
      total += harga * qty;
    });
    return total;
  }

  int get totalHarga => totalKiloanHarga + totalHargaSatuan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF6),
      appBar: const GradientAppBar(title: "Buat Pesanan"),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 135),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 15, 18, 16),
                  child: Material(
                    color: const Color(0xFFFCF2E5),
                    borderRadius: BorderRadius.circular(14),
                    elevation: 2,
                    child: TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF3E847A),
                          size: 26,
                        ),
                        hintText: "Cari nama layanan",
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3E847A),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 8,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                // Firestore ListView: layanan satuan (realtime)
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('laundries')
                        .doc(widget.kodeLaundry)
                        .collection('layanan_satuan')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Error loading data'));
                      }
                      final docs = snapshot.data?.docs ?? [];
                      // Filter search
                      final filtered = docs.where((doc) {
                        final nama = (doc['nama'] ?? '')
                            .toString()
                            .toLowerCase();
                        return nama.contains(
                          searchController.text.toLowerCase(),
                        );
                      }).toList();

                      // Update hargaLayanan dari Firestore (sync nama -> harga)
                      for (var doc in docs) {
                        final nama = doc['nama'] ?? '';
                        final harga = doc['harga'] ?? 0;
                        _hargaLayanan[nama] = harga is int
                            ? harga
                            : int.tryParse(harga.toString()) ?? 0;
                      }

                      return ListView.separated(
                        itemCount: 1 + kiloanJenis.length + filtered.length,
                        separatorBuilder: (_, __) => const Divider(
                          thickness: 1,
                          color: Color(0xFFE1E1E1),
                          height: 0,
                        ),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // Cuci Kiloan
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 18,
                                top: 8,
                                bottom: 4,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Cuci Kiloan",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Text(
                                        "Berat (kg): ",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 45,
                                        child: TextField(
                                          decoration: const InputDecoration(
                                            hintText: "0",
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 6,
                                                  horizontal: 6,
                                                ),
                                          ),
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                decimal: true,
                                              ),
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontSize: 14),
                                          controller: TextEditingController(
                                            text: kiloan > 0
                                                ? kiloan.toString()
                                                : '',
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              kiloan =
                                                  double.tryParse(
                                                    val.replaceAll(',', '.'),
                                                  ) ??
                                                  0.0;
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        "  x Rp. $hargaPerKg",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Rp. $totalKiloanHarga",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                          // Jenis kiloan: Atasan, Bawahan, Lain-lain
                          if (index <= kiloanJenis.length) {
                            String key = kiloanJenis.keys.elementAt(index - 1);
                            int jumlah = kiloanJenis[key] ?? 0;
                            return ListTile(
                              title: Text(
                                key,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                ),
                              ),
                              trailing: (jumlah == 0)
                                  ? InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        setState(() {
                                          kiloanJenis[key] = 1;
                                        });
                                      },
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFCDE7F2),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Color(0xFF2A5A6A),
                                          size: 24,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 110,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                kiloanJenis[key] = jumlah - 1;
                                              });
                                            },
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFCDE7F2),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Icon(
                                                Icons.remove,
                                                color: Color(0xFF2A5A6A),
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              '$jumlah',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                kiloanJenis[key] = jumlah + 1;
                                              });
                                            },
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFCDE7F2),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: Color(0xFF2A5A6A),
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            );
                          }
                          // Layanan satuan dari firestore
                          final doc = filtered[index - kiloanJenis.length - 1];
                          final nama = doc['nama'] ?? '';
                          final harga = doc['harga'] ?? 0;
                          int jumlah = jumlahDipilih[nama] ?? 0;
                          return LayananSatuanTile(
                            nama: nama,
                            harga: harga,
                            jumlah: jumlah,
                            onTambah: () {
                              setState(() {
                                jumlahDipilih[nama] = jumlah + 1;
                              });
                            },
                            onKurang: () {
                              setState(() {
                                jumlahDipilih[nama] = jumlah - 1;
                                if (jumlahDipilih[nama] == 0) {
                                  jumlahDipilih.remove(nama);
                                }
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Bottom Bar (tanpa foto profile)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x18000000),
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Foto profile dihilangkan
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.nama,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "+62${widget.whatsapp.replaceFirst('0', '')}",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Ringkasan pesanan (summary kiloan/satuan)
                      Row(
                        children: [
                          Text(
                            "${kiloan.toStringAsFixed(1)} ",
                            style: _summaryStyle,
                          ),
                          Text("Kg  ", style: _summaryHintStyle),
                          Text("$totalQty ", style: _summaryStyle),
                          Text("Sat  ", style: _summaryHintStyle),
                          Text("$totalJenisKiloan ", style: _summaryStyle),
                          Text("M", style: _summaryHintStyle),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rp. ${_money(totalHarga)}",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const Text(
                            "Total Pesanan",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Material(
                        color: const Color(0xFFFCF2E5),
                        borderRadius: BorderRadius.circular(16),
                        elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => BottomSheetDetailPesanan(
                                kodeLaundry: widget.kodeLaundry,
                                namaCustomer: widget.nama,
                                nomorCustomer: widget.whatsapp,
                                layanan: widget.layanan,
                                descLayanan: widget.desc,
                                kiloan: kiloan,
                                kiloanJenis: kiloanJenis,
                                satuanDipilih: Map.from(jumlahDipilih),
                                hargaSatuan: Map.from(_hargaLayanan),
                                hargaPerKg: hargaPerKg,
                                totalHarga: totalHarga,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 36,
                              vertical: 12,
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  "Next",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Color(0xFF147C8A),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFF147C8A),
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _money(num value) {
  return value.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => "${m[1]}.",
  );
}

const TextStyle _summaryStyle = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

const TextStyle _summaryHintStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 13,
  color: Colors.black54,
);
