import 'package:flutter/material.dart';

class JenisLayananPage extends StatefulWidget {
  const JenisLayananPage({super.key});

  @override
  State<JenisLayananPage> createState() => _JenisLayananPageState();
}

class _JenisLayananPageState extends State<JenisLayananPage> {
  // Dummy data layanan
  final List<Map<String, dynamic>> allLayanan = [
    {"nama": "Bed Cover Double", "tipe": "Satuan", "harga": 25000, "jenis": "Ekspress"},
    {"nama": "Bed Cover Jumbo", "tipe": "Satuan", "harga": 35000, "jenis": "Ekspress"},
    {"nama": "Bed Cover Single", "tipe": "Satuan", "harga": 20000, "jenis": "Ekspress"},
    {"nama": "Cuci Lipat", "tipe": "Kiloan", "harga": 6000, "jenis": "Ekspress"},
    {"nama": "Cuci Setrika", "tipe": "Kiloan", "harga": 8000, "jenis": "Ekspress"},
    {"nama": "Selimut Double", "tipe": "Satuan", "harga": 12000, "jenis": "Ekspress"},
    {"nama": "Selimut Single", "tipe": "Satuan", "harga": 7000, "jenis": "Ekspress"},
  ];

  String filterJenis = "Ekspress";
  String search = "";

  // Dummy durasi layanan
  final List<Map<String, String>> durasiLayanan = [
    {"durasi": "3 Hari", "jenis": "Reguler"},
    {"durasi": "1 Hari", "jenis": "Ekspress"},
    {"durasi": "3 Jam", "jenis": "Kilat"},
  ];

  // Modal untuk tambah/edit layanan
  void showTambahEditLayanan({Map<String, dynamic>? layanan, bool isEdit = false}) {
    final TextEditingController namaController = TextEditingController(text: layanan?["nama"] ?? "");
    String tipeValue = layanan?["tipe"] ?? "Satuan";
    final TextEditingController hargaController = TextEditingController(text: layanan?["harga"]?.toString() ?? "");

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
                  onPressed: () {
                    // Simpan / Edit (implementasi backend/logic)
                    Navigator.pop(context);
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

  // Modal konfirmasi hapus
  void showHapusDialog() {
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
              width: 90, height: 90,
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
                  onPressed: () {
                    // Hapus logic
                    Navigator.pop(context);
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

  // Modal pilih durasi
  void showDurasiModal() {
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
              ...durasiLayanan.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: InkWell(
                  borderRadius: BorderRadius.circular(11),
                  onTap: () {
                    setState(() {
                      filterJenis = item["jenis"]!;
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
                              item["durasi"]!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              item["jenis"]!,
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

  // Widget helper
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

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> layananFiltered = allLayanan
        .where((l) =>
            l["jenis"] == filterJenis &&
            (search.isEmpty ||
                l["nama"].toLowerCase().contains(search.toLowerCase())))
        .toList();

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
                // Dropdown Durasi (pake modal)
                OutlinedButton(
                  onPressed: showDurasiModal,
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
          // LIST
          Expanded(
            child: ListView.separated(
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
                          layanan: item, isEdit: true
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
                        onPressed: showHapusDialog,
                        icon: const Icon(Icons.delete, color: Color(0xFF2B303A)),
                        iconSize: 22,
                        tooltip: "Hapus",
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
