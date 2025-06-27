import 'package:flutter/material.dart';
import 'selesai_pesanan_model.dart';
import 'detail_pesanan_scaffold.dart';

class DetailPesananBelumBayarPage extends StatelessWidget {
  final Pesanan pesanan;
  final VoidCallback? onKonfirmasiBayar;

  const DetailPesananBelumBayarPage({
    super.key,
    required this.pesanan,
    this.onKonfirmasiBayar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DetailPesananScaffold(
        pesanan: pesanan,
        status: 'belum_bayar',
        onKonfirmasiBayar: onKonfirmasiBayar,
      ),
    );
  }
}
