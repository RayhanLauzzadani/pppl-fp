import 'package:flutter/material.dart';
import '../../../home/home_page.dart'; // <-- ini path benar!

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});
  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final double barMin = 16; // bar awal (titik)
  final double barMax = 221 - 16; // panjang total bar

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _animation = Tween<double>(
      begin: barMin,
      end: barMax,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));

    _controller.forward();

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Delay sedikit biar user lihat bar sudah full dulu, baru navigate
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Background
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              "assets/images/image_onboarding.png",
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.13, 0.58, 1.0],
                  colors: [
                    Color(0xFF40A2E3),
                    Color(0xFFBBE2EC),
                    Color(0x00FFF6E9),
                  ],
                ),
              ),
            ),
          ),
          // 2. Konten utama
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  "LondryIn",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Manage with Ease,\nGrow with Confidence",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    "Kelola bisnis loundry anda dan coba fitur-fitur yang dapat membantu Anda di aplikasi LondryIn!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          // 3. Loading Bar Animasi
          Positioned(
            left: (size.width - 221) / 2,
            bottom: 28,
            child: SizedBox(
              width: 221,
              height: 16,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Rail (track)
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        height: 16,
                        width: 221,
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.32),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  // Animated bar
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: _animation.value,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                  // Bulatan kiri
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
