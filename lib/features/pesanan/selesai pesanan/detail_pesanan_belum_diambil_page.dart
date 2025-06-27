import 'package:flutter/material.dart';
import 'selesai_pesanan_model.dart';
import 'detail_pesanan_scaffold.dart';

class DetailPesananBelumDiambilPage extends StatelessWidget {
  final Pesanan pesanan;
  final VoidCallback? onKonfirmasiDiambil;

  const DetailPesananBelumDiambilPage({
    super.key,
    required this.pesanan,
    this.onKonfirmasiDiambil,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DetailPesananScaffold(
        pesanan: pesanan,
        status: 'belum_diambil',
        onKonfirmasiDiambil: onKonfirmasiDiambil,
      ),
    );
  }
}
