import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundryin/features/home/right_drawer.dart';
import '../../pesanan/selesai_pesanan/selesai_pesanan_page.dart';
import '../../pesanan/proses_pesanan_page.dart';
import '../../pesanan/buat_pesanan/buat_pesanan_page.dart';
import 'package:laundryin/features/profile/edit_profile_page.dart';
import 'package:flutter/services.dart'; // Untuk SystemNavigator.pop()

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
      setState(() {
        namaLaundry = doc.data()?['namaLaundry'] ?? "-";
        isLoadingNama = false;
      });
    } catch (e) {
      setState(() {
        namaLaundry = "-";
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
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
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
            // ===== Gradient AppBar =====
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 196,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
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
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x15000000),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 24,
                          child: Image.asset(
                            "assets/images/logo.png",
                            width: 38,
                            height: 38,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Title
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              "LondryIn",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // Hamburger menu
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              scaffoldKey.currentState?.openEndDrawer();
                            },
                            child: const Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Welcome text absolute
                Positioned(
                  left: 24,
                  top: 110,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Selamat datang Staff!",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        isLoadingNama
                            ? const SizedBox(
                                height: 24,
                                width: 90,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : GestureDetector(
                                onTap: _openEditProfilePage,
                                child: Text(
                                  namaLaundry,
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22,
                                    shadows: [
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
            // Spacer
            const SizedBox(height: 38),
            // ===== Info Card (Pesanan Hari Ini) =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: StreamBuilder<Map<String, dynamic>>(
                stream: getStatPesananHariIni(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      width: double.infinity,
                      height: 100,
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
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF6ED),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.13 * 255).round()),
                          blurRadius: 16,
                          spreadRadius: 1,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon box
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF6ED),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha((0.13 * 255).round()),
                                blurRadius: 16,
                                spreadRadius: 1,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/images/checklist.png",
                              width: 26,
                              height: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Info text & stats
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pesanan Hari Ini",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "$pesanan Pesanan ~ Rp. ${_formatRupiah(omzet)}",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 13),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _infoNumber(_formatKg(kg), "Kiloan"),
                                  const SizedBox(width: 24),
                                  _infoNumber("$pcs pcs", "Satuan"),
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
            // ===== Menu Grid =====
            const SizedBox(height: 38),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _menuItem(
                    asset: "assets/images/note.png",
                    label: "Buat Pesanan",
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
                  _menuItem(
                    asset: "assets/images/mesin_cuci.png",
                    label: "Proses",
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
                  _menuItem(
                    asset: "assets/images/icon_done.png",
                    label: "Selesaikan",
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
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _infoNumber(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 17.5,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 13,
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
    double iconWidth = 90,
    double iconHeight = 90,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFFBBE2EC),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.12 * 255).round()),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                asset,
                width: iconWidth,
                height: iconHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF136269),
            ),
          ),
        ],
      ),
    );
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
