import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final bool isOwner; // true: owner, false: karyawan

  const EditProfilePage({super.key, required this.isOwner});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController namaController = TextEditingController(text: "Jamal Sentosa Loundry");
  final TextEditingController emailController = TextEditingController(text: "sentosalondry@gmail.com");
  final TextEditingController statusController = TextEditingController(text: "Ownership");
  final TextEditingController waController = TextEditingController(text: "+62 851-5698-6534");
  final TextEditingController passwordController = TextEditingController(text: "kucingkusatu");

  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final isOwner = widget.isOwner;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER GRADIENT mirip edit layanan
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

          // BODY
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // FOTO PROFIL + BORDER
                    Center(
                      child: Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF40A2E3),
                            width: 3.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 7,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage("assets/images/profile.jpg"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // TODO: implement edit photo
                      },
                      child: const Text(
                        "Ubah Gambar",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15.4,
                          color: Color(0xFF40A2E3),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 17),

                    // NAMA PERUSAHAAN
                    _label("Nama Perusahaan"),
                    _textField(
                      controller: namaController,
                      readOnly: !isOwner,
                      hint: "Nama Perusahaan",
                    ),
                    // EMAIL (Owner only)
                    if (isOwner) ...[
                      _label("Email Perusahaan"),
                      _textField(
                        controller: emailController,
                        readOnly: true,
                        hint: "Email Perusahaan",
                      ),
                    ],

                    // STATUS AKUN
                    _label("Status Akun"),
                    _textField(
                      controller: statusController,
                      readOnly: true,
                      hint: "Status Akun",
                    ),

                    // NOMOR WHATSAPP
                    _label("Nomor Whatsapp"),
                    _textField(
                      controller: waController,
                      readOnly: !isOwner,
                      hint: "Nomor WhatsApp",
                      keyboardType: TextInputType.phone,
                    ),

                    // PASSWORD
                    _label("Password"),
                    _passwordField(
                      controller: passwordController,
                      visible: passwordVisible,
                      onToggle: () => setState(() => passwordVisible = !passwordVisible),
                    ),
                    const SizedBox(height: 24),

                    // BUTTON UPDATE (owner only)
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
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Profil berhasil diupdate")),
                            );
                          },
                          child: const Text("Update", style: TextStyle(fontSize: 18)),
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
              borderSide: BorderSide(color: const Color(0xFF40A2E3)),
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
