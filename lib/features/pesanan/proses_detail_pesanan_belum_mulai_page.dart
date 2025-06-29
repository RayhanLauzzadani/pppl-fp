import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './pesanan_model.dart';
import 'components/detail_pesanan_proses_scaffold.dart';
import 'components/kendala_modal.dart';
import 'proses_detail_pesanan_proses_page.dart';

class ProsesDetailPesananBelumMulaiPage extends StatefulWidget {
  final Pesanan pesanan;
  final String role;
  final VoidCallback? onMulaiProses;

  const ProsesDetailPesananBelumMulaiPage({
    Key? key,
    required this.pesanan,
    required this.role,
    this.onMulaiProses,
  }) : super(key: key);

  @override
  State<ProsesDetailPesananBelumMulaiPage> createState() =>
      _ProsesDetailPesananBelumMulaiPageState();
}

class _ProsesDetailPesananBelumMulaiPageState
    extends State<ProsesDetailPesananBelumMulaiPage> {
  late List<Map<String, dynamic>> listItem;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    listItem = [];

    // 1. Jenis Layanan (field jumlah)
    if (widget.pesanan.jumlah != null && widget.pesanan.jumlah!.isNotEmpty) {
      widget.pesanan.jumlah!.forEach((nama, qty) {
        if (nama.toLowerCase() == "laundry kiloan") return;
        if (qty > 0) {
          listItem.add({
            "nama": nama,
            "jumlah": qty.toString(),
            "konfirmasi": false,
          });
        }
      });
    }

    // 2. Barang Custom/Satuan
    for (final barang in widget.pesanan.barangList) {
      final nama = barang['title'] ?? barang['nama'] ?? '';
      final qty = widget.pesanan.barangQty[nama] ?? 0;
      if (nama.toString().isNotEmpty && qty > 0) {
        listItem.add({
          "nama": nama,
          "jumlah": qty.toString(),
          "konfirmasi": false,
        });
      }
    }

    if (listItem.isEmpty) {
      listItem = [
        {"nama": "Item Kosong", "jumlah": "0", "konfirmasi": false},
      ];
    }
  }

  Future<void> _updateStatusProsesAndNavigate() async {
    setState(() => isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('laundries')
          .doc(widget.pesanan.kodeLaundry)
          .collection('pesanan')
          .doc(widget.pesanan.id)
          .update({'status': 'proses'});

      final Pesanan prosesPesanan = widget.pesanan.copyWith(status: 'proses');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProsesDetailPesananProsesPage(
              pesanan: prosesPesanan,
              role: widget.role,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update status pesanan: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
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

  void handleKonfirmasi(int idx, bool value) {
    setState(() {
      listItem[idx]['konfirmasi'] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DetailPesananScaffold(
            pesanan: widget.pesanan,
            status: 'belum_mulai',
            listItem: listItem,
            role: widget.role,
            laundryId: widget.pesanan.kodeLaundry ?? '',
            onChangedKonfirmasi: handleKonfirmasi,
            onLaporkanKendala: handleLaporkanKendala,
            onMulaiProses: _updateStatusProsesAndNavigate,
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.25),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
