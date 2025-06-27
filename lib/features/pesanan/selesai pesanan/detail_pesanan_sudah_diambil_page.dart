import 'package:flutter/material.dart';
import 'selesai_pesanan_model.dart';
import 'detail_pesanan_scaffold.dart';

class DetailPesananSudahDiambilPage extends StatelessWidget {
  final Pesanan pesanan;
  const DetailPesananSudahDiambilPage({
    super.key,
    required this.pesanan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DetailPesananScaffold(
        pesanan: pesanan,
        status: 'sudah_diambil',
      ),
    );
  }
}
