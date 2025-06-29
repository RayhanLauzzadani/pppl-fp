import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './pesanan_model.dart';
import 'components/detail_pesanan_proses_scaffold.dart';
import 'components/kendala_modal.dart';
import 'proses_detail_pesanan_selesai_page.dart';

class ProsesDetailPesananProsesPage extends StatefulWidget {
  final Pesanan pesanan;
  final String role;
  final VoidCallback? onHentikanProses;

  const ProsesDetailPesananProsesPage({
    super.key,
    required this.pesanan,
    required this.role,
    this.onHentikanProses,
  });

  @override
  State<ProsesDetailPesananProsesPage> createState() =>
      _ProsesDetailPesananProsesPageState();
}

class _ProsesDetailPesananProsesPageState
    extends State<ProsesDetailPesananProsesPage> {
  late List<Map<String, dynamic>> listItem;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    listItem = [];

    if (widget.pesanan.jumlah != null && widget.pesanan.jumlah!.isNotEmpty) {
      widget.pesanan.jumlah!.forEach((nama, qty) {
        if (qty > 0) {
          listItem.add({
            "nama": nama,
            "jumlah": qty,
            "konfirmasi": false,
            "tipe": "layanan",
          });
        }
      });
    }

    if (widget.pesanan.barangQty.isNotEmpty) {
      widget.pesanan.barangQty.forEach((nama, qty) {
        if (qty > 0) {
          listItem.add({
            "nama": nama,
            "jumlah": qty,
            "konfirmasi": false,
            "tipe": "barang",
          });
        }
      });
    }

    if (listItem.isEmpty) {
      listItem = [
        {"nama": "Item", "jumlah": 1, "konfirmasi": false, "tipe": "barang"},
      ];
    }
  }

  Future<void> _hentikanProsesDanKeDetailSelesai() async {
    if (widget.pesanan.kodeLaundry == null ||
        widget.pesanan.kodeLaundry!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode Laundry tidak ditemukan!")),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('laundries')
          .doc(widget.pesanan.kodeLaundry!)
          .collection('pesanan')
          .doc(widget.pesanan.id)
          .update({'status': 'belum_diambil'});

      if (mounted) {
        final pesananSelesai = widget.pesanan.copyWith(status: 'belum_diambil');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProsesDetailPesananSelesaiPage(
              pesanan: pesananSelesai,
              role: widget.role,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update status pesanan: $e')),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DetailPesananScaffold(
            pesanan: widget.pesanan,
            status: 'proses',
            listItem: listItem,
            role: widget.role,
            laundryId: widget.pesanan.kodeLaundry ?? '',
            onChangedKonfirmasi: (idx, val) {
              setState(() {
                listItem[idx]["konfirmasi"] = val;
              });
            },
            onLaporkanKendala: handleLaporkanKendala,
            onHentikanProses: isLoading ? null : _hentikanProsesDanKeDetailSelesai,
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
