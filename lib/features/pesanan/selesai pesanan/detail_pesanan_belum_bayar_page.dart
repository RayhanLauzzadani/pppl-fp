import 'package:flutter/material.dart';
import 'selesai_pesanan_model.dart';
import 'detail_pesanan_selesai_scaffold.dart';

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
    return DetailPesananSelesaiScaffold(
      pesanan: pesanan,
      status: 'belum_bayar',
      onKonfirmasi: onKonfirmasiBayar,
    );
  }
}
