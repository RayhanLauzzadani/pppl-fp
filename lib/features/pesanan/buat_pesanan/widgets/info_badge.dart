import 'package:flutter/material.dart';

class InfoBadge extends StatelessWidget {
  final String value;
  final String label;
  const InfoBadge(this.value, this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1.2),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 14.1,
              color: Color(0xFF232323),
            ),
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }
}
