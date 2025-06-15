import 'package:flutter/material.dart';

class EditProfilPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);
    final phoneController = TextEditingController(text: phone);
    final passwordController = TextEditingController(text: password);
    final statusController = TextEditingController(text: status);


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
                CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage('assets/images/profile_sample.jpg'),
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

            // Form Fields
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
                  // TODO: Navigate to Kelola Akun Karyawan Page
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
                onPressed: () {
                  // TODO: Handle Update
                },
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
