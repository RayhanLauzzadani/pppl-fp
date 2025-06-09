import 'package:flutter/material.dart';

class SelesaiPesananPage extends StatelessWidget {
  const SelesaiPesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pesananList = [
      {
        'nama': 'Farhan Laksono',
        'tipe': 'Reguler',
        'kg': 7,
        'pcs': 8,
        'status': '?',
        'ekspres': false,
      },
      {
        'nama': 'Habibullah Adilah P',
        'tipe': 'Reguler',
        'kg': 6,
        'pcs': 9,
        'status': '?',
        'ekspres': false,
      },
      {
        'nama': 'Pak Fazzle Ariwica',
        'tipe': 'Ekspress',
        'kg': 2,
        'pcs': 3,
        'status': '?',
        'ekspres': true,
      },
      {
        'nama': 'Pak Kresnadana Liu',
        'tipe': 'Reguler',
        'kg': 10,
        'pcs': 11,
        'status': '?',
        'ekspres': false,
      },
      {
        'nama': 'Bu Kim Suili Cak Lo',
        'tipe': 'Reguler',
        'kg': 9,
        'pcs': 8,
        'status': '?',
        'ekspres': false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ===== HEADER (gradient & judul) =====
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.01, 0.38, 0.83],
                colors: [
                  Color(0xFFFFF6E9),
                  Color(0xFFBBE2EC),
                  Color(0xFF40A2E3),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 42,
              left: 0,
              right: 0,
              bottom: 12,
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black87,
                          size: 22,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Pesanan Selesai",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 44),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // ===== STATUS CARD =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        _statusCard(
                          icon: Icons.help_outline_rounded,
                          iconColor: Color(0xFF52E18C),
                          count: 5,
                          label: "Belum Diambil",
                        ),
                        const SizedBox(width: 12),
                        _statusCard(
                          icon: Icons.close_rounded,
                          iconColor: Color(0xFFFF6A6A),
                          count: 2,
                          label: "Belum Bayar",
                        ),
                        const SizedBox(width: 12),
                        _statusCard(
                          icon: Icons.check_circle_outline,
                          iconColor: Color(0xFF52E18C),
                          count: 3,
                          label: "Sudah Diambil",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  // ===== SEARCH BAR =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFDF6ED),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        style: TextStyle(fontFamily: "Poppins", fontSize: 15),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.black54,
                            size: 24,
                          ),
                          hintText: "Cari nama pelanggan",
                          hintStyle: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          // ===== LIST PESANAN =====
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 14,
                bottom: 14,
              ),
              itemCount: pesananList.length,
              itemBuilder: (context, index) {
                final p = pesananList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 11,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p['nama'],
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              p['tipe'],
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.66),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "${p['kg']} kgs • ${p['pcs']} pcs",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: Colors.black.withOpacity(0.50),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            p['status'],
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF52E18C),
                              fontFamily: "Poppins",
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.black87,
                            size: 28,
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

  // Widget status card
  Widget _statusCard({
    required IconData icon,
    required Color iconColor,
    required int count,
    required String label,
  }) {
    return Expanded(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.10),
              blurRadius: 11,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 2),
                Text(
                  "$count",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.black.withOpacity(0.54),
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
