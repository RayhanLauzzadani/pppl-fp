import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AntarJemputPage extends StatefulWidget {
  final String laundryId;
  final bool isOwner; // <-- Tambah param ini

  const AntarJemputPage({
    super.key,
    required this.laundryId,
    required this.isOwner,
  });

  @override
  State<AntarJemputPage> createState() => _AntarJemputPageState();
}

class _AntarJemputPageState extends State<AntarJemputPage> {
  CollectionReference<Map<String, dynamic>> get _colRef => FirebaseFirestore
      .instance
      .collection('laundries')
      .doc(widget.laundryId)
      .collection('antar_jemput');

  // ---------- MODAL TAMBAH/EDIT ----------
  void _showEditSheet({DocumentSnapshot? doc}) {
    if (!widget.isOwner) return; // Karyawan tidak boleh buka modal

    bool isEdit = doc != null;
    final TextEditingController hargaController = TextEditingController(
      text: isEdit ? doc['harga'].toString() : "",
    );
    final TextEditingController jarakController = TextEditingController(
      text: isEdit ? doc['jarak'] : "",
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF40A2E3), Color(0xFFBBE2EC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(22, 30, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit
                      ? "Edit Layanan\nAntar Jemput"
                      : "Tambah Layanan\nAntar Jemput",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                    height: 1.13,
                  ),
                ),
                const SizedBox(height: 22),
                _inputLabel("Jarak"),
                TextField(
                  controller: jarakController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontFamily: "Poppins"),
                  decoration: _inputDecoration(hint: "cth: ≤ 2 Km / > 10 Km"),
                ),
                const SizedBox(height: 13),
                _inputLabel("Harga (Rp.)"),
                TextField(
                  controller: hargaController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontFamily: "Poppins"),
                  decoration: _inputDecoration(hint: "cth: 5000"),
                ),
                const SizedBox(height: 22),
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
                      final jarak = jarakController.text.trim();
                      final harga = hargaController.text.trim();
                      if (harga.isEmpty || jarak.isEmpty) return;

                      if (isEdit) {
                        await _colRef.doc(doc.id).update({
                          'harga': harga,
                          'jarak': jarak,
                          'updatedAt': FieldValue.serverTimestamp(),
                        });
                      } else {
                        await _colRef.add({
                          'harga': harga,
                          'jarak': jarak,
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                      }
                      if (mounted) Navigator.pop(context);
                    },
                    child: const Text(
                      "SIMPAN",
                      style: TextStyle(
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
        );
      },
    );
  }

  void _showDeleteDialog(DocumentSnapshot doc) {
    if (!widget.isOwner) return; // Karyawan tidak boleh hapus

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/icon_delete_list.png',
                height: 80,
                width: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const Text(
                "Apakah Anda yakin menghapus layanan ini?",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 15.7,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF40A2E3),
                        textStyle: const TextStyle(fontFamily: "Poppins"),
                        side: const BorderSide(
                          color: Color(0xFF40A2E3),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Batal"),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF40A2E3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        textStyle: const TextStyle(fontFamily: "Poppins"),
                      ),
                      onPressed: () async {
                        await doc.reference.delete();
                        if (mounted) Navigator.pop(context);
                      },
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

  static Widget _inputLabel(String text) => Padding(
    padding: const EdgeInsets.only(left: 2, bottom: 2),
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: "Poppins",
        fontSize: 14.2,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFFFFAF0),
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: "Poppins",
        color: Colors.grey,
        fontSize: 13.7,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF40A2E3), Color(0xFFBBE2EC)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 42,
              left: 0,
              right: 0,
              bottom: 22,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Layanan Antar Jemput",
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
          // LIST LAYANAN ANTAR JEMPUT (Firestore)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _colRef.orderBy('jarak').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/empty_box.png",
                            width: 120,
                            height: 120,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Belum ada layanan antar jemput.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16.7,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Tambah daftar layanan & tarif antar jemput,\nagar pelangganmu makin mudah order dari mana saja.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14.2,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 7,
                  ),
                  itemBuilder: (context, idx) {
                    final item = docs[idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 17),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6ED),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withAlpha((0.93 * 255).toInt()),
                            blurRadius: 13,
                            offset: const Offset(0, 8),
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 15,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Harga & Jarak
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rp. ${item['harga']}",
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    item["jarak"],
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.2,
                                      color: Color(0xFF565656),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Tombol Edit dan Hapus (hanya owner)
                            if (widget.isOwner) ...[
                              Container(
                                margin: const EdgeInsets.only(left: 8, right: 7),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFBBE2EC),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: IconButton(
                                  onPressed: () => _showEditSheet(doc: item),
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color(0xFF2B303A),
                                  ),
                                  iconSize: 23,
                                  tooltip: "Edit",
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFBBE2EC),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: IconButton(
                                  onPressed: () => _showDeleteDialog(item),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color(0xFF2B303A),
                                  ),
                                  iconSize: 23,
                                  tooltip: "Hapus",
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Tombol Tambah Antar Jemput (hanya owner)
          if (widget.isOwner)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 30,
                top: 3,
                left: 30,
                right: 30,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => _showEditSheet(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40A2E3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Tambah Layanan",
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
}
