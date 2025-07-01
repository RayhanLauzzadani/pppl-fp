import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BottomSheetKonfirmasi extends StatefulWidget {
  final String kodeLaundry;
  final Function(Map<String, dynamic>) onSubmit;

  const BottomSheetKonfirmasi({
    Key? key,
    required this.kodeLaundry,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<BottomSheetKonfirmasi> createState() => _BottomSheetKonfirmasiState();
}

class _BottomSheetKonfirmasiState extends State<BottomSheetKonfirmasi> {
  String? _jenisParfum;
  String? _antarJemput;
  String? _diskon;
  String _catatan = "";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fontTitle = width * 0.065;
    final fontLabel = width * 0.043;
    final fontInput = width * 0.040;
    final fieldHeight = width * 0.13; // height field, konsisten

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            stops: [0.02, 0.38, 0.85],
            colors: [
              Color(0xFFFFF6E9),
              Color(0xFFBBE2EC),
              Color(0xFF40A2E3),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: width * 0.045, vertical: width * 0.03),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Padding(
                padding: EdgeInsets.only(top: width * 0.03, bottom: width * 0.01),
                child: Text(
                  'Buat Pesanan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: fontTitle,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: width * 0.03),

              // Semua Field dalam bentuk Column agar sama lebar!
              _FieldDropdown(
                label: "Jenis Parfum",
                value: _jenisParfum,
                itemsStream: FirebaseFirestore.instance
                    .collection('laundries')
                    .doc(widget.kodeLaundry)
                    .collection('parfum')
                    .snapshots(),
                getItem: (doc) => (doc.data() as Map<String, dynamic>)['nama']?.toString() ?? '',
                onChanged: (v) => setState(() => _jenisParfum = v),
                fieldHeight: fieldHeight,
                fontLabel: fontLabel,
                fontInput: fontInput,
              ),
              SizedBox(height: width * 0.02),

              _FieldDropdown(
                label: "Layanan Antar Jemput",
                value: _antarJemput,
                itemsStream: FirebaseFirestore.instance
                    .collection('laundries')
                    .doc(widget.kodeLaundry)
                    .collection('antar_jemput')
                    .snapshots(),
                getItem: (doc) => (doc.data() as Map<String, dynamic>)['jarak']?.toString() ?? '',
                onChanged: (v) => setState(() => _antarJemput = v),
                fieldHeight: fieldHeight,
                fontLabel: fontLabel,
                fontInput: fontInput,
              ),
              SizedBox(height: width * 0.02),

              _FieldDropdown(
                label: "Diskon",
                value: _diskon,
                itemsStream: FirebaseFirestore.instance
                    .collection('laundries')
                    .doc(widget.kodeLaundry)
                    .collection('diskon')
                    .snapshots(),
                getItem: (doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final jenis = data['jenisDiskon']?.toString() ?? '';
                  final jumlah = data['jumlahDiskon']?.toString() ?? '';
                  final tipe = (data['tipeDiskon']?.toString() ?? 'Persen').toLowerCase();
                  if (jenis.isEmpty || jumlah.isEmpty) return '';
                  return tipe == "persen" ? "$jenis ($jumlah%)" : "$jenis (Rp. $jumlah)";
                },
                onChanged: (v) => setState(() => _diskon = v),
                fieldHeight: fieldHeight,
                fontLabel: fontLabel,
                fontInput: fontInput,
              ),
              SizedBox(height: width * 0.02),

              // Catatan
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Catatan",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fontLabel,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: width * 0.01),
                  Container(
                    height: fieldHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6E9),
                      borderRadius: BorderRadius.circular(fieldHeight * 0.45),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: fieldHeight * 0.3),
                    child: Row(
                      children: [
                        Icon(Icons.event_note, size: fontLabel + 7, color: Colors.black54),
                        SizedBox(width: 7),
                        Expanded(
                          child: TextField(
                            minLines: 1,
                            maxLines: 2,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic,
                              fontSize: fontInput,
                            ),
                            decoration: InputDecoration(
                              hintText: "Catatan tambahan",
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.italic,
                                fontSize: fontInput,
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            onChanged: (val) => setState(() => _catatan = val),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: width * 0.03),

              // Separator
              Container(
                height: 1.3,
                margin: EdgeInsets.only(bottom: width * 0.025, top: width * 0.01),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              // Tombol
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSubmit({
                      "jenisParfum": _jenisParfum,
                      "antarJemput": _antarJemput,
                      "diskon": _diskon,
                      "catatan": _catatan,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: const Color(0xFFB4E4F6),
                    shadowColor: Colors.black.withOpacity(0.12),
                    padding: EdgeInsets.symmetric(vertical: width * 0.032),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Buat Pesanan",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: width * 0.049,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: width * 0.01),
              Container(
                width: width * 0.20,
                height: width * 0.016,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              SizedBox(height: width * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final Stream<QuerySnapshot> itemsStream;
  final String Function(QueryDocumentSnapshot) getItem;
  final ValueChanged<String?> onChanged;
  final double fieldHeight;
  final double fontLabel;
  final double fontInput;

  const _FieldDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.itemsStream,
    required this.getItem,
    required this.onChanged,
    required this.fieldHeight,
    required this.fontLabel,
    required this.fontInput,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: itemsStream,
      builder: (context, snapshot) {
        List<String> items = [];
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          items = snapshot.data!.docs
              .map(getItem)
              .where((v) => v.isNotEmpty)
              .toList();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: fontLabel,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 6),
            Container(
              height: fieldHeight,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6E9),
                borderRadius: BorderRadius.circular(fieldHeight * 0.45),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: fieldHeight * 0.3),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: fontInput + 10,
                    color: Colors.black54,
                  ),
                  dropdownColor: const Color(0xFFFFF6E9),
                  borderRadius: BorderRadius.circular(fieldHeight * 0.4),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: fontInput,
                    color: Colors.black,
                  ),
                  hint: items.isEmpty
                      ? Text(
                          'Tidak ada data',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                            fontSize: fontInput * 0.95,
                          ),
                        )
                      : const SizedBox.shrink(),
                  items: items
                      .map(
                        (v) => DropdownMenuItem(
                          value: v,
                          child: Text(
                            v,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: fontInput,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: items.isEmpty ? null : onChanged,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
