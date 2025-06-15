import 'package:flutter/material.dart';
import 'package:laundryin/features/auth/presentation/pages/sign_up_page.dart';
import 'features/auth/presentation/pages/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/home/home_page.dart';
import 'features/profile/edit_profile_page.dart';

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
      // home: const LandingPage(),
      home: SignUpPage(), // atau LandingPage jika kamu punya sistem login
      // Nanti bisa tambahkan routes di sini kalau sudah banyak page
    );
  }
}
