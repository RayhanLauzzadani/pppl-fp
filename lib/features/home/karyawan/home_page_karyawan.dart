import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundryin/features/home/right_drawer.dart';
import '../../pesanan/selesai_pesanan/selesai_pesanan_page.dart';
import '../../pesanan/proses_pesanan_page.dart';
import '../../pesanan/buat_pesanan/buat_pesanan_page.dart';
import 'package:laundryin/features/profile/edit_profile_page.dart'; // pastikan path ini benar

class HomePageKaryawan extends StatefulWidget {
  final String laundryId;
  final String role;
  final String emailUser;
  final String passwordUser;

  const HomePageKaryawan({
    super.key,
    required this.laundryId,
    required this.role,
    required this.emailUser,
    required this.passwordUser,
  });

  @override
  State<HomePageKaryawan> createState() => _HomePageKaryawanState();
}

class _HomePageKaryawanState extends State<HomePageKaryawan> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String namaLaundry = "-";
  String statusAkun = "Staff"; // default Staff
  bool isLoadingNama = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => isLoadingNama = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('laundries')
          .doc(widget.laundryId)
          .get();
      final data = doc.data();
      setState(() {
        namaLaundry = data?['namaLaundry'] ?? "-";
        statusAkun = _getRoleDisplay(widget.role);
        isLoadingNama = false;
      });
    } catch (e) {
      setState(() {
        namaLaundry = "-";
        statusAkun = _getRoleDisplay(widget.role);
        isLoadingNama = false;
      });
    }
  }

  Future<void> _openEditProfilePage() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          isOwner: false,
          kodeLaundry: widget.laundryId,
          email: widget.emailUser,
          password: widget.passwordUser,
          role: widget.role,
        ),
      ),
    );
    if (updated == true) {
      await _loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- Kunci adaptasi, gunakan lebar layar sebagai basis proporsional ---
    final double sw = MediaQuery.of(context).size.width;
    // --- Menu & Card Adaptive size
    final double menuIconSize = sw * 0.21;
    final double menuImageSize = sw * 0.13;
    final double menuFont = sw * 0.043;
    final double cardPadding = sw * 0.045;
    final double cardRadius = sw * 0.045;
    final double cardIconBox = sw * 0.12;
    final double cardTitleFont = sw * 0.05;
    final double cardSubFont = sw * 0.036;
    final double cardStatNumFont = sw * 0.06;
    final double cardStatLabelFont = sw * 0.038;

    return Scaffold(
      key: scaffoldKey,
      endDrawer: ModernDrawerWidget(
        onLogout: () => Navigator.pop(context),
        laundryId: widget.laundryId,
        isOwner: false,
        emailUser: widget.emailUser,
        passwordUser: widget.passwordUser,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: sw * 0.45,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: [0.01, 0.12, 0.83],
                    colors: [
                      Color(0xFFFFF6E9),
                      Color(0xFFBBE2EC),
                      Color(0xFF40A2E3),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(sw * 0.08),
                    bottomRight: Radius.circular(sw * 0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x15000000),
                      blurRadius: sw * 0.032,
                      offset: Offset(0, sw * 0.015),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(sw * 0.05, sw * 0.07, sw * 0.05, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: sw * 0.065,
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: sw * 0.093,
                          height: sw * 0.093,
                        ),
                      ),
                      SizedBox(width: sw * 0.027),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: sw * 0.015),
                          child: Text(
                            "LondryIn",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: sw * 0.063,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: sw * 0.006),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            scaffoldKey.currentState?.openEndDrawer();
                          },
                          child: Icon(
                            Icons.menu_rounded,
                            color: Colors.white,
                            size: sw * 0.084,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: sw * 0.062,
                top: sw * 0.27,
                child: SizedBox(
                  width: sw - (sw * 0.124),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat datang $statusAkun!",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: sw * 0.039,
                        ),
                      ),
                      SizedBox(height: sw * 0.015),
                      isLoadingNama
                          ? SizedBox(
                              height: sw * 0.06,
                              width: sw * 0.22,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : GestureDetector(
                              onTap: _openEditProfilePage,
                              child: Text(
                                namaLaundry,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: sw * 0.054,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black12,
                                      offset: Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: sw * 0.095),
          // Info Card: Pesanan Hari Ini (statistik live)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.045),
            child: StreamBuilder<Map<String, dynamic>>(
              stream: getStatPesananHariIni(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    width: double.infinity,
                    height: sw * 0.25,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                }
                final data = snapshot.data!;
                final pesanan = data['totalPesanan'] ?? 0;
                final omzet = data['totalOmzet'] ?? 0;
                final kg = data['totalKg'] ?? 0.0;
                final pcs = data['totalPcs'] ?? 0;

                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: cardPadding, vertical: cardPadding),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF6ED),
                    borderRadius: BorderRadius.circular(cardRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.13 * 255).round()),
                        blurRadius: cardRadius * 0.9,
                        spreadRadius: cardRadius * 0.18,
                        offset: Offset(0, cardRadius),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: cardIconBox,
                        height: cardIconBox,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF6ED),
                          borderRadius: BorderRadius.circular(cardIconBox * 0.42),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha((0.13 * 255).round()),
                              blurRadius: cardIconBox * 0.65,
                              spreadRadius: cardIconBox * 0.13,
                              offset: Offset(0, cardIconBox * 0.3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/checklist.png",
                            width: cardIconBox * 0.65,
                            height: cardIconBox * 0.65,
                          ),
                        ),
                      ),
                      SizedBox(width: cardPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pesanan Hari Ini",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: cardTitleFont,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: cardPadding * 0.23),
                            Text(
                              "$pesanan Pesanan ~ Rp. ${_formatRupiah(omzet)}",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: cardSubFont,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: cardPadding * 0.68),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _infoNumber(_formatKg(kg), "Kiloan", numFont: cardStatNumFont, labelFont: cardStatLabelFont),
                                SizedBox(width: cardPadding * 1.25),
                                _infoNumber("$pcs pcs", "Satuan", numFont: cardStatNumFont, labelFont: cardStatLabelFont),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: sw * 0.095),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.02),
            child: Row(
              children: [
                Expanded(
                  child: _menuItem(
                    asset: "assets/images/note.png",
                    label: "Buat Pesanan",
                    iconSize: menuIconSize,
                    imageSize: menuImageSize,
                    fontSize: menuFont,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BuatPesananPage(
                            role: widget.role,
                            laundryId: widget.laundryId,
                            emailUser: widget.emailUser,
                            passwordUser: widget.passwordUser,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: sw * 0.04),
                Expanded(
                  child: _menuItem(
                    asset: "assets/images/mesin_cuci.png",
                    label: "Proses",
                    iconSize: menuIconSize,
                    imageSize: menuImageSize,
                    fontSize: menuFont,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProsesPesananPage(
                            kodeLaundry: widget.laundryId,
                            role: widget.role,
                            emailUser: widget.emailUser,
                            passwordUser: widget.passwordUser,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: sw * 0.04),
                Expanded(
                  child: _menuItem(
                    asset: "assets/images/icon_done.png",
                    label: "Selesaikan",
                    iconSize: menuIconSize,
                    imageSize: menuImageSize,
                    fontSize: menuFont,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SelesaiPesananPage(
                            kodeLaundry: widget.laundryId,
                            role: widget.role,
                            emailUser: widget.emailUser,
                            passwordUser: widget.passwordUser,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _infoNumber(String value, String label, {required double numFont, required double labelFont}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: numFont,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: labelFont,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _menuItem({
    required String asset,
    required String label,
    required double iconSize,
    required double imageSize,
    required double fontSize,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: const Color(0xFFBBE2EC),
              borderRadius: BorderRadius.circular(iconSize * 0.18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.12 * 255).round()),
                  blurRadius: iconSize * 0.13,
                  spreadRadius: iconSize * 0.03,
                  offset: Offset(0, iconSize * 0.1),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                asset,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: iconSize * 0.15),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: const Color(0xFF136269),
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleDisplay(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return 'Owner';
      case 'karyawan':
        return 'Staff';
      default:
        return "Staff";
    }
  }

  /// Fungsi utility format Rupiah
  static String _formatRupiah(int? number) {
    if (number == null) return "0";
    return number.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.");
  }

  /// Format KG: tidak pakai koma kalau bulat, 1 digit desimal kalau tidak
  static String _formatKg(dynamic kg) {
    if (kg == null) return "0 Kg";
    if (kg is int || (kg is double && kg % 1 == 0)) {
      return "${kg.toInt()} Kg";
    }
    return "${kg.toStringAsFixed(1)} Kg";
  }

  /// Stream statistik pesanan hari ini (live)
  Stream<Map<String, dynamic>> getStatPesananHariIni() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return FirebaseFirestore.instance
        .collection('laundries')
        .doc(widget.laundryId)
        .collection('pesanan')
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .snapshots()
        .map((snap) {
      int totalPesanan = snap.docs.length;
      int totalOmzet = 0;
      double totalKg = 0.0;
      int totalPcs = 0;

      for (final doc in snap.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalOmzet += (data['totalBayar'] ?? data['totalHarga'] ?? 0) is int
            ? (data['totalBayar'] ?? data['totalHarga'] ?? 0) as int
            : int.tryParse((data['totalBayar'] ?? data['totalHarga'] ?? '0').toString()) ?? 0;

        // KG (dari beratKg atau kg)
        final dynamic kg = data['beratKg'] ?? data['kg'] ?? 0.0;
        totalKg += (kg is int)
            ? kg.toDouble()
            : (kg is double)
                ? kg
                : double.tryParse(kg.toString()) ?? 0.0;

        // PCS dari barangQty
        if (data['barangQty'] is Map) {
          totalPcs += (data['barangQty'] as Map).values
              .fold<int>(0, (a, b) => a + ((b is num) ? b.toInt() : int.tryParse(b.toString()) ?? 0));
        }
        // PCS dari field jumlah tipe 'Satuan'
        if (data['jumlah'] is Map && data['layananTipe'] is Map) {
          final jumlahMap = Map<String, dynamic>.from(data['jumlah']);
          final tipeMap = Map<String, dynamic>.from(data['layananTipe']);
          jumlahMap.forEach((nama, qty) {
            final tipe = tipeMap[nama]?.toString().toLowerCase() ?? '';
            if (tipe == 'satuan' && qty is num && qty > 0) {
              totalPcs += qty.toInt();
            }
          });
        }
      }

      return {
        'totalPesanan': totalPesanan,
        'totalOmzet': totalOmzet,
        'totalKg': totalKg,
        'totalPcs': totalPcs,
      };
    });
  }
}
