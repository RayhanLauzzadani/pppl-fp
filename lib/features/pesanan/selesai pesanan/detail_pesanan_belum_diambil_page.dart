import 'package:flutter/material.dart';
import 'selesai_pesanan_model.dart';
import 'detail_pesanan_selesai_scaffold.dart';

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
    return DetailPesananSelesaiScaffold(
      pesanan: pesanan,
      status: 'belum_diambil',
      onKonfirmasi: onKonfirmasiDiambil,
    );
  }
}
