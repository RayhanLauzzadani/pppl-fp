import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar/logo
              Image.asset(
                'assets/logo_laundry.png', // ganti dengan path asset gambar kamu
                width: 280,
                height: 280,
              ),
              const SizedBox(height: 56),
              // Tombol Get Started
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF265C48), // warna text
                  backgroundColor: const Color(0xFFFDE3B4), // warna tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shadowColor: Colors.black38,
                ),
                onPressed: () {
                  // TODO: Arahkan ke Sign In Page
                  // Navigator.pushNamed(context, '/sign-in');
                },
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
