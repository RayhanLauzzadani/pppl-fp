import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final bool isOwner;
  final String kodeLaundry;
  final String email;
  final String password;

  const EditProfilePage({
    super.key,
    required this.isOwner,
    required this.kodeLaundry,
    required this.email,
    required this.password,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final TextEditingController namaController = TextEditingController(text: "");
  final TextEditingController statusController = TextEditingController(text: "");
  final TextEditingController waController = TextEditingController(text: "");

  bool passwordVisible = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.email);
    passwordController = TextEditingController(text: widget.password);
    _loadProfileFromFirestore();
  }

  Future<void> _loadProfileFromFirestore() async {
    setState(() => isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('laundries')
          .doc(widget.kodeLaundry)
          .get();
      final data = doc.data();
      if (data != null) {
        namaController.text = data['namaLaundry'] ?? "";
        statusController.text = _getRoleDisplay(data['role']);
        waController.text = data['wa'] ?? "";
      }
    } catch (_) {}
    setState(() => isLoading = false);
  }

  Future<void> _updateProfileKeFirestore() async {
    setState(() => isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('laundries')
          .doc(widget.kodeLaundry)
          .update({
        'namaLaundry': namaController.text,
        'wa': waController.text,
        // Tidak update email & password di sini
        // Jika perlu update role juga, tambahkan 'role': ...
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diupdate")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal update profil: $e")),
      );
    }
    setState(() => isLoading = false);
  }

  String _getRoleDisplay(String? role) {
    switch ((role ?? "").toLowerCase()) {
      case 'owner':
        return 'Owner';
      case 'karyawan':
        return 'Karyawan';
      default:
        return role ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = widget.isOwner;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 40, left: 0, right: 0, bottom: 22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF40A2E3),
                      Color(0xFFBBE2EC),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Edit Profil",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 17),
                        _label("Nama Perusahaan"),
                        _textField(
                          controller: namaController,
                          readOnly: !isOwner,
                          hint: "Nama Perusahaan",
                        ),
                        _label("Email Perusahaan"),
                        _textField(
                          controller: emailController,
                          readOnly: true,
                          hint: "Email Perusahaan",
                        ),
                        _label("Status Akun"),
                        _textField(
                          controller: statusController,
                          readOnly: true,
                          hint: "Status Akun",
                        ),
                        _label("Nomor Whatsapp"),
                        _textField(
                          controller: waController,
                          readOnly: !isOwner,
                          hint: "Nomor WhatsApp",
                          keyboardType: TextInputType.phone,
                        ),
                        _label("Password"),
                        _passwordField(
                          controller: passwordController,
                          visible: passwordVisible,
                          onToggle: () => setState(() => passwordVisible = !passwordVisible),
                        ),
                        const SizedBox(height: 24),
                        if (isOwner)
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF40A2E3),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                textStyle: const TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold),
                              ),
                              onPressed: isLoading ? null : _updateProfileKeFirestore,
                              child: isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text("Update", style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.white.withOpacity(0.4),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(left: 4, top: 10, bottom: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );

  Widget _textField({
    required TextEditingController controller,
    bool readOnly = false,
    String hint = "",
    TextInputType keyboardType = TextInputType.text,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: readOnly ? Colors.grey[100] : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF40A2E3)),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          ),
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 15,
          ),
        ),
      );

  Widget _passwordField({
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onToggle,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: TextField(
          controller: controller,
          readOnly: true,
          obscureText: !visible,
          decoration: InputDecoration(
            hintText: "Password",
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            suffixIcon: IconButton(
              icon: Icon(visible ? Icons.visibility : Icons.visibility_off, color: Colors.grey[600]),
              onPressed: onToggle,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          ),
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 15,
            letterSpacing: 2.5,
          ),
        ),
      );
}
