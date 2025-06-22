import 'package:flutter/material.dart';
import '../auth/presentation/pages/edit_layanan_page.dart';

class ModernDrawerWidget extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback? onClose;
  final String laundryId; // <--- Tambahkan ini

  const ModernDrawerWidget({
    Key? key,
    required this.onLogout,
    this.onClose,
    required this.laundryId, // <--- Tambahkan ini
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
            // Header with Avatar, Name, Close Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 30, 16, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
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
                  // Tambah tombol close jika perlu
                  // if (onClose != null)
                  //   IconButton(
                  //     icon: Icon(Icons.close_rounded, size: 32, color: Colors.black54),
                  //     onPressed: onClose,
                  //   ),
                ],
              ),
            ),
            // Garis pembatas antara profil dan menu
            const SizedBox(height: 10),
            const Divider(
              thickness: 1.2,
              color: Colors.black26,
              indent: 18,
              endIndent: 18,
            ),
            const SizedBox(height: 8),

            // Menu list (hanya 4 icon sesuai permintaan)
            _drawerMenuItem(Icons.person_outline, "Profil Akun", onTap: () {}),
            _drawerMenuItem(
              Icons.notifications_outlined,
              "Layanan",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditLayananPage(laundryId: laundryId),
                  ),
                );
              },
            ),
            _drawerMenuItem(Icons.history, "Riwayat", onTap: () {}),
            _drawerMenuItem(Icons.help_outline, "Tentang Kami", onTap: () {}),

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

  // Helper untuk menu item drawer
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
