import 'package:flutter/material.dart';
import './pesanan_model.dart';
import 'components/detail_pesanan_scaffold.dart';
import 'components/kendala_modal.dart';

class ProsesDetailPesananSelesaiPage extends StatefulWidget {
  final Pesanan pesanan;
  const ProsesDetailPesananSelesaiPage({super.key, required this.pesanan});

  @override
  State<ProsesDetailPesananSelesaiPage> createState() => _ProsesDetailPesananSelesaiPageState();
}

class _ProsesDetailPesananSelesaiPageState extends State<ProsesDetailPesananSelesaiPage> {
  List<Map<String, dynamic>> listItem = [
    {"nama": "Baju", "jumlah": 11, "konfirmasi": false},
    {"nama": "Bed Cover Jumbo", "jumlah": 1, "konfirmasi": false},
    {"nama": "Boneka Kecil", "jumlah": 3, "konfirmasi": false},
    {"nama": "Celana", "jumlah": 2, "konfirmasi": false},
    {"nama": "Kemeja", "jumlah": 7, "konfirmasi": false},
    {"nama": "Selimut Single", "jumlah": 2, "konfirmasi": false},
    {"nama": "Sprei Single", "jumlah": 2, "konfirmasi": false},
  ];

  void handleLaporkanKendala() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => KendalaModal(noHp: widget.pesanan.noHp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DetailPesananScaffold(
        pesanan: widget.pesanan,
        status: 'selesai',
        listItem: listItem,
        onLaporkanKendala: handleLaporkanKendala,
        // Tidak ada action onSelesaikanProses
      ),
    );
  }
}
