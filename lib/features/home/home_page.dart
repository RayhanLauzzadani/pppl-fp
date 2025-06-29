import 'package:flutter/material.dart';
import 'owner/home_page_owner.dart';
import 'karyawan/home_page_karyawan.dart';

class HomePage extends StatefulWidget {
  final String role;
  final String laundryId;
  final String emailUser;
  final String passwordUser;

  const HomePage({
    super.key,
    required this.role,
    required this.laundryId,
    required this.emailUser,
    required this.passwordUser,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _routeByRole());
  }

  void _routeByRole() {
    final role = widget.role.toLowerCase();
    if (role == 'owner') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePageOwner(
            laundryId: widget.laundryId,
            role: widget.role,
            emailUser: widget.emailUser,
            passwordUser: widget.passwordUser,
          ),
        ),
      );
    } else if (role == 'karyawan') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePageKaryawan(
            laundryId: widget.laundryId,
            role: widget.role,
            emailUser: widget.emailUser,
            passwordUser: widget.passwordUser,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Role tidak dikenali. Silakan login ulang.")),
      );
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            Text(
              "Mengalihkan ke halaman utama...",
              style: TextStyle(fontFamily: "Poppins"),
            ),
          ],
        ),
      ),
    );
  }
}
