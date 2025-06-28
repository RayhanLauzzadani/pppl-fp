import 'package:flutter/material.dart';

class BarangCustomTile extends StatelessWidget {
  final String title;
  final int qty;
  final VoidCallback onTambah;
  final VoidCallback onKurang;

  const BarangCustomTile({
    Key? key,
    required this.title,
    required this.qty,
    required this.onTambah,
    required this.onKurang,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 15.3,
                color: Color(0xFF232323),
              ),
            ),
            subtitle: const Text(
              'Satuan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.7,
                color: Color(0xFF7A7A7A),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (qty > 0)
                  InkWell(
                    onTap: onKurang,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 39,
                      height: 39,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4F1FB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: Color(0xFF1D90C6),
                        size: 26,
                      ),
                    ),
                  ),
                if (qty > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      '$qty',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF232323),
                      ),
                    ),
                  ),
                InkWell(
                  onTap: onTambah,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 39,
                    height: 39,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4F1FB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color(0xFF1D90C6),
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEFEFEF)),
      ],
    );
  }
}
