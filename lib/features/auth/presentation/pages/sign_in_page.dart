import 'package:flutter/material.dart';
import 'sign_up_page.dart';
import 'onboarding_page.dart';
import 'package:laundryin/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Dua state loading terpisah
  bool isLoadingEmail = false;
  bool isLoadingGoogle = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    setState(() {
      isLoadingGoogle = true;
    });

    final auth = AuthService();
    final userCredential = await auth.signInWithGoogle();

    setState(() {
      isLoadingGoogle = false;
    });

    if (userCredential != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal masuk dengan Google")),
      );
    }
  }

  Future<void> _handleEmailPasswordSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password harus diisi!")),
      );
      return;
    }

    setState(() {
      isLoadingEmail = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingPage()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = "Gagal login!";
      if (e.code == 'user-not-found') {
        msg = "Email tidak terdaftar.";
      } else if (e.code == 'wrong-password') {
        msg = "Password salah.";
      } else if (e.code == 'invalid-email') {
        msg = "Format email tidak valid.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan. Coba lagi.")),
      );
    }

    setState(() {
      isLoadingEmail = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                      "LondryIn",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Selamat datang!",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.normal,
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 22),
                    // Card Form
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
                              hintText: "Alamat email",
                              prefixIcon: Icon(
                                Icons.email_rounded,
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
                              hintText: "Kata Sandi",
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
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: isLoadingEmail ? null : _handleEmailPasswordSignIn,
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
                              child: isLoadingEmail
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
                                      "Masuk",
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
                                  "Atau",
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
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: isLoadingGoogle
                                  ? null
                                  : () => _handleGoogleSignIn(context),
                              icon: isLoadingGoogle
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
                                  : Image.asset(
                                      'assets/images/Google.png',
                                      width: 22,
                                      height: 22,
                                    ),
                              label: Text(
                                isLoadingGoogle
                                    ? "Loading..."
                                    : "Masuk dengan Akun Google",
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD8EDFF),
                                foregroundColor: Colors.black87,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Belum punya akun? ",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                  color: Color(0xFFB0B0B0),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUpPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Registrasi",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: Colors.black,
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
