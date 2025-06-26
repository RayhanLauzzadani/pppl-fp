import 'package:flutter/material.dart';
import 'update_jenis_layanan_parfum_page.dart';
import 'package:laundryin/features/layanan/durasi_layanan_page.dart';
import 'package:laundryin/features/layanan/jenis_layanan_page.dart';
import 'package:laundryin/features/layanan/diskon_page.dart';
import 'package:laundryin/features/layanan/antarjemput_page.dart';

class EditLayananPage extends StatelessWidget {
  final String laundryId;
  final bool isOwner;

  const EditLayananPage({
    super.key,
    required this.laundryId,
    required this.isOwner,
  });

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
                  enabled: isOwner,
                  onTap: () {
                    if (isOwner) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DurasiLayananPage()),
                      );
                    } else {
                      _showNoEditDialog(context);
                    }
                  },
                ),
                const SizedBox(height: 18),
                // Navigasi ke JenisLayananPage
                _LayananTile(
                  icon: 'assets/icons/layer.png',
                  title: 'Jenis layanan',
                  subtitle: 'Tambah, ubah, hapus jenis layanan',
                  enabled: isOwner,
                  onTap: () {
                    if (isOwner) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const JenisLayananPage()),
                      );
                    } else {
                      _showNoEditDialog(context);
                    }
                  },
                ),
                const SizedBox(height: 18),
                _LayananTile(
                  icon: 'assets/icons/discount.png',
                  title: 'Diskon',
                  subtitle: 'Tambah, ubah, hapus diskon',
                  enabled: isOwner,
                  onTap: () {
                    if (isOwner) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const DiskonPage()));
                    } else {
                      _showNoEditDialog(context);
                    }
                  },
                ),
                const SizedBox(height: 18),
                _LayananTile(
                  icon: 'assets/icons/delivery.png',
                  title: 'Layanan antar jemput',
                  subtitle: 'Tambah, ubah, hapus layanan',
                  enabled: isOwner,
                  onTap: () {
                    if (isOwner) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AntarJemputPage()));
                    } else {
                      _showNoEditDialog(context);
                    }
                  },
                ),
                const SizedBox(height: 18),
                _LayananTile(
                  icon: 'assets/icons/perfume.png',
                  title: 'Parfum',
                  subtitle: 'Tambah, ubah, hapus parfum',
                  enabled: isOwner,
                  onTap: () {
                    if (isOwner) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateJenisLayananParfumPage(laundryId: laundryId),
                        ),
                      );
                    } else {
                      _showNoEditDialog(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNoEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hanya dapat melihat"),
        content: const Text("Hanya owner yang bisa mengedit layanan. Hubungi owner jika ingin menambah/mengubah."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
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
  final bool enabled;

  const _LayananTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.60,
      child: Material(
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
      ),
    );
  }
}
