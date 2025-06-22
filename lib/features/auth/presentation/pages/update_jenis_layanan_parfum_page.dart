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
      backgroundColor: const Color(0xFFFFF6E9),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(86),
        child: Stack(
          children: [
            Container(
              height: 86,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF40A2E3), Color(0xFFBBE2EC)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x29000000),
                    blurRadius: 14,
                    offset: Offset(0, 7),
                  )
                ],
              ),
            ),
            SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "Jenis Parfum",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Cari nama parfum",
                        prefixIcon: const Icon(Icons.search, color: Colors.black45),
                        hintStyle: const TextStyle(fontFamily: "Poppins", fontSize: 15),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onChanged: (v) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Material(
                  color: const Color(0xFFBBE2EC),
                  borderRadius: BorderRadius.circular(99),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(99),
                    onTap: () => _showAddParfumDialog(context),
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Icons.add, size: 32, color: Color(0xFF147C8A)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final doc = filtered[index];
                    final parfum = doc.data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                      child: ListTile(
                        leading: Container(
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
                        title: Text(
                          parfum["nama"] ?? '',
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.1,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: parfum["harga"] != null
                            ? Text(
                                "Rp. ${parfum["harga"]}",
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54,
                                ),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Material(
                              color: const Color(0xFFBBE2EC),
                              borderRadius: BorderRadius.circular(99),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(99),
                                onTap: () => _showEditParfumDialog(context, doc.id, parfum),
                                child: const SizedBox(
                                  width: 42,
                                  height: 42,
                                  child: Icon(Icons.edit, color: Color(0xFF147C8A), size: 26),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Material(
                              color: const Color(0xFFBBE2EC),
                              borderRadius: BorderRadius.circular(99),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(99),
                                onTap: () => _deleteParfum(doc.id),
                                child: const SizedBox(
                                  width: 42,
                                  height: 42,
                                  child: Icon(Icons.delete, color: Color(0xFF147C8A), size: 26),
                                ),
                              ),
                            ),
                          ],
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddParfumDialog(BuildContext context) {
    final _namaController = TextEditingController();
    final _hargaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Parfum'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama parfum'),
            ),
            TextField(
              controller: _hargaController,
              decoration: const InputDecoration(labelText: 'Harga tambahan (opsional)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nama = _namaController.text.trim();
              final hargaText = _hargaController.text.trim();
              if (nama.isNotEmpty) {
                final data = <String, dynamic>{"nama": nama};
                if (hargaText.isNotEmpty) {
                  data["harga"] = int.tryParse(hargaText) ?? 0;
                }
                await FirebaseFirestore.instance
                    .collection('laundries')
                    .doc(laundryId)
                    .collection('parfum')
                    .add(data);
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _showEditParfumDialog(BuildContext context, String docId, Map<String, dynamic> parfum) {
    final _namaController = TextEditingController(text: parfum["nama"]);
    final _hargaController = TextEditingController(text: parfum["harga"]?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Parfum'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama parfum'),
            ),
            TextField(
              controller: _hargaController,
              decoration: const InputDecoration(labelText: 'Harga tambahan (opsional)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nama = _namaController.text.trim();
              final hargaText = _hargaController.text.trim();
              if (nama.isNotEmpty) {
                final data = <String, dynamic>{"nama": nama};
                if (hargaText.isNotEmpty) {
                  data["harga"] = int.tryParse(hargaText) ?? 0;
                }
                await FirebaseFirestore.instance
                    .collection('laundries')
                    .doc(laundryId)
                    .collection('parfum')
                    .doc(docId)
                    .update(data);
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteParfum(String docId) async {
    await FirebaseFirestore.instance
        .collection('laundries')
        .doc(laundryId)
        .collection('parfum')
        .doc(docId)
        .delete();
  }
}
