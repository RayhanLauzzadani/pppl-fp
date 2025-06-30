import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './pesanan_model.dart';
import 'components/detail_pesanan_proses_scaffold.dart';
import 'components/kendala_modal.dart';
import 'proses_detail_pesanan_selesai_page.dart';

class ProsesDetailPesananProsesPage extends StatefulWidget {
  final Pesanan pesanan;
  final String role;
  final String emailUser;
  final String passwordUser;
  final VoidCallback? onHentikanProses;

  const ProsesDetailPesananProsesPage({
    Key? key,
    required this.pesanan,
    required this.role,
    required this.emailUser,
    required this.passwordUser,
    this.onHentikanProses,
  }) : super(key: key);

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

    // Tambah dari layanan (jumlah)
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

    // Tambah dari barang custom (barangQty)
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
        {"nama": "Item Kosong", "jumlah": 0, "konfirmasi": false, "tipe": "barang"},
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
      // Selesaikan proses laundry, statusTransaksi tetap/ikut alur
      await FirebaseFirestore.instance
          .collection('laundries')
          .doc(widget.pesanan.kodeLaundry!)
          .collection('pesanan')
          .doc(widget.pesanan.id)
          .update({
            'statusProses': 'selesai',
            // Jangan ubah statusTransaksi ke 'belum_diambil' jika masih 'belum_bayar'
            // Biarkan statusTransaksi tetap sesuai di Firestore
          });

      // Baca ulang data terbaru dari Firestore agar statusTransaksi terbaru
      final doc = await FirebaseFirestore.instance
          .collection('laundries')
          .doc(widget.pesanan.kodeLaundry!)
          .collection('pesanan')
          .doc(widget.pesanan.id)
          .get();

      final pesananSelesai = Pesanan.fromFirestore(doc);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProsesDetailPesananSelesaiPage(
              pesanan: pesananSelesai,
              role: widget.role,
              emailUser: widget.emailUser,
              passwordUser: widget.passwordUser,
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
      builder: (_) => KendalaModal(noHp: widget.pesanan.whatsapp ?? ''),
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
            emailUser: widget.emailUser,        // WAJIB!
            passwordUser: widget.passwordUser,  // WAJIB!
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
