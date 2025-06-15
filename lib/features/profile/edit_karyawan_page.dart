import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditKaryawanPage extends StatefulWidget {
  final String? docId; // <-- nullable!
  final String nama;
  final String email;

  const EditKaryawanPage({
    Key? key,
    this.docId,
    this.nama = '',
    this.email = '',
  }) : super(key: key);

  @override
  State<EditKaryawanPage> createState() => _EditKaryawanPageState();
}

class _EditKaryawanPageState extends State<EditKaryawanPage> {
  late TextEditingController namaController;
  late TextEditingController emailController;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.nama);
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSimpan() async {
    final nama = namaController.text.trim();
    final email = emailController.text.trim();
    if (nama.isEmpty || email.isEmpty) return;

    setState(() => loading = true);

    if (widget.docId == null) {
      // TAMBAH KARYAWAN
      await FirebaseFirestore.instance.collection('karyawan').add({
        'nama': nama,
        'email': email,
      });
    } else {
      // UPDATE KARYAWAN
      await FirebaseFirestore.instance.collection('karyawan').doc(widget.docId).update({
        'nama': nama,
        'email': email,
      });
    }
    setState(() => loading = false);

    if (mounted) Navigator.pop(context);
  }

  Future<void> _handleHapus() async {
    if (widget.docId == null) return;
    setState(() => loading = true);
    await FirebaseFirestore.instance.collection('karyawan').doc(widget.docId).delete();
    setState(() => loading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Kelola Akun Karyawan",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nama", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Akun Email", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: loading ? null : _handleSimpan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue[100],
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: loading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator())
                        : const Text("Update Akun", style: TextStyle(fontStyle: FontStyle.italic)),
                  ),
                ),
                const SizedBox(width: 18),
                if (widget.docId != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: loading ? null : _handleHapus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE76161),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: loading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator())
                          : const Text("Hapus Akun", style: TextStyle(fontStyle: FontStyle.italic)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
