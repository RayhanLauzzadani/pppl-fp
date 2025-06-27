import 'package:flutter/material.dart';

class DurasiLayananPage extends StatefulWidget {
  const DurasiLayananPage({super.key});

  @override
  State<DurasiLayananPage> createState() => _DurasiLayananPageState();
}

class _DurasiLayananPageState extends State<DurasiLayananPage> {
  List<Map<String, String>> durasiList = [
    {"durasi": "3 Hari", "jenis": "Reguler"},
    {"durasi": "1 Hari", "jenis": "Ekspress"},
    {"durasi": "3 Jam", "jenis": "Kilat"},
  ];

  void _showDurasiBottomSheet({int? editIdx}) {
    final namaController = TextEditingController(
        text: editIdx != null ? durasiList[editIdx]['jenis'] ?? '' : '');
    final durasiController = TextEditingController(
        text: editIdx != null ? durasiList[editIdx]['durasi'] ?? '' : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.22),
      builder: (context) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 230),
          curve: Curves.easeOut,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 40),
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
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 23),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      editIdx != null
                          ? "Edit Durasi Layanan"
                          : "Tambah Durasi Layanan",
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.5,
                      ),
                    ),
                    const SizedBox(height: 23),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text(
                            "Nama Layanan",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 15.2,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          flex: 2,
                          child: _inputBox(
                            controller: namaController,
                            hint: "Reguler",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text(
                            "Durasi",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 15.2,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          flex: 2,
                          child: _inputBox(
                            controller: durasiController,
                            hint: "Contoh: 1 Hari",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Divider(height: 1, color: Color(0x55B6C7E4)),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF40A2E3),
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontFamily: "Poppins"),
                        ),
                        onPressed: () {
                          String nama = namaController.text.trim();
                          String durasi = durasiController.text.trim();
                          if (nama.isEmpty || durasi.isEmpty) return;
                          setState(() {
                            if (editIdx != null) {
                              durasiList[editIdx] = {
                                "durasi": durasi,
                                "jenis": nama
                              };
                            } else {
                              durasiList.add({
                                "durasi": durasi,
                                "jenis": nama,
                              });
                            }
                          });
                          Navigator.pop(context);
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
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(int idx) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 19),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/icon_delete_list.png", // ganti sesuai asset kamu
                width: 98,
                height: 98,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 15),
              const Text(
                "Apakah Anda yakin menghapus layanan ini?",
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
                      onPressed: () {
                        setState(() {
                          durasiList.removeAt(idx);
                        });
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

  static Widget _inputBox(
      {required TextEditingController controller, required String hint}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
          hintText: hint,
          hintStyle: const TextStyle(
              fontFamily: "Poppins", color: Colors.grey, fontSize: 15.5),
          border: InputBorder.none,
        ),
        style: const TextStyle(
            fontFamily: "Poppins", fontSize: 15.7, color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 40, bottom: 22),
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
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Durasi Layanan",
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
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 17,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          // List durasi
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: durasiList.length,
              itemBuilder: (context, idx) {
                final item = durasiList[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF6ED),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.14),
                        blurRadius: 14,
                        offset: const Offset(0, 7),
                        spreadRadius: 0.2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Durasi
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["durasi"]!,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item["jenis"]!,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.2,
                                  color: Color(0xFF565656),
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
                            onPressed: () => _showDurasiBottomSheet(editIdx: idx),
                            icon:
                                const Icon(Icons.edit, color: Color(0xFF2B303A)),
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
                            onPressed: () => _showDeleteDialog(idx),
                            icon: const Icon(Icons.delete,
                                color: Color(0xFF2B303A)),
                            iconSize: 23,
                            tooltip: "Hapus",
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Tombol Tambah Durasi
          Padding(
            padding: const EdgeInsets.only(
                bottom: 28, top: 3, left: 32, right: 32),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => _showDurasiBottomSheet(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40A2E3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Tambah Durasi",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.2,
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
