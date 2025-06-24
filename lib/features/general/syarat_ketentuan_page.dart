import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER: Gradient + Title
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
                      "Syarat dan Ketentuan",
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
          // CARD UTAMA
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo + Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/logo.png", // Ganti ke path logo kamu
                            height: 34,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "LondryIn",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Syarat Ketentuan (teks)
                      _termsContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _termsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(height: 11),
        _SectionTitle('1. Penerimaan Syarat dan Ketentuan'),
        _SectionContent(
          'Dengan mengunduh, mengakses, dan menggunakan aplikasi LaundryIN, Anda setuju untuk mematuhi dan terikat oleh Syarat dan Ketentuan ini. Jika Anda tidak setuju, harap berhenti menggunakan aplikasi ini.',
        ),
        SizedBox(height: 12),
        _SectionTitle('2. Layanan LaundryIN'),
        _SectionContent(
          'Aplikasi LaundryIN dirancang untuk membantu pengelolaan bisnis laundry, termasuk pemantauan transaksi, pencatatan data pelanggan, dan pengelolaan inventori.\n'
          'Layanan bersifat non-transferable dan hanya dapat digunakan oleh pemilik akun terdaftar.',
        ),
        SizedBox(height: 12),
        _SectionTitle('3. Akun Pengguna'),
        _SectionContent(
          '• Anda bertanggung jawab untuk menjaga kerahasiaan akun dan kata sandi.\n'
          '• LaundryIN tidak bertanggung jawab atas penggunaan akun Anda oleh pihak lain.',
        ),
        SizedBox(height: 12),
        _SectionTitle('4. Larangan Penggunaan'),
        _SectionContent(
          'Pengguna tidak diperkenankan:\n'
          '• Menggunakan aplikasi untuk kegiatan ilegal atau melanggar hukum.\n'
          '• Mengakses, mengubah, atau merusak sistem LaundryIN tanpa izin.',
        ),
        SizedBox(height: 12),
        _SectionTitle('5. Batasan Tanggung Jawab'),
        _SectionContent(
          'LaundryIN tidak bertanggung jawab atas kerugian langsung maupun tidak langsung yang timbul dari penggunaan aplikasi, termasuk kehilangan data atau kerusakan perangkat.',
        ),
        SizedBox(height: 12),
        _SectionTitle('6. Perubahan Syarat dan Ketentuan'),
        _SectionContent(
          'LaundryIN berhak mengubah Syarat dan Ketentuan ini sewaktu-waktu. Perubahan akan diberitahukan melalui aplikasi atau email terdaftar.',
        ),
        SizedBox(height: 12),
        _SectionTitle('7. Penghentian Layanan'),
        _SectionContent(
          'LaundryIN berhak menghentikan layanan kepada pengguna yang melanggar Syarat dan Ketentuan.',
        ),
      ],
    );
  }
}

// Widget Judul Section
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w700,
        fontSize: 15.2,
        color: Colors.black,
      ),
    );
  }
}

// Widget Isi Section
class _SectionContent extends StatelessWidget {
  final String text;
  const _SectionContent(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontFamily: "Poppins",
        fontSize: 13.2,
        color: Colors.black87,
        height: 1.48,
      ),
    );
  }
}
