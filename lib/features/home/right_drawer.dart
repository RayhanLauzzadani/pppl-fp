import 'package:flutter/material.dart';
import '../general/edit_layanan_page.dart'; // Tambahkan import ini

class RightDrawerWidget extends StatelessWidget {
  final VoidCallback onLogout;
  const RightDrawerWidget({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          bottomLeft: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x29000000),
            blurRadius: 30,
            offset: Offset(-5, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... PROFILE (biarkan saja)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/31.jpg",
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Jamal Sentosa",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: Color(0xFF132931),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Outlet",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF69979F),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _drawerMenuButton(
              icon: Icons.person_outline,
              label: "Profil Akun",
              onTap: () {},
            ),
            _drawerMenuButton(
              icon: Icons.notifications_outlined,
              label: "Layanan",
              onTap: () {
                Navigator.pop(context); // tutup drawer dulu
                Future.delayed(const Duration(milliseconds: 210), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditLayananPage()),
                  );
                });
              },
            ),
            _drawerMenuButton(
              icon: Icons.history,
              label: "Riwayat",
              onTap: () {},
            ),
            _drawerMenuButton(
              icon: Icons.info_outline,
              label: "Tentang Kami",
              onTap: () {},
            ),
            const Spacer(),
            // ... LOGOUT BUTTON (biarkan saja)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ElevatedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.power_settings_new, color: Color(0xFF40A2E3)),
                label: const Text(
                  "Keluar Akun",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Color(0xFF40A2E3),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE7F4FD),
                  foregroundColor: const Color(0xFF40A2E3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  minimumSize: const Size(double.infinity, 46),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerMenuButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF212C2D), width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            backgroundColor: Colors.white,
            padding: EdgeInsets.zero,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(color: Color(0xFF186379), width: 1.4),
                ),
                child: Icon(icon, color: Color(0xFF186379), size: 20),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 15.7,
                    color: Color(0xFF186379),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
