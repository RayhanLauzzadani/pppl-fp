import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/presentation/pages/sign_in_page.dart'; // Ganti import ini!
import 'features/home/home_page.dart';
import 'dart:io';

class SplashOrWrapperPage extends StatefulWidget {
  const SplashOrWrapperPage({super.key});

  @override
  State<SplashOrWrapperPage> createState() => _SplashOrWrapperPageState();
}

class _SplashOrWrapperPageState extends State<SplashOrWrapperPage> {
  @override
  void initState() {
    super.initState();
    _initCheck();
  }

  Future<void> _initCheck() async {
    await Future.delayed(const Duration(milliseconds: 1200)); // splash delay
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!mounted) return;

    if (loggedIn) {
      // Ambil data user
      final role = prefs.getString('role') ?? '';
      final laundryId = prefs.getString('laundryId') ?? '';
      final emailUser = prefs.getString('emailUser') ?? '';
      final passwordUser = prefs.getString('passwordUser') ?? '';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => _HomePageWithExit(
            role: role,
            laundryId: laundryId,
            emailUser: emailUser,
            passwordUser: passwordUser,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const _SignInPageWithExit()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // SplashScreen LaundryIn
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 18),
            const Text(
              'LaundryIn',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Color(0xFF3E7DD1),
                letterSpacing: 1.5,
                fontFamily: "Poppins",
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: Color(0xFF3E7DD1),
              strokeWidth: 2.3,
            ),
          ],
        ),
      ),
    );
  }
}

// ====================
// HomePage + WillPopScope agar BACK = Keluar aplikasi
// ====================
class _HomePageWithExit extends StatelessWidget {
  final String role;
  final String laundryId;
  final String emailUser;
  final String passwordUser;
  const _HomePageWithExit({
    required this.role,
    required this.laundryId,
    required this.emailUser,
    required this.passwordUser,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Exit aplikasi saat tekan back di HomePage
        if (Platform.isAndroid) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Future.delayed(const Duration(milliseconds: 50), () {
            exit(0);
          });
          return false;
        }
        return true;
      },
      child: HomePage(
        role: role,
        laundryId: laundryId,
        emailUser: emailUser,
        passwordUser: passwordUser,
      ),
    );
  }
}

// ====================
// SignInPage + WillPopScope agar BACK = Keluar aplikasi
// ====================
class _SignInPageWithExit extends StatelessWidget {
  const _SignInPageWithExit({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Future.delayed(const Duration(milliseconds: 50), () {
            exit(0);
          });
          return false;
        }
        return true;
      },
      child: const SignInPage(),
    );
  }
}
