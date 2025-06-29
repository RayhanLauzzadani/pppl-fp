import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/gradient_appbar.dart';
import 'widgets/layanan_tile.dart';
import 'pilih_layanan_page.dart';
import '../../home/owner/home_page_owner.dart';
import '../../home/karyawan/home_page_karyawan.dart';

class BuatPesananPage extends StatefulWidget {
  final String role;
  final String laundryId;
  final String emailUser;
  final String passwordUser;

  const BuatPesananPage({
    super.key,
    required this.role,
    required this.laundryId,
    required this.emailUser,
    required this.passwordUser,
  });

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

  final Map<String, Map<String, dynamic>> _draftPerJenis = {};

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
    final snapshots = await FirebaseFirestore.instance
        .collection('laundries')
        .get();
    for (var doc in snapshots.docs) {
      final userDoc = await doc.reference
          .collection('users')
          .doc(user.uid)
          .get();
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

  Future<void> _onLayananTap(String label, String desc) async {
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
            'Nama hanya boleh huruf dan spasi, minimal 2 karakter!',
          ),
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
            'Nomor Whatsapp tidak valid! Harus diawali 08 dan 10-13 digit angka.',
          ),
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

    final draft = _draftPerJenis[desc];

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PilihLayananPage(
          nama: nama,
          whatsapp: wa,
          layanan: label,
          desc: desc,
          kodeLaundry: kodeLaundryUser!,
          role: widget.role,
          emailUser: widget.emailUser,          // <--- WAJIB DITAMBAHKAN
          passwordUser: widget.passwordUser,    // <--- WAJIB DITAMBAHKAN
          barangCustom: draft?['barangCustom'],
          barangQtyCustom: draft?['barangQty'],
          beratKgSebelumnya: draft?['beratKg'],
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _draftPerJenis[desc] = result;
      });
    }
  }

  // ---- Navigasi ke HomePage sesuai role ----
  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => widget.role.toLowerCase() == 'owner'
            ? HomePageOwner(
                laundryId: widget.laundryId,
                role: widget.role,
                emailUser: widget.emailUser,
                passwordUser: widget.passwordUser,
              )
            : HomePageKaryawan(
                laundryId: widget.laundryId,
                role: widget.role,
                emailUser: widget.emailUser,
                passwordUser: widget.passwordUser,
              ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateToHome();
        return false;
      },
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          backgroundColor: const Color(0xFFFDFBF6),
          body: _loadingKodeLaundry
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Column(
                    children: [
                      GradientAppBar(
                        title: "Buat Pesanan",
                        onBack: _navigateToHome,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(9),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD2D2D2),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(9),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD2D2D2),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(9),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color(0xFF4EA6ED),
                                    ),
                                  ),
                                  hintText: "Contoh: Budi Santoso",
                                ),
                                style: TextStyle(
                                  fontSize: 15.8,
                                  fontFamily: 'Poppins',
                                ),
                                keyboardType: TextInputType.name,
                              ),
                              const SizedBox(height: 16),
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
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(9),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD2D2D2),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(9),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD2D2D2),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(9),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color(0xFF4EA6ED),
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 15.8,
                                  fontFamily: 'Poppins',
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 28),
                              if (kodeLaundryUser != null)
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('laundries')
                                      .doc(kodeLaundryUser)
                                      .collection('durasi_layanan')
                                      .orderBy('jenis')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Center(
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 34),
                                            Image.asset(
                                              "assets/icons/empty_box.png",
                                              width: 120,
                                              height: 120,
                                            ),
                                            const SizedBox(height: 17),
                                            const Text(
                                              "Belum ada data durasi layanan.\n"
                                              "Silakan tambahkan durasi layanan\n"
                                              "melalui menu Durasi Layanan.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 15.3,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    final docs = snapshot.data!.docs;
                                    return Column(
                                      children: docs.map((doc) {
                                        final data =
                                            doc.data() as Map<String, dynamic>;
                                        final String label =
                                            data['durasi'] ?? 'Durasi';
                                        final String desc =
                                            data['jenis'] ?? 'Jenis';
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 18.0,
                                          ),
                                          child: LayananTile(
                                            label: label,
                                            desc: desc,
                                            onTap: () =>
                                                _onLayananTap(label, desc),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              const SizedBox(height: 36),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
