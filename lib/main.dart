import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
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
    // Atur designSize sesuai ukuran Figma/mockup kamu!
    return ScreenUtilInit(
      designSize: const Size(390, 844), // contoh: iPhone 12/13/14 Pro
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'LondryIn',
          debugShowCheckedModeBanner: false,
          home: const LandingPage(),
          // tambahkan routes jika perlu
        );
      },
    );
  }
}
