import 'package:flutter/material.dart';

class LayananSatuanTile extends StatelessWidget {
  final String nama;
  final int harga;
  final String tipe; // <-- TAMBAH PARAMETER
  final int jumlah;
  final VoidCallback onTambah;
  final VoidCallback onKurang;

  const LayananSatuanTile({
    Key? key,
    required this.nama,
    required this.harga,
    required this.tipe, // <-- TAMBAH
    required this.jumlah,
    required this.onTambah,
    required this.onKurang,
  }) : super(key: key);

  static String _currencyFormat(int price) {
    final s = price.toString();
    return s.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
            title: Text(
              nama,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 15.3,
                color: Color(0xFF232323),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '$tipe\nRp. ${_currencyFormat(harga)}', // <-- GANTI "Satuan" DENGAN tipe
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.7,
                  color: Color(0xFF7A7A7A),
                  height: 1.3,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (jumlah > 0)
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
                if (jumlah > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      '$jumlah',
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
