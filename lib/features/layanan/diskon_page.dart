import 'package:flutter/material.dart';

// -------- MODEL DISKON --------
class DiskonModel {
  String jenisDiskon;
  String tipeDiskon;
  String jumlahDiskon;
  bool isPercent; // untuk format tampilan %

  DiskonModel({
    required this.jenisDiskon,
    required this.tipeDiskon,
    required this.jumlahDiskon,
    this.isPercent = false,
  });
}

// ----------- PAGE DISKON -----------
class DiskonPage extends StatefulWidget {
  const DiskonPage({Key? key}) : super(key: key);

  @override
  State<DiskonPage> createState() => _DiskonPageState();
}

class _DiskonPageState extends State<DiskonPage> {
  List<DiskonModel> listDiskon = [
    DiskonModel(jenisDiskon: "Hari Raya", tipeDiskon: "Persen", jumlahDiskon: "5", isPercent: true),
    DiskonModel(jenisDiskon: "Pelanggan Baru", tipeDiskon: "Nominal", jumlahDiskon: "5000"),
    DiskonModel(jenisDiskon: "Special Day 8.8", tipeDiskon: "Nominal", jumlahDiskon: "8888"),
  ];

  void _showForm({DiskonModel? diskon, required bool isEdit}) async {
    final controllerJenis = TextEditingController(text: diskon?.jenisDiskon ?? "");
    final controllerJumlah = TextEditingController(text: diskon?.jumlahDiskon ?? "");
    String tipeDiskon = diskon?.tipeDiskon ?? "Persen";

    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: DiskonFormSheet(
            isEdit: isEdit,
            jenisDiskon: controllerJenis,
            jumlahDiskon: controllerJumlah,
            tipeDiskon: tipeDiskon,
            onTipeChanged: (value) => tipeDiskon = value,
            onSubmit: () {
              setState(() {
                if (isEdit && diskon != null) {
                  diskon.jenisDiskon = controllerJenis.text;
                  diskon.jumlahDiskon = controllerJumlah.text;
                  diskon.tipeDiskon = tipeDiskon;
                  diskon.isPercent = tipeDiskon == "Persen";
                } else {
                  listDiskon.add(DiskonModel(
                    jenisDiskon: controllerJenis.text,
                    jumlahDiskon: controllerJumlah.text,
                    tipeDiskon: tipeDiskon,
                    isPercent: tipeDiskon == "Persen",
                  ));
                }
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirm(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DiskonDeleteDialog(
        onCancel: () => Navigator.pop(context),
        onDelete: () {
          setState(() {
            listDiskon.removeAt(index);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 42, left: 0, right: 0, bottom: 22),
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
                      "Diskon",
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
          const SizedBox(height: 18),
          // Daftar diskon
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: listDiskon.length,
              itemBuilder: (context, idx) {
                final item = listDiskon[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
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
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Deskripsi diskon
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.isPercent
                                    ? "${item.jumlahDiskon} %"
                                    : "Rp. ${item.jumlahDiskon}",
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Diskon ${item.jenisDiskon}",
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.2,
                                  fontStyle: FontStyle.italic,
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
                            onPressed: () => _showForm(diskon: item, isEdit: true),
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
                            onPressed: () => _showDeleteConfirm(idx),
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
            ),
          ),
          // Tombol Tambah Diskon
          Padding(
            padding: const EdgeInsets.only(bottom: 28, top: 3, left: 32, right: 32),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => _showForm(isEdit: false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40A2E3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Tambah Diskon",
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

// ----------- MODAL BOTTOM SHEET FORM DISKON -----------
class DiskonFormSheet extends StatefulWidget {
  final bool isEdit;
  final TextEditingController jenisDiskon;
  final TextEditingController jumlahDiskon;
  final String tipeDiskon;
  final ValueChanged<String> onTipeChanged;
  final VoidCallback onSubmit;

  const DiskonFormSheet({
    Key? key,
    required this.isEdit,
    required this.jenisDiskon,
    required this.jumlahDiskon,
    required this.tipeDiskon,
    required this.onTipeChanged,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<DiskonFormSheet> createState() => _DiskonFormSheetState();
}

class _DiskonFormSheetState extends State<DiskonFormSheet> {
  late String tipeDiskon;

  @override
  void initState() {
    super.initState();
    tipeDiskon = widget.tipeDiskon;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF40A2E3), Color(0xFFBBE2EC), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.45, 1.0],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isEdit ? "Edit Diskon" : "Tambah Diskon",
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  fontSize: 21,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 23),
              // Jenis Diskon
              _formLabel("Jenis Diskon"),
              TextField(
                controller: widget.jenisDiskon,
                decoration: _inputDeco(),
              ),
              const SizedBox(height: 14),
              // Tipe Diskon
              _formLabel("Tipe Diskon"),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox(),
                  value: tipeDiskon,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: ["Persen", "Nominal"].map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(fontFamily: "Poppins")),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        tipeDiskon = v;
                        widget.onTipeChanged(v);
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 14),
              // Jumlah Diskon
              _formLabel("Jumlah Diskon"),
              TextField(
                controller: widget.jumlahDiskon,
                keyboardType: TextInputType.number,
                decoration: _inputDeco(),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: widget.onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.55),
                    foregroundColor: Colors.black,
                    elevation: 3,
                    shadowColor: const Color(0xFF40A2E3).withOpacity(0.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  child: const Text("SIMPAN"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formLabel(String text) => Padding(
        padding: const EdgeInsets.only(left: 2, bottom: 3),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
            fontSize: 14.5,
            color: Colors.white,
          ),
        ),
      );

  InputDecoration _inputDeco() => InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
      );
}

// ----------- KONFIRMASI HAPUS POPUP -----------
class DiskonDeleteDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  const DiskonDeleteDialog({
    Key? key,
    required this.onCancel,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 19),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/icon_delete_list.png", // ganti dengan asset ikonmu
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
                    onPressed: onCancel,
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
                    onPressed: onDelete,
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
    );
  }
}
