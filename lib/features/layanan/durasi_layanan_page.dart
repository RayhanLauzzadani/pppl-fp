import 'package:flutter/material.dart';

class DurasiLayananPage extends StatelessWidget {
  const DurasiLayananPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> durasiList = [
      {"durasi": "3 Hari", "jenis": "Reguler"},
      {"durasi": "1 Hari", "jenis": "Ekspress"},
      {"durasi": "3 Jam", "jenis": "Kilat"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER DENGAN SHADOW
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 40, bottom: 22),
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
                  // No boxShadow in BoxDecoration, pakai positioned
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Durasi Layanan",
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
              // SHADOW BAWAH HEADER
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 17,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          // LIST DURASI
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: durasiList.length,
              itemBuilder: (context, idx) {
                final item = durasiList[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF6ED),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.14),
                        blurRadius: 14,
                        offset: const Offset(0, 7),
                        spreadRadius: 0.2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Durasi
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["durasi"]!,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item["jenis"]!,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.2,
                                  color: Color(0xFF565656),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tombol Edit
                        Container(
                          margin: const EdgeInsets.only(left: 8, right: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBBE2EC),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit, color: Color(0xFF2B303A)),
                            iconSize: 23,
                            tooltip: "Edit",
                          ),
                        ),
                        // Tombol Hapus
                        Container(
                          margin: const EdgeInsets.only(left: 0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBBE2EC),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.delete, color: Color(0xFF2B303A)),
                            iconSize: 23,
                            tooltip: "Hapus",
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Tombol Tambah Durasi
          Padding(
            padding: const EdgeInsets.only(bottom: 28, top: 3, left: 32, right: 32),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Aksi tambah durasi
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40A2E3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Tambah Durasi",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
