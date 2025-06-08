import 'package:flutter/material.dart';
// Import halaman sign in
import 'features/auth/presentation/pages/sign_in_page.dart'; // pastikan path-nya sesuai struktur project kamu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry In',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Set halaman pertama ke SignInPage
      home: const SignInPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
