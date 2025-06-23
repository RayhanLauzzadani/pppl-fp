import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Import halaman-halaman lain sesuai path project kamu
import '../auth/presentation/pages/edit_layanan_page.dart';
import '../auth/presentation/pages/edit_profile_page.dart'; // Uncomment kalau sudah ada
import 'about_page.dart';
// import '../riwayat/riwayat_pesanan_page.dart'; // Tidak perlu, sudah di dalam sini

// ======================
// DRAWER WIDGET UTAMA
// ======================
class ModernDrawerWidget extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback? onClose;
  final String laundryId;

  const ModernDrawerWidget({
    Key? key,
    required this.onLogout,
    this.onClose,
    required this.laundryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.83,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          bottomLeft: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 30, 16, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Hello,",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "Adiwara Bestari",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Optional: Close button
                  // if (onClose != null)
                  //   IconButton(
                  //     icon: Icon(Icons.close_rounded, size: 32, color: Colors.black54),
                  //     onPressed: onClose,
                  //   ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              thickness: 1.2,
              color: Colors.black26,
              indent: 18,
              endIndent: 18,
            ),
            const SizedBox(height: 8),

            // MENU ITEM: Profil Akun
           _drawerMenuItem(
              Icons.person_outline,
              "Profil Akun",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(isOwner: true),
                  ),
                );
              },
            ),
            // MENU ITEM: Edit Layanan
            _drawerMenuItem(
              Icons.notifications_outlined,
              "Layanan",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => EditLayananPage(laundryId: laundryId),
                ));
              },
            ),
            // MENU ITEM: Riwayat Pesanan (langsung dalam file ini)
            _drawerMenuItem(
              Icons.history,
              "Riwayat Pesanan",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const RiwayatPesananPage(),
                ));
              },
            ),
            _drawerMenuItem(
              Icons.help_outline,
              "Tentang Kami",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutPage()),
                );
              },
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
              child: _drawerMenuItem(
                Icons.logout_rounded,
                "Logout",
                onTap: onLogout,
                color: const Color(0xFFE64848),
                isLogout: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Drawer menu item builder
  static Widget _drawerMenuItem(
    IconData icon,
    String label, {
    VoidCallback? onTap,
    Color color = Colors.black87,
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: ListTile(
        leading: Icon(icon, color: color, size: 26),
        title: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: isLogout ? FontWeight.bold : FontWeight.w600,
            color: color,
            fontSize: 16.2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 2),
        minLeadingWidth: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
        hoverColor: Colors.black12.withOpacity(0.06),
        tileColor: Colors.transparent,
      ),
    );
  }
}

// ======================
// PAGE RIWAYAT PESANAN
// ======================

class PesananRiwayat {
  final String nota;
  final String nama;
  final String tipe;
  final DateTime tanggalMasuk;
  final DateTime tanggalSelesai;
  final int total;
  final String pembayaran; // "Lunas - Tunai"
  final String status; // hanya "selesai" yg tampil

  PesananRiwayat({
    required this.nota,
    required this.nama,
    required this.tipe,
    required this.tanggalMasuk,
    required this.tanggalSelesai,
    required this.total,
    required this.pembayaran,
    required this.status,
  });
}

class RiwayatPesananPage extends StatefulWidget {
  const RiwayatPesananPage({super.key});

  @override
  State<RiwayatPesananPage> createState() => _RiwayatPesananPageState();
}

class _RiwayatPesananPageState extends State<RiwayatPesananPage> {
  final TextEditingController searchController = TextEditingController();

  // Contoh dummy data
  final List<PesananRiwayat> semuaPesanan = [
    PesananRiwayat(
      nota: "1157.1909.21",
      nama: "Budi",
      tipe: "Reguler",
      tanggalMasuk: DateTime(2024, 9, 3, 19, 37),
      tanggalSelesai: DateTime(2024, 9, 7, 9, 21),
      total: 50000,
      pembayaran: "Lunas - Tunai",
      status: "selesai",
    ),
    PesananRiwayat(
      nota: "1156.1909.23",
      nama: "Joko",
      tipe: "Ekspress",
      tanggalMasuk: DateTime(2024, 9, 3, 19, 37),
      tanggalSelesai: DateTime(2024, 9, 7, 9, 21),
      total: 50000,
      pembayaran: "Lunas - Tunai",
      status: "selesai",
    ),
    PesananRiwayat(
      nota: "1155.1809.21",
      nama: "Siti",
      tipe: "Reguler",
      tanggalMasuk: DateTime(2024, 9, 3, 19, 37),
      tanggalSelesai: DateTime(2024, 9, 7, 9, 21),
      total: 50000,
      pembayaran: "Lunas - Tunai",
      status: "selesai",
    ),
    // ...tambah data lain jika perlu
  ];

  @override
  Widget build(BuildContext context) {
    // Hanya pesanan selesai, urut terbaru
    List<PesananRiwayat> riwayatList = semuaPesanan
        .where((e) => e.status == 'selesai')
        .toList()
      ..sort((a, b) => b.tanggalSelesai.compareTo(a.tanggalSelesai));

    // Filter search
    String q = searchController.text.toLowerCase();
    if (q.isNotEmpty) {
      riwayatList = riwayatList.where((p) {
        return p.nama.toLowerCase().contains(q) ||
            p.nota.toLowerCase().contains(q) ||
            DateFormat('dd/MM/yyyy').format(p.tanggalMasuk).contains(q) ||
            DateFormat('dd/MM/yyyy').format(p.tanggalSelesai).contains(q);
      }).toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 42, left: 0, right: 0, bottom: 22),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF40A2E3),
                  Color(0xFFBBE2EC),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Riwayat Pesanan",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 7),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.13),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (v) => setState(() {}),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black54, size: 24),
                  hintText: "Cari nama / nota / tanggal",
                  hintStyle: TextStyle(fontFamily: "Poppins", color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                ),
              ),
            ),
          ),
          // List Riwayat
          Expanded(
            child: ListView.separated(
              itemCount: riwayatList.length,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              separatorBuilder: (_, __) => const SizedBox(height: 7),
              itemBuilder: (context, idx) {
                final p = riwayatList[idx];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFBBE2EC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.shopping_basket_outlined, color: Color(0xFF40A2E3), size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nota–${p.nota} ${p.tipe}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                            Text(
                              "Masuk: ${DateFormat('dd/MM/yyyy – HH:mm').format(p.tanggalMasuk)}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                fontSize: 12.2,
                              ),
                            ),
                            Text(
                              "Selesai: ${DateFormat('dd/MM/yyyy – HH:mm').format(p.tanggalSelesai)}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                fontSize: 12.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Rp ${p.total.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 14.2,
                            ),
                          ),
                          Text(
                            p.pembayaran,
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 12.1,
                              fontStyle: FontStyle.italic,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
