import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient background - sekarang 75% tinggi layar!
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: size.height * 0.75,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF40A2E3), // BIRU ATAS
                    Color(0xFFBBE2EC),
                    Color(0xFFFFF6E9), // KREM BAWAH
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.65, 1.0],
                ),
              ),
            ),
          ),
          // Konten
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 36),
                // LOGO DAN JUDUL
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Image.asset(
                            'assets/images/logo laundryin.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "LondryIn",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const Text(
                        "Selamat datang!",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // Card benar-benar grounded!
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 18,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: "Alamat email",
                                  prefixIcon: const Icon(Icons.email_rounded, color: Color(0xFF50505A)),
                                  filled: true,
                                  fillColor: const Color(0xFFBBE2EC),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF50505A),
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Kata Sandi",
                                  prefixIcon: const Icon(Icons.key_rounded, color: Color(0xFF50505A)),
                                  filled: true,
                                  fillColor: const Color(0xFFBBE2EC),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
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
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFE0B2),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    textStyle: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    "Masuk",
                                    style: TextStyle(color: Color(0xFF50505A)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: const [
                                  Expanded(child: Divider(thickness: 1)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "Atau",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        color: Color(0xFF50505A),
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider(thickness: 1)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    'assets/images/Google.png',
                                    width: 22,
                                    height: 22,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.g_mobiledata, color: Colors.red, size: 28);
                                    },
                                  ),
                                  label: const Text(
                                    "Masuk dengan Akun Google",
                                    style: TextStyle(
                                      color: Color(0xFF50505A),
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFBBE2EC),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
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
                                        // TODO: navigasi ke halaman registrasi
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
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
