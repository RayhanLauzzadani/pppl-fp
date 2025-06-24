import 'package:flutter/material.dart';

class KebijakanPrivasiPage extends StatelessWidget {
  const KebijakanPrivasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER GRADIENT
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
                      "Kebijakan Privasi",
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
          // BODY CONTENT
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Image(
                            image: AssetImage('assets/images/logo.png'),
                            height: 36,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "LondryIn",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 13),
                      _KebijakanText(),
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
}

class _KebijakanText extends StatelessWidget {
  const _KebijakanText();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 13.3,
          color: Colors.black87,
        ),
        children: [
          TextSpan(
            text: "1. Informasi yang Kami Kumpulkan\n",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: "• Informasi Pribadi: Nama, email, nomor telepon, dan informasi bisnis laundry.\n"),
          TextSpan(text: "• Data Transaksi: Catatan penjualan, data pelanggan, dan informasi terkait operasional laundry.\n"),
          TextSpan(text: "• Data Teknis: Informasi perangkat, alamat IP, dan data log aplikasi.\n\n"),

          TextSpan(
            text: "2. Penggunaan Informasi\n",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: "Kami menggunakan informasi yang dikumpulkan untuk:\n"),
          TextSpan(text: "• Menyediakan layanan aplikasi sesuai kebutuhan Anda.\n"),
          TextSpan(text: "• Mengembangkan dan meningkatkan fitur aplikasi.\n"),
          TextSpan(text: "• Mengirimkan notifikasi terkait pembaruan atau informasi penting.\n\n"),

          TextSpan(
            text: "3. Perlindungan Data\n",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: "Kami menjaga kerahasiaan dan keamanan data Anda dengan menerapkan langkah-langkah keamanan seperti enkripsi dan firewall.\n\n"),

          TextSpan(
            text: "4. Pembagian Informasi\n",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: "Kami tidak akan membagikan data Anda kepada pihak ketiga tanpa persetujuan, kecuali diperlukan oleh hukum atau untuk layanan tertentu (misalnya, penyedia pembayaran).\n\n"),

          TextSpan(
            text: "5. Hak Pengguna\n",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: "Pengguna memiliki hak untuk:\n"),
          TextSpan(text: "• Mengakses, mengubah, atau menghapus data pribadi yang terdaftar.\n"),
          TextSpan(text: "• Menarik persetujuan penggunaan data kapan saja dengan menghentikan penggunaan aplikasi.\n\n"),

          TextSpan(
            text: "6. Cookies\n",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: "Aplikasi LaundryIN dapat menggunakan cookies untuk meningkatkan pengalaman pengguna. Anda dapat mengatur preferensi cookies melalui pengaturan perangkat Anda.\n\n"),

          TextSpan(
            text: "7. Perubahan Kebijakan Privasi\n",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: "Kami dapat memperbarui Kebijakan Privasi ini sewaktu-waktu. Perubahan akan diinformasikan melalui aplikasi atau email.\n\n"),

          TextSpan(
            text: "8. Kontak Kami\n",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: "Jika Anda memiliki pertanyaan terkait Kebijakan Privasi atau Syarat dan Ketentuan, silakan hubungi kami melalui email: support@laundryin.com"),
        ],
      ),
      textAlign: TextAlign.justify,
    );
  }
}
