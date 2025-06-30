import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './pesanan_model.dart';
import 'components/detail_pesanan_proses_scaffold.dart';
import 'components/kendala_modal.dart';
import 'package:laundryin/features/pesanan/selesai pesanan/selesai_pesanan_page.dart';

class ProsesDetailPesananSelesaiPage extends StatefulWidget {
  final Pesanan pesanan;
  final String role;
  final String emailUser;
  final String passwordUser;

  const ProsesDetailPesananSelesaiPage({
    super.key,
    required this.pesanan,
    required this.role,
    required this.emailUser,
    required this.passwordUser,
  });

  @override
  State<ProsesDetailPesananSelesaiPage> createState() =>
      _ProsesDetailPesananSelesaiPageState();
}

class _ProsesDetailPesananSelesaiPageState
    extends State<ProsesDetailPesananSelesaiPage> {
  late List<Map<String, dynamic>> listItem;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    listItem = [];

    // Masukkan semua jumlah layanan tanpa filter laundry kiloan
    if (widget.pesanan.jumlah != null && widget.pesanan.jumlah!.isNotEmpty) {
      widget.pesanan.jumlah!.forEach((nama, qty) {
        if (qty > 0) {
          listItem.add({
            "nama": nama,
            "jumlah": qty,
            "konfirmasi": false,
          });
        }
      });
    }

    // Masukkan barang dari barangList dan barangQty
    for (final barang in widget.pesanan.barangList) {
      final nama = barang['title'] ?? barang['nama'] ?? '';
      final qty = widget.pesanan.barangQty[nama] ?? 0;
      if (nama.toString().isNotEmpty && qty > 0) {
        listItem.add({
          "nama": nama,
          "jumlah": qty,
          "konfirmasi": false,
        });
      }
    }

    // Jika kosong, buat dummy item
    if (listItem.isEmpty) {
      listItem = [
        {"nama": "Item Kosong", "jumlah": 0, "konfirmasi": false},
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

  Future<void> handleSelesaikanProses() async {
    setState(() => isLoading = true);
    try {
      final kodeLaundry = widget.pesanan.kodeLaundry ?? '';
      if (kodeLaundry.isEmpty) throw Exception('Kode laundry kosong!');

      // Update status pesanan jadi 'selesai' (atau sesuai status final)
      await FirebaseFirestore.instance
          .collection('laundries')
          .doc(kodeLaundry)
          .collection('pesanan')
          .doc(widget.pesanan.id)
          .update({'status': 'selesai'});

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => SelesaiPesananPage(
              kodeLaundry: kodeLaundry,
              role: widget.role,
              emailUser: widget.emailUser,
              passwordUser: widget.passwordUser,
            ),
          ),
          (route) => false,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DetailPesananScaffold(
            pesanan: widget.pesanan,
            status: 'selesai',
            listItem: listItem,
            role: widget.role,
            laundryId: widget.pesanan.kodeLaundry ?? '',
            emailUser: widget.emailUser,         // <-- PENTING!
            passwordUser: widget.passwordUser,   // <-- PENTING!
            onLaporkanKendala: handleLaporkanKendala,
            onSelesaikanProses: isLoading ? null : handleSelesaikanProses,
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
