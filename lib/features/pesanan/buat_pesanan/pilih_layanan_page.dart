import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String role;
  final String emailUser;
  final String passwordUser;
  final List<Map<String, dynamic>>? barangCustom;
  final Map<String, int>? barangQtyCustom;
  final double? beratKgSebelumnya;

  const PilihLayananPage({
    Key? key,
    required this.nama,
    required this.whatsapp,
    required this.layanan,
    required this.desc,
    required this.kodeLaundry,
    required this.role,
    required this.emailUser,
    required this.passwordUser,
    this.barangCustom,
    this.barangQtyCustom,
    this.beratKgSebelumnya,
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

  Map<String, int> jumlah = {};
  String search = '';

  @override
  void initState() {
    super.initState();
    if (widget.barangCustom != null) {
      barangList = List<Map<String, dynamic>>.from(widget.barangCustom!);
    }
    if (widget.barangQtyCustom != null) {
      barangQty = Map<String, int>.from(widget.barangQtyCustom!);
    }
    if (widget.beratKgSebelumnya != null) {
      beratKg = widget.beratKgSebelumnya!;
      beratController.text = beratKg != 0.0 ? beratKg.toString() : '';
    }
    beratController.addListener(() {
      try {
        beratKg = double.parse(beratController.text.replaceAll(',', '.'));
      } catch (_) {
        beratKg = 0.0;
      }
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context, {
      'barangCustom': barangList,
      'barangQty': barangQty,
      'beratKg': beratKg,
    });
    return false;
  }

  int _totalHarga(List<Map<String, dynamic>> layananList) {
    final num subtotal = beratKg * _hargaKiloan(layananList);
    int total = subtotal.round();
    for (var l in layananList) {
      final nama = l['nama'];
      final harga = l['harga'] ?? 0;
      int hargaInt;
      if (harga is int) {
        hargaInt = harga;
      } else if (harga is double) {
        hargaInt = harga.toInt();
      } else {
        hargaInt = int.tryParse('$harga') ?? 0;
      }
      total += ((jumlah[nama] ?? 0) * hargaInt);
    }
    return total;
  }

  int _totalKiloan(List<Map<String, dynamic>> layananList) {
    int total = 0;
    for (var l in layananList) {
      if ((l['tipe'] ?? '').toLowerCase() == 'kiloan') {
        total += jumlah[l['nama']] ?? 0;
      }
    }
    return total;
  }

  int _totalSatuan(List<Map<String, dynamic>> layananList) {
    int total = 0;
    for (var l in layananList) {
      if ((l['tipe'] ?? '').toLowerCase() == 'satuan') {
        total += jumlah[l['nama']] ?? 0;
      }
    }
    for (var v in barangQty.values) {
      total += v;
    }
    return total;
  }

  int _hargaKiloan(List<Map<String, dynamic>> layananList) {
    for (var l in layananList) {
      if ((l['tipe'] ?? '').toLowerCase() == 'kiloan') {
        final harga = l['harga'];
        if (harga is int) return harga;
        if (harga is double) return harga.toInt();
        return int.tryParse('$harga') ?? 10000;
      }
    }
    return 10000; // default jika tidak ada
  }

  List<Map<String, dynamic>> _filteredLayanan(
    List<Map<String, dynamic>> layananList,
  ) {
    final q = search.trim().toLowerCase();
    if (q.isEmpty) return layananList;
    return layananList
        .where((l) => (l['nama'] ?? '').toString().toLowerCase().contains(q))
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

  // Fungsi untuk ambil data diskon dari firestore berdasarkan label yang dipilih user
  Future<Map<String, dynamic>?> _getDiskonDariPilihan(
    String? diskonLabel,
  ) async {
    if (diskonLabel == null || diskonLabel.isEmpty) return null;
    final query = await FirebaseFirestore.instance
        .collection('laundries')
        .doc(widget.kodeLaundry)
        .collection('diskon')
        .get();
    for (final doc in query.docs) {
      final data = doc.data();
      final jenis = data['jenisDiskon']?.toString() ?? '';
      final jumlah = data['jumlahDiskon']?.toString() ?? '';
      final tipe = (data['tipeDiskon']?.toString() ?? 'Persen').toLowerCase();
      final label = tipe == "persen"
          ? "$jenis ($jumlah%)"
          : "$jenis (Rp. $jumlah)";
      if (diskonLabel == label) {
        return data;
      }
    }
    return null;
  }

  static String _currencyFormat(int price) {
    final s = price.toString();
    return s.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child: Column(
            children: [
              GradientAppBar(title: 'Buat Pesanan', onBack: () => _onWillPop()),
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
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('laundries')
                      .doc(widget.kodeLaundry)
                      .collection('jenis_layanan')
                      .where('jenis', isEqualTo: widget.desc)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return const Center(child: CircularProgressIndicator());
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(38.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/empty_box.png",
                                width: 120,
                                height: 120,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Belum ada jenis layanan.\nSilakan tambah dulu di menu layanan.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16.7,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    List<Map<String, dynamic>> layananList = snapshot.data!.docs
                        .map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return {
                            ...data,
                            'id': doc.id,
                            'nama': data['nama'] ?? '',
                            'harga': data['harga'] ?? 0,
                            'tipe': data['tipe'] ?? '',
                          };
                        })
                        .toList();

                    for (var l in layananList) {
                      jumlah.putIfAbsent(l['nama'], () => 0);
                    }

                    final List<Widget> barangCustomWidget = barangList.map((b) {
                      final title = b['title'];
                      final qty = barangQty[title] ?? 0;
                      return BarangCustomTile(
                        title: title,
                        qty: qty,
                        onTambah: () {
                          setState(() {
                            barangQty[title] = qty + 1;
                          });
                        },
                        onKurang: () {
                          setState(() {
                            if ((barangQty[title] ?? 0) > 0) {
                              barangQty[title] = (barangQty[title] ?? 0) - 1;
                            }
                          });
                        },
                      );
                    }).toList();

                    final List<Widget> layananUtamaWidget =
                        _filteredLayanan(layananList).map((item) {
                          return LayananSatuanTile(
                            nama: item['nama'],
                            harga: (item['harga'] is int)
                                ? item['harga']
                                : (item['harga'] is double)
                                ? (item['harga'] as double).toInt()
                                : int.tryParse('${item['harga']}') ?? 0,
                            jumlah: jumlah[item['nama']] ?? 0,
                            tipe: (item['tipe'] ?? '').toString(),
                            onTambah: () {
                              setState(() {
                                jumlah[item['nama']] =
                                    (jumlah[item['nama']] ?? 0) + 1;
                              });
                            },
                            onKurang: () {
                              setState(() {
                                if ((jumlah[item['nama']] ?? 0) > 0) {
                                  jumlah[item['nama']] =
                                      jumlah[item['nama']]! - 1;
                                }
                              });
                            },
                          );
                        }).toList();

                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [...barangCustomWidget, ...layananUtamaWidget],
                    );
                  },
                ),
              ),

              // === Summary Customer Info (MIRIP GAMBAR) ===
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('laundries')
                    .doc(widget.kodeLaundry)
                    .collection('jenis_layanan')
                    .where('jenis', isEqualTo: widget.desc)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> layananList = [];
                  if (snapshot.hasData) {
                    layananList = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return {
                        ...data,
                        'id': doc.id,
                        'nama': data['nama'] ?? '',
                        'harga': data['harga'] ?? 0,
                        'tipe': data['tipe'] ?? '',
                      };
                    }).toList();
                  }
                  // Hitung total Kg dan Sat
                  int kg = beratKg > 0 ? beratKg.round() : 0;
                  int sat = 0;
                  for (var l in layananList) {
                    if ((l['tipe'] ?? '').toLowerCase() == 'satuan') {
                      sat += jumlah[l['nama']] ?? 0;
                    }
                  }
                  for (var v in barangQty.values) {
                    sat += v;
                  }

                  return Container(
                    margin: const EdgeInsets.fromLTRB(14, 0, 14, 4),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 7,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Nama & WA
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.nama,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.8,
                                  color: Color(0xFF232323),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.whatsapp,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.7,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            InfoBadge('$kg', 'Kg'),
                            const SizedBox(width: 7),
                            InfoBadge('$sat', 'Sat'),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              // === Total Harga & Next Button ===
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('laundries')
                    .doc(widget.kodeLaundry)
                    .collection('jenis_layanan')
                    .where('jenis', isEqualTo: widget.desc)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> layananList = [];
                  if (snapshot.hasData) {
                    layananList = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return {
                        ...data,
                        'id': doc.id,
                        'nama': data['nama'] ?? '',
                        'harga': data['harga'] ?? 0,
                        'tipe': data['tipe'] ?? '',
                      };
                    }).toList();
                  }
                  final totalHarga = _totalHarga(layananList);

                  final Map<String, int> hargaLayanan = {};
                  final Map<String, String> tipeLayanan = {};
                  int hargaKiloan = 10000;

                  for (final l in layananList) {
                    final nama = l['nama'] ?? '';
                    hargaLayanan[nama] = (l['harga'] is int)
                        ? l['harga']
                        : (l['harga'] is double)
                            ? (l['harga'] as double).toInt()
                            : int.tryParse('${l['harga']}') ?? 0;
                    tipeLayanan[nama] = (l['tipe'] ?? '').toString();
                    if ((l['tipe'] ?? '').toString().toLowerCase() == 'kiloan') {
                      hargaKiloan = hargaLayanan[nama]!;
                    }
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCF7F2),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
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
                          onTap: () async {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => BottomSheetKonfirmasi(
                                kodeLaundry: widget.kodeLaundry,
                                onSubmit: (konfirmasiData) async {
                                  // Ambil data diskon dari pilihan user
                                  final diskonData =
                                      await _getDiskonDariPilihan(
                                    konfirmasiData['diskon'] as String?,
                                  );
                                  int hargaSebelumDiskon = _totalHarga(
                                    layananList,
                                  );
                                  int hargaSetelahDiskon = hargaSebelumDiskon;
                                  String? labelDiskon;
                                  if (diskonData != null) {
                                    labelDiskon = diskonData['jenisDiskon'];
                                    final tipe = diskonData['tipeDiskon'];
                                    final jumlahDiskon =
                                        int.tryParse(
                                              diskonData['jumlahDiskon']
                                                  .toString(),
                                            ) ??
                                            0;
                                    if (jumlahDiskon > 0) {
                                      if (tipe == 'Persen') {
                                        hargaSetelahDiskon =
                                            hargaSebelumDiskon -
                                                ((hargaSebelumDiskon *
                                                        jumlahDiskon) ~/
                                                    100);
                                      } else {
                                        hargaSetelahDiskon =
                                            hargaSebelumDiskon - jumlahDiskon;
                                      }
                                      if (hargaSetelahDiskon < 0)
                                        hargaSetelahDiskon = 0;
                                    }
                                  }

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
                                    'totalHarga': hargaSetelahDiskon,
                                    'hargaSebelumDiskon': hargaSebelumDiskon,
                                    'labelDiskon': labelDiskon,
                                    'hargaLayanan': hargaLayanan,
                                    'layananTipe': tipeLayanan,
                                    'hargaKiloan': hargaKiloan,
                                    'jenisParfum': konfirmasiData['jenisParfum'],
                                    'antarJemput': konfirmasiData['antarJemput'],
                                    'diskon': konfirmasiData['diskon'],
                                    'catatan': konfirmasiData['catatan'],
                                    // Tambahkan 2 status berikut:
                                    'statusProses': 'belum_mulai',
                                    'statusTransaksi': 'belum_bayar',
                                  };
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('laundries')
                                        .doc(widget.kodeLaundry)
                                        .collection('pesanan')
                                        .add({
                                      ...pesananData,
                                      'createdAt':
                                          FieldValue.serverTimestamp(),
                                      'statusProses': 'belum_mulai',
                                      'statusTransaksi': 'belum_bayar',
                                    });
                                    if (mounted) Navigator.pop(context);
                                    if (mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DetailBuatPesananPage(
                                            data: pesananData,
                                            role: widget.role,
                                            laundryId: widget.kodeLaundry,
                                            emailUser: widget.emailUser,
                                            passwordUser: widget.passwordUser,
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Gagal menyimpan pesanan: $e',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
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
                  );
                },
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
