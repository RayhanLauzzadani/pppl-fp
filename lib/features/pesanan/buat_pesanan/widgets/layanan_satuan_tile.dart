import 'package:flutter/material.dart';

class LayananSatuanTile extends StatelessWidget {
  final String nama;
  final int harga;
  final int jumlah;
  final VoidCallback onTambah;
  final VoidCallback onKurang;

  const LayananSatuanTile({
    super.key,
    required this.nama,
    required this.harga,
    required this.jumlah,
    required this.onTambah,
    required this.onKurang,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        nama,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Satuan",
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontStyle: FontStyle.italic,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            "Rp. $harga",
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      trailing: (jumlah == 0)
          ? InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTambah,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFCDE7F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.add,
                  color: Color(0xFF2A5A6A),
                  size: 24,
                ),
              ),
            )
          : SizedBox(
              width: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: onKurang,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCDE7F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: Color(0xFF2A5A6A),
                        size: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '$jumlah',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: onTambah,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCDE7F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Color(0xFF2A5A6A),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
