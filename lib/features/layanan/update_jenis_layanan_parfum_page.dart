import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateJenisLayananParfumPage extends StatefulWidget {
  final String laundryId;
  const UpdateJenisLayananParfumPage({super.key, required this.laundryId});

  @override
  State<UpdateJenisLayananParfumPage> createState() => _UpdateJenisLayananParfumPageState();
}

class _UpdateJenisLayananParfumPageState extends State<UpdateJenisLayananParfumPage> {
  final TextEditingController _searchController = TextEditingController();
  String get laundryId => widget.laundryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER GRADIENT & JUDUL TENGAH
          Container(
            width: double.infinity,
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
            padding: const EdgeInsets.only(top: 42, left: 0, right: 0, bottom: 22),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Jenis Parfum",
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
          const SizedBox(height: 17),
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 0, 17, 7),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9F5ED),
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.09),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.search, color: Colors.black45, size: 22),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: "Cari nama parfum",
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      style: const TextStyle(fontFamily: "Poppins", fontSize: 15.2),
                    ),
                  ),
                  const SizedBox(width: 7),
                ],
              ),
            ),
          ),
          const SizedBox(height: 7),
          // LIST PARFUM
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('laundries')
                  .doc(laundryId)
                  .collection('parfum')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                }
                final docs = snapshot.data?.docs ?? [];
                final filtered = docs.where((doc) {
                  final nama = (doc['nama'] ?? '').toString().toLowerCase();
                  return nama.contains(_searchController.text.toLowerCase());
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("Belum ada parfum"));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  itemBuilder: (context, idx) {
                    final doc = filtered[idx];
                    final parfum = doc.data() as Map<String, dynamic>;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 17),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF6ED),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.14),
                            blurRadius: 13,
                            offset: const Offset(0, 8),
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icon
                            Container(
                              width: 45,
                              height: 45,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDAF0F7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                "assets/icons/perfume.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Nama dan harga
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    parfum["nama"] ?? '',
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.4,
                                    ),
                                  ),
                                  Text(
                                    parfum["harga"] != null ? "Rp. ${parfum["harga"]}" : "Rp. 0",
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13.5,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Tombol Edit
                            Container(
                              margin: const EdgeInsets.only(left: 8, right: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFFBBE2EC),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: IconButton(
                                onPressed: () => _showParfumModal(context, docId: doc.id, parfum: parfum),
                                icon: const Icon(Icons.edit, color: Color(0xFF2B303A)),
                                iconSize: 23,
                                tooltip: "Edit",
                              ),
                            ),
                            // Tombol Hapus
                            Container(
                              margin: const EdgeInsets.only(left: 0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFBBE2EC),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: IconButton(
                                onPressed: () => _showDeleteParfumDialog(context, doc.id),
                                icon: const Icon(Icons.delete, color: Color(0xFF2B303A)),
                                iconSize: 23,
                                tooltip: "Hapus",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // TOMBOL TAMBAH PARFUM
          Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 3, left: 30, right: 30),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => _showParfumModal(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40A2E3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Tambah Parfum",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MODAL TAMBAH / EDIT
  void _showParfumModal(BuildContext context, {String? docId, Map<String, dynamic>? parfum}) {
    final _namaController = TextEditingController(text: parfum?["nama"] ?? '');
    final _hargaController = TextEditingController(text: parfum?["harga"]?.toString() ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF40A2E3), Color(0xFFBBE2EC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(22, 32, 22, 22),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    docId != null ? "Edit Parfum" : "Tambah Parfum",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Nama parfum
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Nama Parfum",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15.5,
                        color: Colors.white.withOpacity(0.93),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _namaController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Nama parfum",
                      hintStyle: const TextStyle(fontFamily: "Poppins", color: Colors.grey, fontSize: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    ),
                    style: const TextStyle(fontFamily: "Poppins", fontSize: 15),
                  ),
                  const SizedBox(height: 14),
                  // Harga parfum
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Harga Tambahan (opsional)",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15.5,
                        color: Colors.white.withOpacity(0.93),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "cth: 2000",
                      hintStyle: const TextStyle(fontFamily: "Poppins", color: Colors.grey, fontSize: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    ),
                    style: const TextStyle(fontFamily: "Poppins", fontSize: 15),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF40A2E3),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: Colors.black12,
                        textStyle: const TextStyle(fontFamily: "Poppins"),
                      ),
                      onPressed: () async {
                        final nama = _namaController.text.trim();
                        final hargaText = _hargaController.text.trim();
                        if (nama.isNotEmpty) {
                          final data = <String, dynamic>{"nama": nama};
                          if (hargaText.isNotEmpty) {
                            data["harga"] = int.tryParse(hargaText) ?? 0;
                          }
                          if (docId != null) {
                            await FirebaseFirestore.instance
                                .collection('laundries')
                                .doc(laundryId)
                                .collection('parfum')
                                .doc(docId)
                                .update(data);
                          } else {
                            await FirebaseFirestore.instance
                                .collection('laundries')
                                .doc(laundryId)
                                .collection('parfum')
                                .add(data);
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        docId != null ? "SIMPAN" : "TAMBAH",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.7,
                          letterSpacing: 1.1,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // DIALOG HAPUS PARFUM
  void _showDeleteParfumDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 19),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/icon_delete_list.png", // Ganti sesuai aset iconmu
                width: 98,
                height: 98,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 15),
              const Text(
                "Apakah Anda yakin menghapus parfum ini?",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 15.5,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 19),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: Color(0xFF40A2E3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      child: const Text("Batal"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('laundries')
                            .doc(laundryId)
                            .collection('parfum')
                            .doc(docId)
                            .delete();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF40A2E3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      child: const Text("Hapus"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
