import 'package:flutter/material.dart';
import './pesanan_model.dart';
import 'components/detail_pesanan_proses_scaffold.dart';
import 'components/kendala_modal.dart';

class ProsesDetailPesananSelesaiPage extends StatefulWidget {
  final Pesanan pesanan;
  final VoidCallback? onSelesaikanPesanan;
  const ProsesDetailPesananSelesaiPage({
    super.key,
    required this.pesanan,
    this.onSelesaikanPesanan,
  });

  @override
  State<ProsesDetailPesananSelesaiPage> createState() => _ProsesDetailPesananSelesaiPageState();
}

class _ProsesDetailPesananSelesaiPageState extends State<ProsesDetailPesananSelesaiPage> {
  late List<Map<String, dynamic>> listItem;

  @override
  void initState() {
    super.initState();
    // Mapping barangQty ke listItem
    listItem = [];
    widget.pesanan.barangQty.forEach((key, value) {
      listItem.add({
        "nama": key,
        "jumlah": value,
        "konfirmasi": false,
      });
    });
    // Jika kosong, dummy fallback (bisa dihapus jika pasti ada)
    if (listItem.isEmpty) {
      listItem = [
        {"nama": "Baju", "jumlah": 1, "konfirmasi": false},
      ];
    }
  }

  void handleLaporkanKendala() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => KendalaModal(noHp: widget.pesanan.whatsapp),
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
        onSelesaikanProses: () {
          if (widget.onSelesaikanPesanan != null) widget.onSelesaikanPesanan!();
          Navigator.pop(context);
        },
      ),
    );
  }
}
