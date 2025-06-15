import 'package:flutter/material.dart';

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
            // PROFILE
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
            const SizedBox(height: 16),
            // MENU
            _drawerMenuTile(
              icon: Icons.person_outline,
              label: "Profil Akun",
              onTap: () {},
            ),
            _drawerMenuTile(
              icon: Icons.notifications_outlined,
              label: "Layanan",
              onTap: () {},
            ),
            _drawerMenuTile(
              icon: Icons.history,
              label: "Riwayat",
              onTap: () {},
            ),
            _drawerMenuTile(
              icon: Icons.info_outline,
              label: "Tentang Kami",
              onTap: () {},
            ),
            const Spacer(),
            // LOGOUT BUTTON
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

  Widget _drawerMenuTile({required IconData icon, required String label, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
          side: const BorderSide(color: Color(0xFF212C2D), width: 1.0),
        ),
        leading: Icon(icon, color: Color(0xFF186379)),
        title: Text(
          label,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF186379),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
