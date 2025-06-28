import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JenisLayananPage extends StatefulWidget {
  final String laundryId;

  const JenisLayananPage({
    super.key,
    required this.laundryId,
  });

  @override
  State<JenisLayananPage> createState() => _JenisLayananPageState();
}

class _JenisLayananPageState extends State<JenisLayananPage> {
  String filterJenis = "";
  String search = "";

  // Untuk show/hide modal
  void showDurasiModal(List<Map<String, dynamic>> jenisDurasi) async {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          padding: const EdgeInsets.all(26),
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset("assets/icons/clock.png", width: 29),
                  const SizedBox(width: 9),
                  const Text(
                    "Durasi layanan",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              ...jenisDurasi.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: InkWell(
                  borderRadius: BorderRadius.circular(11),
                  onTap: () {
                    setState(() {
                      filterJenis = item["jenis"];
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFBBE2EC),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.chevron_right, color: Colors.white, size: 26),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["durasi"] ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              item["jenis"] ?? "-",
                              style: const TextStyle(
                                fontSize: 13.1,
                                color: Colors.black87,
                                fontFamily: "Poppins",
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  // Input field helper
  Widget _inputField(String label, TextEditingController c, {bool isNumber = false}) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 8,
          child: TextField(
            controller: c,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9F5ED),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(fontFamily: "Poppins", fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _dropdownTipe(String value, Function(String?) onChanged) {
    return Row(
      children: [
        const Expanded(
          flex: 5,
          child: Text(
            "Tipe Layanan",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 8,
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9F5ED),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(fontFamily: "Poppins", fontSize: 15),
            items: const [
              DropdownMenuItem(value: "Satuan", child: Text("Satuan")),
              DropdownMenuItem(value: "Kiloan", child: Text("Kiloan")),
            ],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // Tambah/Edit Layanan Modal
  void showTambahEditLayanan({
    Map<String, dynamic>? layanan,
    bool isEdit = false,
  }) {
    final TextEditingController namaController =
        TextEditingController(text: layanan?["nama"] ?? "");
    String tipeValue = layanan?["tipe"] ?? "Satuan";
    final TextEditingController hargaController =
        TextEditingController(text: layanan?["harga"]?.toString() ?? "");

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF40A2E3), Color(0xFFBBE2EC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEdit ? "Edit Layanan" : "Tambah Layanan",
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 18),
              _inputField("Nama Layanan", namaController),
              const SizedBox(height: 10),
              _dropdownTipe(tipeValue, (val) => setState(() => tipeValue = val!)),
              const SizedBox(height: 10),
              _inputField("Harga (Rp.)", hargaController, isNumber: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    String nama = namaController.text.trim();
                    String tipe = tipeValue;
                    int harga = int.tryParse(hargaController.text) ?? 0;

                    if (nama.isEmpty || harga == 0) return;

                    final ref = FirebaseFirestore.instance
                        .collection('laundries')
                        .doc(widget.laundryId)
                        .collection('jenis_layanan');

                    if (isEdit && layanan?['id'] != null) {
                      await ref.doc(layanan!['id']).update({
                        "nama": nama,
                        "tipe": tipe,
                        "harga": harga,
                        "jenis": filterJenis,
                        "updatedAt": FieldValue.serverTimestamp(),
                      });
                    } else {
                      await ref.add({
                        "nama": nama,
                        "tipe": tipe,
                        "harga": harga,
                        "jenis": filterJenis, // sesuai filter saat tambah
                        "createdAt": FieldValue.serverTimestamp(),
                      });
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
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
      ),
    );
  }

  // Konfirmasi hapus
  void showHapusDialog(Map<String, dynamic> layanan) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/icon_delete_list.png",
              width: 90,
              height: 90,
            ),
            const SizedBox(height: 18),
            const Text(
              "Apakah Anda yakin menghapus layanan ini?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                fontSize: 15.7,
              ),
            ),
            const SizedBox(height: 19),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF147C8A),
                    side: const BorderSide(color: Color(0xFF147C8A)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40A2E3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final ref = FirebaseFirestore.instance
                        .collection('laundries')
                        .doc(widget.laundryId)
                        .collection('jenis_layanan');
                    await ref.doc(layanan['id']).delete();
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text("Hapus"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen ke koleksi durasi_layanan untuk filter
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('laundries')
            .doc(widget.laundryId)
            .collection('durasi_layanan')
            .snapshots(),
        builder: (context, durasiSnap) {
          List<Map<String, dynamic>> jenisDurasi = [];
          if (durasiSnap.hasData) {
            for (var doc in durasiSnap.data!.docs) {
              jenisDurasi.add({
                "jenis": doc['jenis'],
                "durasi": doc['durasi'],
              });
            }
            // Set default filter jenis pertama kali
            if (filterJenis.isEmpty && jenisDurasi.isNotEmpty) {
              filterJenis = jenisDurasi.first['jenis'];
            }
          }

          return Column(
            children: [
              // HEADER
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
                padding: const EdgeInsets.only(top: 42, left: 0, right: 0, bottom: 18),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Jenis Layanan",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              // FILTER + SEARCH + PLUS
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 14, 17, 5),
                child: Row(
                  children: [
                    // Dropdown Durasi (pake modal Firestore)
                    OutlinedButton(
                      onPressed: () => showDurasiModal(jenisDurasi),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey[400]!),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      ),
                      child: Text(" $filterJenis ", style: const TextStyle(fontFamily: "Poppins", fontStyle: FontStyle.italic)),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
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
                                onChanged: (v) => setState(() => search = v),
                                decoration: const InputDecoration(
                                  hintText: "Cari nama layanan",
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
                    const SizedBox(width: 13),
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => showTambahEditLayanan(isEdit: false),
                      child: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: const Color(0xFF40A2E3),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.13),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 27),
                      ),
                    ),
                  ],
                ),
              ),
              // LIST JENIS LAYANAN
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: filterJenis.isEmpty
                      ? null // Jika belum ada filter, list kosong
                      : FirebaseFirestore.instance
                          .collection('laundries')
                          .doc(widget.laundryId)
                          .collection('jenis_layanan')
                          .where('jenis', isEqualTo: filterJenis)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      // Data kosong
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(38.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/empty_box.png", // Ganti sesuai aset kosong kamu
                                width: 120,
                                height: 120,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Belum ada layanan untuk kategori ini.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16.7,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Tambah jenis layanan (satuan atau kiloan)\nuntuk setiap durasi agar pelanggan bisa memilih sesuai kebutuhan.",
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
                    List<Map<String, dynamic>> layananFiltered = docs
                        .map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          data['id'] = doc.id;
                          return data;
                        })
                        .where((l) => search.isEmpty || l["nama"].toLowerCase().contains(search.toLowerCase()))
                        .toList();

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      separatorBuilder: (_, __) => const Divider(height: 12, thickness: 0.7),
                      itemCount: layananFiltered.length,
                      itemBuilder: (context, idx) {
                        final item = layananFiltered[idx];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Nama layanan
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["nama"],
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.4,
                                      ),
                                    ),
                                    Text(
                                      item["tipe"],
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontStyle: FontStyle.italic,
                                        fontSize: 13.5,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      "Rp. ${item["harga"].toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.")}",
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 13.1,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Edit button
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFBBE2EC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () => showTambahEditLayanan(
                                  layanan: item,
                                  isEdit: true,
                                ),
                                icon: const Icon(Icons.edit, color: Color(0xFF2B303A)),
                                iconSize: 22,
                                tooltip: "Edit",
                              ),
                            ),
                            // Delete button
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFBBE2EC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () => showHapusDialog(item),
                                icon: const Icon(Icons.delete, color: Color(0xFF2B303A)),
                                iconSize: 22,
                                tooltip: "Hapus",
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
