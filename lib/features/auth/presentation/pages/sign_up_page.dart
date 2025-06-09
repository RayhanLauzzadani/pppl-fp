import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF479CFF), // biru atas
              Color(0xFFE8CDA5), // krem bawah
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Logo di tengah atas
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Judul
                  const Text(
                    'LondryIn',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selamat datang!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Card Form
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
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
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFD8EDFF),
                            hintText: 'Alamat email',
                            prefixIcon: Icon(Icons.email,
                                color: Colors.grey.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Password
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFD8EDFF),
                            hintText: 'Kata Sandi',
                            prefixIcon: Icon(Icons.vpn_key,
                                color: Colors.grey.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Konfirmasi Password
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFD8EDFF),
                            hintText: 'Konfirmasi Kata Sandi',
                            prefixIcon: Icon(Icons.vpn_key,
                                color: Colors.grey.shade700),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
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
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: const [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('Atau'),
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
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            icon: Image.asset(
                              'assets/images/google_logo.png', // ganti sesuai asset logo Google-mu
                              width: 22,
                              height: 22,
                            ),
                            label: const Text(
                              'Daftar dengan Akun Google',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Teks login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Sudah punya akun? ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Masuk',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
