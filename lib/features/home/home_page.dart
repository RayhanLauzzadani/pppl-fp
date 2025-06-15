import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';
  String userEmail = '';
  bool isLoading = true; // Tambahan: indikator loading

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userName = doc['name'] ?? '';
        userEmail = doc['email'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        userName = '';
        userEmail = '';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Navigasi ke login (harus disesuaikan dengan route project kamu)
              // Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [0.01, 0.12, 0.83],
                      colors: [
                        Color(0xFFFFF6E9),
                        Color(0xFFBBE2EC),
                        Color(0xFF40A2E3),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x15000000),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hai, Selamat datang",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white.withOpacity(0.93),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userName.isNotEmpty ? userName : "User",
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          shadows: [
                            Shadow(
                              color: Colors.black12,
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        userEmail,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Tambahkan widget lain di bawah sini
                Center(
                  child: Text(
                    'Dashboard Fitur di sini',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
    );
  }
}
