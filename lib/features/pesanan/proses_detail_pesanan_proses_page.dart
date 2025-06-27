import 'package:flutter/material.dart';
import './pesanan_model.dart';
import 'components/detail_pesanan_proses_scaffold.dart';
import 'components/kendala_modal.dart';

class ProsesDetailPesananProsesPage extends StatefulWidget {
  final Pesanan pesanan;
  final VoidCallback? onHentikanProses;
  const ProsesDetailPesananProsesPage({
    super.key,
    required this.pesanan,
    this.onHentikanProses,
  });

  @override
  State<ProsesDetailPesananProsesPage> createState() => _ProsesDetailPesananProsesPageState();
}

class _ProsesDetailPesananProsesPageState extends State<ProsesDetailPesananProsesPage> {
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
        status: 'proses',
        listItem: listItem,
        onChangedKonfirmasi: (idx, val) {
          setState(() {
            listItem[idx]["konfirmasi"] = val;
          });
        },
        onLaporkanKendala: handleLaporkanKendala,
        onHentikanProses: () {
          if (widget.onHentikanProses != null) widget.onHentikanProses!();
          Navigator.pop(context);
        },
      ),
    );
  }
}
