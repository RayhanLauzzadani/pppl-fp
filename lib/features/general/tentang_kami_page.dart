import 'package:flutter/material.dart';
import 'syarat_ketentuan_page.dart';
import 'kebijakan_privasi_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 42, left: 0, right: 0, bottom: 22),
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
                      "Tentang Kami",
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
          // Card Main Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 17),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 9,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/logo.png",
                            height: 39,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "LondryIn",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      const Text(
                        "Aplikasi ini hadir untuk mengatasi tantangan yang diperlukan untuk membantu pelaku bisnis laundry dalam mengelola operasional bisnis dengan lebih efisien. Aplikasi laundry yang kami tawarkan akan menyediakan fitur-fitur yang dapat memudahkan pelaku bisnis laundry dalam menjalankan bisnisnya. Dengan demikian, pelaku bisnis laundry dapat fokus pada peningkatan kualitas layanan dan kepuasan pelanggan.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 13.5,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 17),
                      const Divider(height: 25, thickness: 1.2),
                      const Text(
                        "PPPL 2 DSI",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        "Kampus ITS, Keputih, Kec. Sukolilo,\nSurabaya, Jawa Timur 60117",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "londryin@gmail.com",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // WhatsApp Bantuan
                InkWell(
                  borderRadius: BorderRadius.circular(13),
                  onTap: () {
                    // TODO: launch WhatsApp (pakai url_launcher)
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDF5E7),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/iconWA.png",
                          width: 27,
                          height: 27,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Butuh bantuan ?",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 7),
                        const Expanded(
                          child: Text(
                            "Chat kami di whatsapp",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                              fontSize: 13.2,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 11),
                // Syarat Ketentuan
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TermsConditionsPage()),
                    );
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: Colors.grey[100],
                  leading: const Icon(Icons.description_outlined, color: Color(0xFF40A2E3)),
                  title: const Text(
                    "Syarat Ketentuan",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.5,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 17),
                  dense: true,
                ),
                // Kebijakan Privasi
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const KebijakanPrivasiPage()),
                    );
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: Colors.grey[100],
                  leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xFF40A2E3)),
                  title: const Text(
                    "Kebijakan Privasi",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.5,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 17),
                  dense: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
