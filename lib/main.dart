import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/landing_page.dart'; // pastikan path-nya benar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LondryIn',
      debugShowCheckedModeBanner: false,
      home: const LandingPage(),
      // Nanti bisa tambahkan routes di sini kalau sudah banyak page
    );
  }
}
