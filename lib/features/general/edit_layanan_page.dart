import 'package:flutter/material.dart';
// import DurasiLayananPage sesuai path kamu!
import 'package:laundryin/features/layanan/durasi_layanan_page.dart';

class EditLayananPage extends StatelessWidget {
  const EditLayananPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layananList = [
      {
        "icon": Icons.access_time_outlined,
        "label": "Durasi layanan",
        "desc": "Tambah, ubah, hapus durasi layanan",
        "color": Color(0xFFBBE2EC),
      },
      {
        "icon": Icons.layers_outlined,
        "label": "Jenis layanan",
        "desc": "Tambah, ubah, hapus jenis layanan",
        "color": Color(0xFFBBE2EC),
      },
      {
        "icon": Icons.local_offer_outlined,
        "label": "Diskon",
        "desc": "Tambah, ubah, hapus diskon",
        "color": Color(0xFFBBE2EC),
      },
      {
        "icon": Icons.motorcycle_outlined,
        "label": "Layanan antar jemput",
        "desc": "Tambah, ubah, hapus layanan",
        "color": Color(0xFFBBE2EC),
      },
      {
        "icon": Icons.science_outlined,
        "label": "Parfum",
        "desc": "Tambah, ubah, hapus parfum",
        "color": Color(0xFFBBE2EC),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // AppBar custom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, left: 0, right: 0, bottom: 22),
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
                      "Edit Layanan",
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
          const SizedBox(height: 19),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
              itemCount: layananList.length,
              itemBuilder: (context, idx) {
                final item = layananList[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      // Jika durasi layanan (idx == 0), navigasi ke DurasiLayananPage
                      if (idx == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DurasiLayananPage()),
                        );
                      }
                      // Untuk menu lain bisa tambahkan navigasi lainnya
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: item["color"] as Color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item["icon"] as IconData,
                            size: 30,
                            color: Color(0xFF2B303A),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["label"] as String,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                item["desc"] as String,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13.5,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
