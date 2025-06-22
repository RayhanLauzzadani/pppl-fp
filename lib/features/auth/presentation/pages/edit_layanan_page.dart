import 'package:flutter/material.dart';
import 'update_jenis_layanan_parfum_page.dart';

class EditLayananPage extends StatelessWidget {
  final String laundryId; // Tambah parameter laundryId

  const EditLayananPage({super.key, required this.laundryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF147C8A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Layanan",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 21,
            color: Color(0xFF147C8A),
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFBBE2EC), Color(0xFF40A2E3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
        children: [
          _LayananTile(
            icon: 'assets/icons/clock.png',
            title: 'Durasi layanan',
            subtitle: 'Tambah, ubah, hapus durasi layanan',
            onTap: () {}, // TODO
          ),
          const SizedBox(height: 18),
          _LayananTile(
            icon: 'assets/icons/layer.png',
            title: 'Jenis layanan',
            subtitle: 'Tambah, ubah, hapus jenis layanan',
            onTap: () {},
          ),
          const SizedBox(height: 18),
          _LayananTile(
            icon: 'assets/icons/discount.png',
            title: 'Diskon',
            subtitle: 'Tambah, ubah, hapus diskon',
            onTap: () {},
          ),
          const SizedBox(height: 18),
          _LayananTile(
            icon: 'assets/icons/delivery.png',
            title: 'Layanan antar jemput',
            subtitle: 'Tambah, ubah, hapus layanan',
            onTap: () {},
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
