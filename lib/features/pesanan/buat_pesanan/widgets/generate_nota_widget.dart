import 'package:flutter/material.dart';

class GenerateNotaWidget extends StatelessWidget {
  final String? kodeLaundry;
  final String? customPrefix;

  const GenerateNotaWidget({Key? key, this.kodeLaundry, this.customPrefix}) : super(key: key);

  String generateNota() {
    final millis = DateTime.now().millisecondsSinceEpoch;
    String prefix = customPrefix ?? 'NOTA';
    if (kodeLaundry != null) prefix = '$prefix-${kodeLaundry!}';
    return '$prefix-$millis';
  }

  @override
  Widget build(BuildContext context) {
    final nota = generateNota();
    return Row(
      children: [
        const Icon(Icons.receipt_long, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 7),
        Text(
          nota,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 15.5,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
