import 'package:flutter/material.dart';
import '../../../profile/edit_profile_page.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final statusController = TextEditingController(text: "Ownership");

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            width: double.infinity,
            height: 660.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF6E9), Color(0xFFBBE2EC), Color(0xFF40A2E3)],
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
                    CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors.white,
                      child: Image.asset('assets/images/logo.png', width: 160, height: 160),
                    ),
                    const SizedBox(height: 25),
                    const Text('LondryIn',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.white,
                        )),
                    const SizedBox(height: 5),
                    const Text('Selamat datang!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.normal,
                          fontSize: 28,
                          color: Colors.white,
                        )),
                    const SizedBox(height: 22),

                    // Form Container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      margin: const EdgeInsets.only(bottom: 24, top: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 16, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Nama
                          _inputField(controller: nameController, hint: 'Nama Perusahaan', icon: Icons.business),
                          const SizedBox(height: 14),

                          // Email
                          _inputField(controller: emailController, hint: 'Alamat email', icon: Icons.email),
                          const SizedBox(height: 14),

                          // WhatsApp
                          _inputField(controller: phoneController, hint: 'Nomor WhatsApp', icon: Icons.phone),
                          const SizedBox(height: 14),

                          // Password
                          _inputField(
                            controller: passwordController,
                            hint: 'Kata Sandi',
                            icon: Icons.vpn_key,
                            obscure: true,
                          ),
                          const SizedBox(height: 14),

                          // Konfirmasi Password
                          _inputField(
                            controller: confirmPasswordController,
                            hint: 'Konfirmasi Kata Sandi',
                            icon: Icons.vpn_key,
                            obscure: true,
                          ),
                          const SizedBox(height: 18),

                          // Tombol Daftar
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {
                                if (passwordController.text != confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Konfirmasi password tidak cocok')),
                                  );
                                  return;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditProfilPage(
                                      name: nameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text,
                                      password: passwordController.text,
                                      status: statusController.text,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFDE3B4),
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 1,
                              ),
                              child: const Text('Daftar'),
                            ),
                          ),

                          const SizedBox(height: 14),
                          const DividerWithText(),
                          const SizedBox(height: 14),

                          // Tombol Google (dummy)
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: Image.asset('assets/images/Google.png', width: 22, height: 22),
                              label: const Text('Daftar dengan Akun Google'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD8EDFF),
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun? ', style: TextStyle(color: Colors.grey)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInPage()));
                                },
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
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

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFD8EDFF),
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Atau', style: TextStyle(fontFamily: "Poppins", fontSize: 14, color: Colors.grey)),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}