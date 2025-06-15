import 'package:flutter/material.dart';
import 'sign_in_page.dart';
// Import Firebase Auth
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool isLoading = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar("Isi semua field!");
      return;
    }
    if (password != confirmPassword) {
      _showSnackBar("Password tidak sama!");
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Sukses, arahkan ke halaman login (atau ke halaman utama)
      _showSnackBar("Registrasi berhasil! Silakan login.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = "Registrasi gagal!";
      if (e.code == 'email-already-in-use') {
        msg = "Email sudah digunakan.";
      } else if (e.code == 'invalid-email') {
        msg = "Format email tidak valid.";
      } else if (e.code == 'weak-password') {
        msg = "Password terlalu lemah (minimal 6 karakter).";
      }
      _showSnackBar(msg);
    } catch (e) {
      _showSnackBar("Terjadi kesalahan. Coba lagi.");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Rectangle background dengan rounded bawah (tidak diubah)
          Container(
            width: double.infinity,
            height: 660.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFF6E9),
                  Color(0xFFBBE2EC),
                  Color(0xFF40A2E3),
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
                    const Text(
                      'LondryIn',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Selamat datang!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      margin: const EdgeInsets.only(bottom: 24, top: 5),
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
                            controller: _emailController,
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
                            controller: _passwordController,
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
                            controller: _confirmPasswordController,
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
                              onPressed: isLoading ? null : _handleSignUp,
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black54,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Daftar',
                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                            ),
                          ),
                          // ... (sisanya tidak berubah)
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
                          // Tombol Google Sign Up (opsional, bisa dihubungkan dengan Google Auth)
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
                              onPressed: () {
                                // TODO: Tambahkan Google Sign Up jika ingin
                              },
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
