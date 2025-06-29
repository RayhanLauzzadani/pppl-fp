import 'package:flutter/material.dart';
import 'package:laundryin/features/home/right_drawer.dart';
import '../../pesanan/selesai pesanan/selesai_pesanan_page.dart';
import '../../pesanan/proses_pesanan_page.dart';
import '../../pesanan/buat_pesanan/buat_pesanan_page.dart';

class HomePageKaryawan extends StatefulWidget {
  final String laundryId;
  final String role;

  const HomePageKaryawan({
    super.key,
    required this.laundryId,
    required this.role,
  });

  @override
  State<HomePageKaryawan> createState() => _HomePageKaryawanState();
}

class _HomePageKaryawanState extends State<HomePageKaryawan> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final String namaLaundry = "Laundry Lakso";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: ModernDrawerWidget(
        onLogout: () => Navigator.pop(context),
        laundryId: widget.laundryId,
        isOwner: widget.role.toLowerCase() == 'owner', // Selalu lowerCase
        // Jika ModernDrawerWidget perlu param role, tambahkan param role: widget.role,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
              Positioned(
                left: 24,
                top: 110,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat datang ${_getRoleDisplay(widget.role)}!",
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
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
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 38),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Container(
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
                          "7 Pesanan ~ Rp. 567.890",
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
                            _infoNumber("37 Kg", "Kiloan"),
                            const SizedBox(width: 24),
                            _infoNumber("50 pcs", "Satuan"),
                            const SizedBox(width: 24),
                            _infoNumber("10 m", "Meteran"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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

  String _getRoleDisplay(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return 'Owner';
      case 'karyawan':
        return 'Karyawan';
      default:
        return role;
    }
  }
}
