import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../detail_buat_pesanan_page.dart';

class BottomSheetDetailPesanan extends StatefulWidget {
  final String kodeLaundry;
  final String namaCustomer;
  final String nomorCustomer;
  final String layanan;
  final String descLayanan;
  final double kiloan;
  final Map<String, int> kiloanJenis;
  final Map<String, int> satuanDipilih;
  final Map<String, int> hargaSatuan;
  final int hargaPerKg;
  final int totalHarga;

  const BottomSheetDetailPesanan({
    super.key,
    required this.kodeLaundry,
    required this.namaCustomer,
    required this.nomorCustomer,
    required this.layanan,
    required this.descLayanan,
    required this.kiloan,
    required this.kiloanJenis,
    required this.satuanDipilih,
    required this.hargaSatuan,
    required this.hargaPerKg,
    required this.totalHarga,
  });

  @override
  State<BottomSheetDetailPesanan> createState() => _BottomSheetDetailPesananState();
}

class _BottomSheetDetailPesananState extends State<BottomSheetDetailPesanan> {
  String? _jenisParfum;
  String? _antarJemput;
  String? _diskon;
  String? _catatan;

  final _diskonList = ["-", "5%", "10%", "15%"];
  final _antarJemputList = ["-", "≤ 2 Km", "≤ 5 Km", "≥ 5 Km"];
  final _parfumList = ["-", "Junung Buih", "Downy", "Molto", "Tanpa Parfum"];

  bool _loading = false;

  void _buatPesanan() async {
    setState(() => _loading = true);

    try {
      String notaNumber = "N${DateTime.now().millisecondsSinceEpoch}";

      List<Map<String, dynamic>> barangList = [];

      widget.satuanDipilih.forEach((nama, qty) {
        if (qty > 0) {
          barangList.add({
            "nama": nama,
            "jenis": "satuan",
            "jumlah": qty,
            "harga": widget.hargaSatuan[nama] ?? 0,
            "subtotal": qty * (widget.hargaSatuan[nama] ?? 0),
          });
        }
      });

      if (widget.kiloan > 0) {
        barangList.add({
          "nama": "Cuci Kiloan",
          "jenis": "kiloan",
          "jumlah": widget.kiloan,
          "harga": widget.hargaPerKg,
          "subtotal": (widget.kiloan * widget.hargaPerKg).round(),
          "detail": widget.kiloanJenis,
        });
      }

      DocumentReference pesananRef = await FirebaseFirestore.instance
          .collection("laundries")
          .doc(widget.kodeLaundry)
          .collection("pesanan")
          .add({
        "nota": notaNumber,
        "nama_customer": widget.namaCustomer,
        "nomor_customer": widget.nomorCustomer,
        "layanan": widget.layanan,
        "desc_layanan": widget.descLayanan,
        "barang": barangList,
        "jenis_parfum": _jenisParfum ?? "-",
        "antar_jemput": _antarJemput ?? "-",
        "diskon": _diskon ?? "-",
        "catatan": _catatan ?? "",
        "status": "Dalam Antrian",
        "tanggal_terima": Timestamp.now(),
        "tanggal_selesai": null,
        "total_harga": widget.totalHarga,
        "sudah_bayar": false,
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DetailBuatPesananPage(
              kodeLaundry: widget.kodeLaundry,
              idPesanan: pesananRef.id,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan pesanan: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFFDFBF6),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const Center(
              child: Text(
                "Buat Pesanan",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Jenis Parfum
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                "Jenis Parfum",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 15.5,
                  color: Colors.grey[800],
                ),
              ),
            ),
            _buildDropdown(_parfumList, _jenisParfum, (val) => setState(() => _jenisParfum = val)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                "Layanan Antar Jemput",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 15.5,
                  color: Colors.grey[800],
                ),
              ),
            ),
            _buildDropdown(_antarJemputList, _antarJemput, (val) => setState(() => _antarJemput = val)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                "Diskon",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 15.5,
                  color: Colors.grey[800],
                ),
              ),
            ),
            _buildDropdown(_diskonList, _diskon, (val) => setState(() => _diskon = val)),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Text(
                "Catatan (opsional)",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 15.5,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6E9),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
              ),
              child: TextField(
                minLines: 1,
                maxLines: 3,
                onChanged: (val) => _catatan = val,
                decoration: const InputDecoration(
                  hintText: "Catatan tambahan",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                ),
                style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 18),
            // Tombol Buat Pesanan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _buatPesanan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40A2E3),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text(
                      "Buat Pesanan",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> options, String? value, ValueChanged<String?> onChanged) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value ?? options[0],
          isExpanded: true,
          icon: const Icon(Icons.expand_more, size: 24),
          borderRadius: BorderRadius.circular(14),
          style: const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
          items: options.map((v) => DropdownMenuItem(
            value: v,
            child: Text(v, style: const TextStyle(fontSize: 15, fontFamily: 'Poppins')),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
