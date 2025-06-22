import 'package:flutter/material.dart';

class CuciKiloanCard extends StatelessWidget {
  final double kiloan;
  final ValueChanged<String> onKiloanChanged;
  final int jumlahBaju;
  final ValueChanged<int> onJumlahBajuChanged;
  final int jumlahCelana;
  final ValueChanged<int> onJumlahCelanaChanged;
  final int jumlahLuaran;
  final ValueChanged<int> onJumlahLuaranChanged;
  final int hargaPerKg;

  const CuciKiloanCard({
    Key? key,
    required this.kiloan,
    required this.onKiloanChanged,
    required this.jumlahBaju,
    required this.onJumlahBajuChanged,
    required this.jumlahCelana,
    required this.onJumlahCelanaChanged,
    required this.jumlahLuaran,
    required this.onJumlahLuaranChanged,
    this.hargaPerKg = 10000,
  }) : super(key: key);

  Widget _itemCountInput(
    String label,
    int value,
    ValueChanged<int> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 14))),
          InkWell(
            onTap: value > 0 ? () => onChanged(value - 1) : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: value > 0 ? const Color(0xFFCDE7F2) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.remove, color: value > 0 ? const Color(0xFF2A5A6A) : Colors.grey, size: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          InkWell(
            onTap: () => onChanged(value + 1),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFCDE7F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, color: Color(0xFF2A5A6A), size: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3FF),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_emotions, color: Color(0xFF40A2E3), size: 26),
              const SizedBox(width: 10),
              const Text(
                "Cuci Kiloan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Poppins'),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Berat (kg)", style: TextStyle(fontSize: 14, fontFamily: 'Poppins')),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 38,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "0",
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 17),
                        controller: TextEditingController(text: kiloan > 0 ? kiloan.toString() : ''),
                        onChanged: onKiloanChanged,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "x Rp. $hargaPerKg",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        fontFamily: 'Poppins',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          _itemCountInput("Atasan", jumlahBaju, onJumlahBajuChanged),
          _itemCountInput("Bawahan", jumlahCelana, onJumlahCelanaChanged),
          _itemCountInput("Pakaian Lainnya", jumlahLuaran, onJumlahLuaranChanged),
        ],
      ),
    );
  }
}
