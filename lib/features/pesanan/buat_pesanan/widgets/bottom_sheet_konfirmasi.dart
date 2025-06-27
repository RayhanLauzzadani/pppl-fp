import 'package:flutter/material.dart';

class BottomSheetKonfirmasi extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit; // <--- ubah ini
  const BottomSheetKonfirmasi({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<BottomSheetKonfirmasi> createState() => _BottomSheetKonfirmasiState();
}

class _BottomSheetKonfirmasiState extends State<BottomSheetKonfirmasi> {
  String? _jenisParfum;
  String? _antarJemput;
  String? _diskon;
  String _catatan = "";

  final _parfumList = ["Junung Buih", "Downy", "Molto", "Tanpa Parfum"];
  final _antarJemputList = ["≤ 2 Km", "≤ 5 Km", "≥ 5 Km"];
  final _diskonList = ["5%", "10%", "15%"];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(38),
        topRight: Radius.circular(38),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            stops: [0.02, 0.38, 0.85],
            colors: [
              Color(0xFFFFF6E9), // 2%
              Color(0xFFBBE2EC), // 38%
              Color(0xFF40A2E3), // 85%
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Judul
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Text(
                'Buat Pesanan',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 29,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Jenis Parfum
            _DropRow(
              label: "Jenis Parfum",
              value: _jenisParfum,
              items: _parfumList,
              onChanged: (v) => setState(() => _jenisParfum = v),
            ),
            const SizedBox(height: 17),

            // Antar Jemput
            _DropRow(
              label: "Layanan\nAntar Jemput",
              value: _antarJemput,
              items: _antarJemputList,
              onChanged: (v) => setState(() => _antarJemput = v),
            ),
            const SizedBox(height: 17),

            // Diskon
            _DropRow(
              label: "Diskon",
              value: _diskon,
              items: _diskonList,
              onChanged: (v) => setState(() => _diskon = v),
            ),
            const SizedBox(height: 24),

            // Catatan
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, right: 6),
                  child: Icon(Icons.event_note, size: 33, color: Colors.black),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6E9),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.09),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: TextField(
                      minLines: 1,
                      maxLines: 3,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Catatan tambahan",
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (val) => setState(() => _catatan = val),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Garis separator
            Container(
              height: 2,
              margin: const EdgeInsets.only(bottom: 19),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            // Tombol Buat Pesanan
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
                  elevation: 8,
                  backgroundColor: const Color(0xFFB4E4F6),
                  shadowColor: Colors.black.withOpacity(0.15),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Text(
                  "Buat Pesanan",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Garis bawah bulatan
            const SizedBox(height: 14),
            Container(
              width: 76,
              height: 7,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _DropRow extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropRow({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labelWidget = label.contains('\n')
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: label
                .split('\n')
                .map(
                  (e) => Text(
                    e,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                )
                .toList(),
          )
        : Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 147, child: labelWidget),
        Expanded(
          child: Container(
            height: 53,
            margin: const EdgeInsets.only(left: 8, right: 0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6E9),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 31,
                  color: Colors.black54,
                ),
                dropdownColor: const Color(0xFFFFF6E9),
                borderRadius: BorderRadius.circular(18),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  color: Colors.black,
                ),
                hint: const SizedBox.shrink(),
                items: items
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(
                          v,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
