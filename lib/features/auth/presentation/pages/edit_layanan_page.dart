import 'package:flutter/material.dart';
import 'update_jenis_layanan_parfum_page.dart';
import 'package:laundryin/features/layanan/durasi_layanan_page.dart';
import 'package:laundryin/features/layanan/jenis_layanan_page.dart';
import 'package:laundryin/features/layanan/diskon_page.dart';
import 'package:laundryin/features/layanan/antarjemput_page.dart'; // Pastikan path sudah benar!

class EditLayananPage extends StatelessWidget {
  final String laundryId;

  const EditLayananPage({super.key, required this.laundryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF6),
      body: Column(
        children: [
          // HEADER GRADIENT CUSTOM (seperti Edit Profil)
          Container(
            width: double.infinity,
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
            padding: const EdgeInsets.only(top: 42, left: 0, right: 0, bottom: 22),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Edit Layanan",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 44),
              ],
            ),
          ),
          // Body
          const SizedBox(height: 19),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 0, left: 16, right: 16),
              children: [
                // Navigasi ke DurasiLayananPage
                _LayananTile(
                  icon: 'assets/icons/clock.png',
                  title: 'Durasi layanan',
                  subtitle: 'Tambah, ubah, hapus durasi layanan',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DurasiLayananPage()),
                    );
                  },
                ),
                const SizedBox(height: 18),
                // Navigasi ke JenisLayananPage
                _LayananTile(
                  icon: 'assets/icons/layer.png',
                  title: 'Jenis layanan',
                  subtitle: 'Tambah, ubah, hapus jenis layanan',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const JenisLayananPage()),
                    );
                  },
                ),
                const SizedBox(height: 18),
                _LayananTile(
                  icon: 'assets/icons/discount.png',
                  title: 'Diskon',
                  subtitle: 'Tambah, ubah, hapus diskon',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DiskonPage()));
                  },
                ),
                const SizedBox(height: 18),
                _LayananTile(
                  icon: 'assets/icons/delivery.png',
                  title: 'Layanan antar jemput',
                  subtitle: 'Tambah, ubah, hapus layanan',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AntarJemputPage()));
                  },
                ),
                const SizedBox(height: 18),
                _LayananTile(
                  icon: 'assets/icons/perfume.png',
                  title: 'Parfum',
                  subtitle: 'Tambah, ubah, hapus parfum',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UpdateJenisLayananParfumPage(laundryId: laundryId),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LayananTile extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LayananTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFBBE2EC),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Image.asset(
                  icon,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 16.7,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.5,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
