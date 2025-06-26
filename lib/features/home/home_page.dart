import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'owner/home_page_owner.dart';
import 'karyawan/home_page_karyawan.dart';

class HomePage extends StatefulWidget {
  final String role;
  final String laundryId;

  const HomePage({super.key, required this.role, required this.laundryId});

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
    if (widget.role == 'owner') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePageOwner(laundryId: widget.laundryId),
        ),
      );
    } else if (widget.role == 'karyawan') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePageKaryawan(laundryId: widget.laundryId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Role tidak dikenali.")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hanya loader sementara routing
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
