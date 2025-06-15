import 'package:flutter/material.dart';
// import 'package:laundryin/features/home/home_page.dart';
// import 'package:laundryin/features/pesanan/proses_pesanan_page.dart';
import 'features/auth/presentation/pages/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'features/pesanan/pesanan_model.dart';



void main() async {
  // WAJIB: Pastikan widget binding & Firebase init selesai sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      // home: HomePage(),
      // Nanti bisa tambahkan routes di sini kalau sudah banyak page
    );
  }
}
