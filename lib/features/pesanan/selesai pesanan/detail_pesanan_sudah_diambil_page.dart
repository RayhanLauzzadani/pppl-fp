import 'package:flutter/material.dart';
import 'selesai_pesanan_model.dart';
import 'detail_pesanan_selesai_scaffold.dart';

class DetailPesananSudahDiambilPage extends StatelessWidget {
  final Pesanan pesanan;

  const DetailPesananSudahDiambilPage({super.key, required this.pesanan});

  @override
  Widget build(BuildContext context) {
    return DetailPesananSelesaiScaffold(
      pesanan: pesanan,
      status: 'sudah_diambil',
      onKonfirmasi: null,
    );
  }
}
