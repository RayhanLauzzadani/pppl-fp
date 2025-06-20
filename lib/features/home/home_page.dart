import 'package:flutter/material.dart';
import 'right_drawer.dart';
import '../pesanan/selesai_pesanan_page.dart';
import '../pesanan/proses_pesanan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: RightDrawerWidget(
        onLogout: () {
          // Atur logika logout kamu di sini.
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ===== Custom Gradient AppBar =====
          Stack(
            children: [
              // Gradient BG
              Container(
                width: double.infinity,
                height: 196,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: [0.01, 0.12, 0.83],
                    colors: [
                      Color(0xFFFFF6E9), // krem putih
                      Color(0xFFBBE2EC), // biru muda
                      Color(0xFF40A2E3), // biru terang
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hai, Selamat datang",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white.withOpacity(0.93),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      "Jamal Sentosa Loundry",
                      style: TextStyle(
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
            ],
          ),
          // Spacer
          const SizedBox(height: 38),
          // ===== Info Card (Pesanan Hari Ini) =====
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
                    color: Colors.black.withOpacity(0.13),
                    blurRadius: 16,
                    spreadRadius: 1,
                    offset: Offset(0, 8),
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
                          color: Colors.black.withOpacity(0.13),
                          blurRadius: 16,
                          spreadRadius: 1,
                          offset: Offset(0, 8),
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
                    // TODO: Navigasi ke Buat Pesanan kalau ada
                  },
                ),
                _menuItem(
                  asset: "assets/images/mesin_cuci.png",
                  label: "Proses",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProsesPesananPage(),
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
                        builder: (_) => const SelesaiPesananPage(),
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

  // ===== Info Number Widget =====
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

  // ===== Menu Item Widget =====
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
                  color: Colors.black.withOpacity(0.12),
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
}
