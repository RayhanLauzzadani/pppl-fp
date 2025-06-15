import 'package:flutter/material.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background utama (body)
      body: Stack(
        children: [
          // Rectangle background dengan rounded bawah
          Container(
            width: double.infinity,
            height: 660.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFF6E9), // warna kiri bawah
                  Color(0xFFBBE2EC), // tengah
                  Color(0xFF40A2E3), // kanan atas
                ],
                stops: [0.18, 0.38, 0.83],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          // Konten (logo, judul, form, dsb)
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    Center(
                      child: CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 160,
                          height: 160,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'LondryIn',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Selamat datang!',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      margin: const EdgeInsets.only(bottom: 24, top: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Email
                          TextField(
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFD8EDFF),
                              hintText: 'Alamat email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.grey.shade700,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: const TextStyle(
                                color: Color(0xFF50505A),
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Password
                          TextField(
                            obscureText: true,
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFD8EDFF),
                              hintText: 'Kata Sandi',
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                color: Colors.grey.shade700,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: const TextStyle(
                                color: Color(0xFF50505A),
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Konfirmasi Password
                          TextField(
                            obscureText: true,
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFD8EDFF),
                              hintText: 'Konfirmasi Kata Sandi',
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                color: Colors.grey.shade700,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: const TextStyle(
                                color: Color(0xFF50505A),
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Tombol Daftar
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFDE3B4),
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 1,
                                textStyle: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Daftar',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: const [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Atau',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 14),
                          // Tombol Google Sign Up
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD8EDFF),
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                textStyle: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              icon: Image.asset(
                                'assets/images/Google.png',
                                width: 22,
                                height: 22,
                              ),
                              label: const Text(
                                'Daftar dengan Akun Google',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Sudah punya akun? ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignInPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
