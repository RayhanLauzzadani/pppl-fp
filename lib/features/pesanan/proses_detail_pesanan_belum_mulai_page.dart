import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './pesanan_model.dart';
import 'components/detail_pesanan_proses_scaffold.dart';
import 'components/kendala_modal.dart';

class ProsesDetailPesananBelumMulaiPage extends StatefulWidget {
  final Pesanan pesanan;
  final VoidCallback? onMulaiProses;
  const ProsesDetailPesananBelumMulaiPage({
    super.key,
    required this.pesanan,
    this.onMulaiProses,
  });

  @override
  State<ProsesDetailPesananBelumMulaiPage> createState() => _ProsesDetailPesananBelumMulaiPageState();
}

class _ProsesDetailPesananBelumMulaiPageState extends State<ProsesDetailPesananBelumMulaiPage> {
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
    // Jika kosong, dummy fallback
    if (listItem.isEmpty) {
      listItem = [
        {"nama": "Baju", "jumlah": 1, "konfirmasi": false},
      ];
    }
  }

  Future<void> _updateStatusProses() async {
    try {
      await FirebaseFirestore.instance
          .collection('laundries')
          .doc(widget.pesanan.kodeLaundry)
          .collection('pesanan')
          .doc(widget.pesanan.id)
          .update({'status': 'proses'});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update status pesanan: $e')),
      );
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
        status: 'belum_mulai',
        listItem: listItem,
        onLaporkanKendala: handleLaporkanKendala,
        onMulaiProses: () async {
          await _updateStatusProses();
          if (!mounted) return;
          if (widget.onMulaiProses != null) widget.onMulaiProses!();
          Navigator.pop(context);
        },
      ),
    );
  }
}
