import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Branding: bisa diganti
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO
            Image.asset(
              'assets/images/logo.png', // Pastikan path di pubspec.yaml
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 18),
            // BRANDING TEXT
            Text(
              "LaundryIn",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: const Color(0xFF279AF1),
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 3,
                    offset: const Offset(0, 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // LOADING
            const CircularProgressIndicator(
              color: Color(0xFF279AF1),
              strokeWidth: 2.3,
            ),
          ],
        ),
      ),
    );
  }
}
