import 'package:flutter/material.dart';
// Import dari file kelola_akun_page.dart yang benar
import 'package:laundryin/features/profile/kelola_akun_page.dart';

class EditProfilPage extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String status;

  const EditProfilPage({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.status,
  });

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController statusController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    passwordController = TextEditingController(text: widget.password);
    statusController = TextEditingController(text: widget.status);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    statusController.dispose();
    super.dispose();
  }

  void _handleUpdateProfile() {
    // Simpan perubahan ke Firestore kalau mau, atau cukup show snackbar:
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil berhasil diupdate!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFBBE2EC), Color(0xFF40A2E3)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const Text("Edit Profil", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Foto profil
            Column(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xFFF6F7FB),
                  child: Icon(Icons.person, size: 55, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Ubah Gambar",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _formField("Nama Perusahaan", nameController),
            _formField("Email Perusahaan", emailController),
            _formField("Status Akun", statusController),
            _formField("Nomor Whatsapp", phoneController),
            _formField("Password", passwordController, obscureText: true),
            const SizedBox(height: 20),
            // Tombol "Kelola Akun Karyawan"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KelolaAkunPage(), // PASTIKAN ini import dari file terpisah!
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE76161),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Kelola Akun Karyawan", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            // Tombol "Update"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleUpdateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40A2E3),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Update", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
