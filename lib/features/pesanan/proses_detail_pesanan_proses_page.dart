import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './pesanan_model.dart';
import 'components/detail_pesanan_proses_scaffold.dart';
import 'components/kendala_modal.dart';

class ProsesDetailPesananProsesPage extends StatefulWidget {
  final Pesanan pesanan;
  final VoidCallback? onHentikanProses;

  const ProsesDetailPesananProsesPage({
    Key? key,
    required this.pesanan,
    this.onHentikanProses,
  }) : super(key: key);

  @override
  State<ProsesDetailPesananProsesPage> createState() => _ProsesDetailPesananProsesPageState();
}

class _ProsesDetailPesananProsesPageState extends State<ProsesDetailPesananProsesPage> {
  late List<Map<String, dynamic>> listItem;

  @override
  void initState() {
    super.initState();
    // Convert barangQty ke list untuk kebutuhan UI
    listItem = [];
    widget.pesanan.barangQty.forEach((key, value) {
      listItem.add({
        "nama": key,
        "jumlah": value,
        "konfirmasi": false,
      });
    });
    // Jika kosong, bisa fallback dummy, tapi biasanya Firestore pasti ada data
    if (listItem.isEmpty) {
      listItem = [
        {"nama": "Baju", "jumlah": 1, "konfirmasi": false},
      ];
    }
  }

  Future<void> _updateStatusSelesai() async {
    try {
      // Gunakan id dan kodeLaundry dari pesanan model
      await FirebaseFirestore.instance
          .collection('laundries')
          .doc(widget.pesanan.kodeLaundry)
          .collection('pesanan')
          .doc(widget.pesanan.id)
          .update({'status': 'selesai'});
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
        status: 'proses',
        listItem: listItem,
        onChangedKonfirmasi: (idx, val) {
          setState(() {
            listItem[idx]["konfirmasi"] = val;
          });
        },
        onLaporkanKendala: handleLaporkanKendala,
        onHentikanProses: () async {
          await _updateStatusSelesai();
          if (!mounted) return;
          if (widget.onHentikanProses != null) widget.onHentikanProses!();
          Navigator.pop(context);
        },
      ),
    );
  }
}
