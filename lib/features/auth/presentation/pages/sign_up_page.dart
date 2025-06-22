import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  // Tambahan
  final kodeLaundryController = TextEditingController();
  final namaLaundryController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    kodeLaundryController.dispose();
    namaLaundryController.dispose();
    super.dispose();
  }

  // Dialog untuk input kode + nama laundry (senada UI signup)
  Future<Map<String, String>?> _inputLaundryDialog() async {
    final kodeLaundryField = TextEditingController();
    final namaLaundryField = TextEditingController();
    bool isError = false;

    return await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            title: const Text(
              "Verifikasi Laundry",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF40A2E3),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Kode Laundry
                TextField(
                  controller: kodeLaundryField,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFD8EDFF),
                    hintText: "Kode Laundry",
                    prefixIcon: Icon(Icons.vpn_key, color: Colors.grey.shade700),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                  style: const TextStyle(fontFamily: "Poppins"),
                ),
                const SizedBox(height: 12),
                // Nama Laundry
                TextField(
                  controller: namaLaundryField,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFD8EDFF),
                    hintText: "Nama Laundry",
                    prefixIcon: Icon(Icons.business, color: Colors.grey.shade700),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                  style: const TextStyle(fontFamily: "Poppins"),
                ),
                if (isError)
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Kode & Nama Laundry wajib diisi",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
              ],
            ),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("Batal", style: TextStyle(fontFamily: "Poppins")),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBBE2EC),
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                ),
                onPressed: () {
                  if (kodeLaundryField.text.trim().isEmpty ||
                      namaLaundryField.text.trim().isEmpty) {
                    setState(() => isError = true);
                  } else {
                    Navigator.of(ctx).pop({
                      'kodeLaundry': kodeLaundryField.text.trim(),
                      'namaLaundry': namaLaundryField.text.trim(),
                    });
                  }
                },
                child: const Text("Verifikasi", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final nama = nameController.text.trim();
    final phone = phoneController.text.trim();
    final kodeLaundry = kodeLaundryController.text.trim();
    final namaLaundryInput = namaLaundryController.text.trim();

    if (nama.isEmpty || email.isEmpty || password.isEmpty || kodeLaundry.isEmpty || namaLaundryInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama, email, password, kode laundry, dan nama laundry harus diisi.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak cocok')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Verifikasi kode laundry & nama laundry
      final laundryDoc = await FirebaseFirestore.instance
          .collection('laundries')
          .doc(kodeLaundry)
          .get();

      if (!laundryDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kode laundry tidak ditemukan.')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final namaLaundryFirestore = (laundryDoc.data()?['nama'] as String?) ?? "";
      if (namaLaundryFirestore.toLowerCase() != namaLaundryInput.toLowerCase()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama laundry tidak cocok dengan kode laundry.')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 2. Buat akun Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user?.uid;

      // 3. Simpan data user ke Firestore
      await FirebaseFirestore.instance
          .collection('laundries')
          .doc(kodeLaundry)
          .collection('users')
          .doc(uid)
          .set({
        'email': email,
        'nama': nama,
        'phone': phone,
        'role': 'karyawan',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun berhasil dibuat! Silakan login.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SignInPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String msg = "Gagal mendaftar";
      if (e.code == 'email-already-in-use') {
        msg = "Email sudah terdaftar.";
      } else if (e.code == 'invalid-email') {
        msg = "Format email tidak valid.";
      } else if (e.code == 'weak-password') {
        msg = "Password terlalu lemah (minimal 6 karakter).";
      } else if (e.message != null) {
        msg = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Google Sign In + validasi laundry
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) throw Exception("Login gagal");

      // ==== Pop up 2 field ====
      final dataLaundry = await _inputLaundryDialog();
      if (dataLaundry == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Anda harus mengisi kode dan nama laundry")),
        );
        setState(() => _isLoading = false);
        return;
      }
      final kodeLaundry = dataLaundry['kodeLaundry']!;
      final namaLaundry = dataLaundry['namaLaundry']!;

      // ==== Validasi di Firestore ====
      final laundryDoc = await FirebaseFirestore.instance
          .collection('laundries')
          .doc(kodeLaundry)
          .get();

      if (!laundryDoc.exists ||
          (laundryDoc.data()?['nama'] as String?)?.toLowerCase() != namaLaundry.toLowerCase()) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kode laundry/nama laundry tidak cocok!")));
        setState(() => _isLoading = false);
        return;
      }

      // Simpan user ke Firestore (subcollection)
      await FirebaseFirestore.instance
          .collection('laundries')
          .doc(kodeLaundry)
          .collection('users')
          .doc(user.uid)
          .set({
        'email': user.email,
        'nama': user.displayName ?? '',
        'phone': user.phoneNumber ?? "",
        'role': 'karyawan',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil daftar/login dengan Google!')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignInPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Google gagal: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            width: double.infinity,
            height: 660.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF6E9), Color(0xFFBBE2EC), Color(0xFF40A2E3)],
                stops: [0.18, 0.38, 0.83],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors.white,
                      child: Image.asset('assets/images/logo.png', width: 160, height: 160),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'LondryIn',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Selamat datang!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Form Container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      margin: const EdgeInsets.only(bottom: 24, top: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 16, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Nama
                          _inputField(controller: nameController, hint: 'Nama Karyawan', icon: Icons.person),
                          const SizedBox(height: 14),

                          // Email
                          _inputField(controller: emailController, hint: 'Alamat email', icon: Icons.email),
                          const SizedBox(height: 14),

                          // WhatsApp
                          _inputField(controller: phoneController, hint: 'Nomor WhatsApp', icon: Icons.phone),
                          const SizedBox(height: 14),

                          // Kode Laundry
                          _inputField(controller: kodeLaundryController, hint: 'Kode Laundry', icon: Icons.vpn_key),
                          const SizedBox(height: 14),

                          // Nama Laundry
                          _inputField(controller: namaLaundryController, hint: 'Nama Laundry', icon: Icons.business),
                          const SizedBox(height: 14),

                          // Password
                          _inputField(
                            controller: passwordController,
                            hint: 'Kata Sandi',
                            icon: Icons.vpn_key,
                            obscure: true,
                          ),
                          const SizedBox(height: 14),

                          // Konfirmasi Password
                          _inputField(
                            controller: confirmPasswordController,
                            hint: 'Konfirmasi Kata Sandi',
                            icon: Icons.vpn_key,
                            obscure: true,
                          ),
                          const SizedBox(height: 18),

                          // Tombol Daftar
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFDE3B4),
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 1,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Daftar'),
                            ),
                          ),

                          const SizedBox(height: 14),
                          const DividerWithText(),
                          const SizedBox(height: 14),

                          // Tombol Google
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _signInWithGoogle,
                              icon: Image.asset('assets/images/Google.png', width: 22, height: 22),
                              label: const Text('Daftar dengan Akun Google'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD8EDFF),
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun? ', style: TextStyle(color: Colors.grey)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignInPage()),
                                  );
                                },
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFD8EDFF),
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Atau', style: TextStyle(fontFamily: "Poppins", fontSize: 14, color: Colors.grey)),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
