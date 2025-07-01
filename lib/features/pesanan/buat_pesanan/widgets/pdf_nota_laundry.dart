import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Format angka ke rupiah (1.234.567)
String formatRupiah(num? price) {
  final s = (price ?? 0).toStringAsFixed(0);
  return s.replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  );
}

/// Generate PDF Nota Laundry versi struk kasir (rapi, minimalis, logo tengah)
Future<Uint8List> generateNotaLaundryPdf({
  required Uint8List logoBytes,
  required String nota,
  required String layanan,
  required String nama,
  required String noHp,
  required String status,
  required String tanggalTerima,
  required String tanggalSelesai,
  required String jenisParfum,
  required String antarJemput,
  required String diskon,
  required String catatan,
  required List<Map<String, dynamic>> listBarangFinal,
  required int hargaSebelumDiskon,
  required int hargaDiskon,
  required String labelDiskon,
}) async {
  final pdf = pw.Document();
  final logoImage = pw.MemoryImage(logoBytes);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a5,
      margin: pw.EdgeInsets.all(16),
      build: (context) => [
        // LOGO + Nama Laundry (Tengah)
        pw.Center(
          child: pw.Column(
            children: [
              pw.Container(
                width: 36,
                height: 36,
                margin: pw.EdgeInsets.only(bottom: 2),
                child: pw.Image(logoImage),
              ),
              pw.Text(
                'LaundryIn',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 15,
                  color: PdfColors.blue900,
                  letterSpacing: 0.3,
                ),
              ),
              pw.Text(
                'Jl. Laundry Jaya, Indonesia',
                style: pw.TextStyle(fontSize: 9.5, color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 5),
            ],
          ),
        ),
        pw.Divider(thickness: 0.7),
        pw.Center(
          child: pw.Text(
            'NOTA PESANAN LAUNDRY',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        pw.Divider(thickness: 0.7),
        pw.SizedBox(height: 4),

        // DATA CUSTOMER & PESANAN
        pw.Container(
          padding: pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('No Nota       : $nota', style: pw.TextStyle(fontSize: 10)),
              pw.Text('Nama          : $nama', style: pw.TextStyle(fontSize: 10)),
              pw.Text('No HP         : $noHp', style: pw.TextStyle(fontSize: 10)),
              pw.Text('Layanan       : $layanan', style: pw.TextStyle(fontSize: 10)),
              pw.Text('Status        : $status', style: pw.TextStyle(fontSize: 10)),
              pw.Text('Tgl Terima    : $tanggalTerima', style: pw.TextStyle(fontSize: 10)),
              pw.Text('Tgl Selesai   : $tanggalSelesai', style: pw.TextStyle(fontSize: 10)),
              pw.Text('Parfum        : $jenisParfum', style: pw.TextStyle(fontSize: 10)),
              pw.Text('Antar Jemput  : $antarJemput', style: pw.TextStyle(fontSize: 10)),
              if (diskon.trim() != "-" && diskon.trim().isNotEmpty)
                pw.Text('Diskon        : $diskon', style: pw.TextStyle(fontSize: 10)),
              if (catatan.trim() != "-" && catatan.trim().isNotEmpty)
                pw.Text('Catatan       : $catatan', style: pw.TextStyle(fontSize: 10)),
            ],
          ),
        ),
        pw.SizedBox(height: 6),

        // HEADER Rincian Layanan
        pw.Text(
          'Rincian Layanan:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10.6, color: PdfColors.black),
        ),
        pw.SizedBox(height: 1.5),

        // TABLE Minimalis, auto page jika panjang
        pw.TableHelper.fromTextArray(
          cellAlignment: pw.Alignment.centerLeft,
          cellPadding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 3),
          headerStyle: pw.TextStyle(fontSize: 10.2, fontWeight: pw.FontWeight.bold, color: PdfColors.blue700),
          headerDecoration: pw.BoxDecoration(color: PdfColors.grey200),
          cellStyle: pw.TextStyle(fontSize: 9.9, color: PdfColors.black),
          border: null,
          rowDecoration: pw.BoxDecoration(),
          headers: ['Barang', 'Jumlah', 'Total'],
          data: [
            ...listBarangFinal.map((b) => [
              '${b['nama'] ?? '-'}',
              '${b['qty'] ?? 0} ${b['satuan'] ?? ''}',
              'Rp. ${formatRupiah(b['total'])}'
            ])
          ],
        ),

        pw.SizedBox(height: 4),

        // DISKON & TOTAL (kanan)
        if (hargaSebelumDiskon > hargaDiskon) ...[
          pw.Text(
            "Sebelum Diskon: Rp. ${formatRupiah(hargaSebelumDiskon)}",
            style: pw.TextStyle(
              decoration: pw.TextDecoration.lineThrough,
              color: PdfColors.red,
              fontSize: 10,
            ),
          ),
          if (labelDiskon.isNotEmpty)
            pw.Text(
              "Diskon: $labelDiskon",
              style: pw.TextStyle(
                color: PdfColors.blue,
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
            ),
          pw.SizedBox(height: 2),
        ],
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            "TOTAL BAYAR: Rp. ${formatRupiah(hargaDiskon)}",
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 13,
              color: PdfColors.green800,
              letterSpacing: 0.5,
            ),
          ),
        ),
        pw.SizedBox(height: 7),
        pw.Divider(thickness: 0.4),
        pw.Center(
          child: pw.Text(
            'Terima kasih sudah mempercayakan laundry pada kami.',
            style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic, color: PdfColors.grey700),
          ),
        ),
      ],
    ),
  );

  return pdf.save();
}
