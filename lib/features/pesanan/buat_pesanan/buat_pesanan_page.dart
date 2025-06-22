import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/gradient_appbar.dart';
import 'widgets/layanan_tile.dart';
import 'pilih_layanan_page.dart';

class BuatPesananPage extends StatefulWidget {
  const BuatPesananPage({super.key});

  @override
  State<BuatPesananPage> createState() => _BuatPesananPageState();
}

class _BuatPesananPageState extends State<BuatPesananPage> {
  final namaController = TextEditingController();
  final waController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  String? kodeLaundryUser;
  bool _loadingKodeLaundry = true;

  @override
  void initState() {
    super.initState();
    _fetchKodeLaundry();
  }

  Future<void> _fetchKodeLaundry() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _loadingKodeLaundry = false;
      });
      return;
    }
    // Cari kodeLaundry di semua laundry (karena karyawan tidak tahu kode laundrynya sendiri)
    final snapshots = await FirebaseFirestore.instance.collection('laundries').get();
    for (var doc in snapshots.docs) {
      final userDoc = await doc.reference.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          kodeLaundryUser = doc.id;
          _loadingKodeLaundry = false;
        });
        return;
      }
    }
    setState(() {
      _loadingKodeLaundry = false;
    });
  }

  @override
  void dispose() {
    namaController.dispose();
    waController.dispose();
    super.dispose();
  }

  bool _isValidName(String name) {
    return RegExp(r"^[A-Za-z\s]{2,}$").hasMatch(name);
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^08[0-9]{8,11}$').hasMatch(phone);
  }

  void _onLayananTap(String label, String desc) {
    String nama = namaController.text.trim();
    String wa = waController.text.trim();

    if (nama.isEmpty || wa.isEmpty) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Nama dan nomor Whatsapp wajib diisi!'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (!_isValidName(nama)) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text(
              'Nama hanya boleh huruf dan spasi, minimal 2 karakter!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (!_isValidPhone(wa)) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text(
              'Nomor Whatsapp tidak valid! Harus diawali 08 dan 10-13 digit angka.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (kodeLaundryUser == null) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Kode laundry belum ditemukan. Coba relogin.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PilihLayananPage(
          nama: nama,
          whatsapp: wa,
          layanan: label,
          desc: desc,
          kodeLaundry: kodeLaundryUser!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBF6),
        appBar: const GradientAppBar(title: "Buat Pesanan"),
        body: _loadingKodeLaundry
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama
                    const Text(
                      "Nama",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.5,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                          borderSide: BorderSide(color: Color(0xFFD2D2D2)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                          borderSide: BorderSide(color: Color(0xFFD2D2D2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                          borderSide: BorderSide(color: Color(0xFF4EA6ED)),
                        ),
                        hintText: "Contoh: Budi Santoso",
                      ),
                      style: TextStyle(fontSize: 15.8, fontFamily: 'Poppins'),
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    // Whatsapp
                    const Text(
                      "Nomor Whatsapp",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.5,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: waController,
                      decoration: const InputDecoration(
                        hintText: "08xxxxxxxxxx",
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                          borderSide: BorderSide(color: Color(0xFFD2D2D2)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                          borderSide: BorderSide(color: Color(0xFFD2D2D2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                          borderSide: BorderSide(color: Color(0xFF4EA6ED)),
                        ),
                      ),
                      style: TextStyle(fontSize: 15.8, fontFamily: 'Poppins'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 28),
                    // Pilihan Layanan
                    LayananTile(
                      label: "3 Hari",
                      desc: "Reguler",
                      onTap: () => _onLayananTap("3 Hari", "Reguler"),
                    ),
                    const SizedBox(height: 18),
                    LayananTile(
                      label: "1 Hari",
                      desc: "Ekspress",
                      onTap: () => _onLayananTap("1 Hari", "Ekspress"),
                    ),
                    const SizedBox(height: 18),
                    LayananTile(
                      label: "3 Jam",
                      desc: "Kilat",
                      onTap: () => _onLayananTap("3 Jam", "Kilat"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
