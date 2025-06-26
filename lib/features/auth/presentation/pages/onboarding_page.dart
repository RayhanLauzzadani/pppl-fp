import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../home/home_page.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final double barMin = 16;
  final double barMax = 221 - 16;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animation = Tween<double>(
      begin: barMin,
      end: barMax,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));

    _controller.forward();

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), _navigateToHome);
      }
    });
  }

  // Fix: Langsung return 'laksolaundry'
  String getLaundryId() => 'laksolaundry';

  Future<void> _navigateToHome() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.uid.isEmpty) {
      _showErrorAndExit("User tidak valid atau belum login.");
      return;
    }

    final uid = user.uid;
    final laundryId = getLaundryId();

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('laundries')
          .doc(laundryId)
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        _showErrorAndExit("Data pengguna tidak ditemukan di Firestore.");
        return;
      }

      final data = userDoc.data()!;
      final role = data['role'] ?? '';

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(role: role, laundryId: laundryId),
        ),
      );
    } catch (e) {
      _showErrorAndExit("Gagal memuat data pengguna: ${e.toString()}");
    }
  }

  void _showErrorAndExit(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    Navigator.pop(context); // kembali ke SignInPage
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
          // Background
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
                      color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Positioned(
            left: (size.width - 221) / 2,
            bottom: 28,
            child: SizedBox(
              width: 221,
              height: 16,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        height: 16,
                        width: 221,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.32),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
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
