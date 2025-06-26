import 'package:flutter/material.dart';

// Import halaman-halaman lain sesuai path project kamu
import '../auth/presentation/pages/edit_layanan_page.dart';
import '../auth/presentation/pages/edit_profile_page.dart';
import '../auth/presentation/pages/sign_in_page.dart';
import 'package:laundryin/features/pesanan/riwayat_pesanan_page.dart'; 
import '../general/tentang_kami_page.dart';

// ======================
// DRAWER WIDGET UTAMA
// ======================
class ModernDrawerWidget extends StatelessWidget {
  final VoidCallback? onLogout;
  final String laundryId;
  final bool isOwner;
  final VoidCallback? onClose;

  const ModernDrawerWidget({
    super.key,
    this.onLogout,
    required this.laundryId,
    required this.isOwner,
    this.onClose,
  });

  // Fungsi logout sederhana
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Konfirmasi Logout',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari aplikasi?',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                
                // Panggil callback jika ada
                if (onLogout != null) {
                  onLogout!();
                }
                
                // Navigate ke SignInPage dan hapus semua route sebelumnya
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Keluar',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 30, 16, 4),
              child: Row(
                children: [
                  // Avatar/Logo
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFF40A2E3),
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: 45,
                      height: 45,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Info Laundry
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LaundryID: $laundryId",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isOwner ? "Owner" : "Karyawan",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            color: isOwner ? Colors.teal : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Optional: close button
                  if (onClose != null)
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 32, color: Colors.black54),
                      onPressed: onClose,
                    ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(isOwner: isOwner),
                  ),
                );
              },
            ),
            // MENU ITEM: Edit Layanan
            _drawerMenuItem(
              Icons.notifications_outlined,
              "Layanan",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditLayananPage(isOwner: isOwner, laundryId: laundryId,), 
                  ),
                );
              },
            ),
            // MENU ITEM: Riwayat Pesanan
            _drawerMenuItem(
              Icons.history,
              "Riwayat Pesanan",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RiwayatPesananPage(),
                  ),
                );
              },
            ),
            // MENU ITEM: Tentang Kami
            _drawerMenuItem(
              Icons.info_outline,
              "Tentang Kami",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutPage(),
                  ),
                );
              },
            ),
            const Spacer(),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text("Keluar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                    textStyle: const TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _handleLogout(context),
                ),
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
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF40A2E3)),
        title: Text(
          label,
          style: const TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 15.5),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        onTap: onTap,
        dense: true,
        tileColor: Colors.grey[100],
      ),
    );
  }
}