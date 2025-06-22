import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailBuatPesananPage extends StatelessWidget {
  final String kodeLaundry;
  final String idPesanan;

  const DetailBuatPesananPage({
    super.key,
    required this.kodeLaundry,
    required this.idPesanan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(color: Colors.black),
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF147C8A),
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('laundries')
            .doc(kodeLaundry)
            .collection('pesanan')
            .doc(idPesanan)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          if (!snapshot.data!.exists)
            return const Center(child: Text("Pesanan tidak ditemukan"));

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final barangList = (data['barang'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();
          final totalHarga = data['total_harga'] ?? 0;
          final sudahBayar = data['sudah_bayar'] == true;
          final status = data['status'] ?? "Dalam Antrian";
          final namaCust = data['nama_customer'] ?? "-";
          final nomorCust = data['nomor_customer'] ?? "-";
          final nota = data['nota'] ?? "";
          final jenisParfum = data['jenis_parfum'] ?? "-";
          final antarJemput = data['antar_jemput'] ?? "-";
          final tanggalTerima = data['tanggal_terima'] != null
              ? (data['tanggal_terima'] as Timestamp).toDate()
              : null;
          final tanggalSelesai = data['tanggal_selesai'] != null
              ? (data['tanggal_selesai'] as Timestamp).toDate()
              : null;
          final diskon = data['diskon'] ?? "-";
          final catatan = data['catatan'] ?? "";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nota + status
                Text(
                  "Nota–$nota ${data['desc_layanan'] != null ? '(${data['desc_layanan']})' : ''}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blue.shade200,
                      child: const Icon(
                        Icons.person,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaCust,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            nomorCust,
                            style: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        const Icon(Icons.print, size: 34),
                        const SizedBox(height: 2),
                        const Text(
                          "Print Nota",
                          style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Status",
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      Text(
                        status,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                // Tanggal terima/selesai
                _detailRow(
                  "Tanggal Terima",
                  tanggalTerima != null ? _tanggalWaktu(tanggalTerima) : "-",
                ),
                _detailRow(
                  "Tanggal Selesai",
                  tanggalSelesai != null ? _tanggalWaktu(tanggalSelesai) : "-",
                ),
                _detailRow("Jenis Parfum", jenisParfum),
                _detailRow("Layanan Antar Jemput", antarJemput),
                _detailRow("Diskon", diskon),
                // Catatan
                if (catatan.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "Catatan: $catatan",
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                const Divider(),
                const SizedBox(height: 6),
                const Text(
                  "Layanan Laundry:",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                ...barangList.map((barang) => _barangItem(barang)),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 1,
                  color: Colors.grey[300],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Pembayaran",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Rp. ${_money(totalHarga)}",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: sudahBayar ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    sudahBayar ? "(Lunas)" : "(Belum Bayar)",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: sudahBayar ? Colors.green : Colors.red,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: const Color(0xFFD8EDFF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Bayar Nanti",
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Update field sudah_bayar di Firestore!
                          FirebaseFirestore.instance
                              .collection('laundries')
                              .doc(kodeLaundry)
                              .collection('pesanan')
                              .doc(idPesanan)
                              .update({'sudah_bayar': true});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF40A2E3),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Bayar Sekarang",
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Widget detail row key-value seperti status, tanggal, dll
  Widget _detailRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      child: Row(
        children: [
          Expanded(
            flex: 12,
            child: Text(
              key,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 13,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget tampilkan 1 barang/item laundry (satuan/kiloan)
  Widget _barangItem(Map<String, dynamic> barang) {
    final nama = barang['nama'] ?? '';
    final satuan = barang['tipe'] == 'kiloan' ? 'Kiloan' : 'Satuan';
    final harga = barang['harga'] ?? 0;
    final jumlah = barang['jumlah'] ?? 0;

    // Jika kiloan, jumlah = berat (kg)
    final labelJumlah = satuan == 'Kiloan' ? '${jumlah}kg' : '${jumlah}pcs';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nama,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          satuan,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.black54,
            fontFamily: 'Poppins',
            fontSize: 13,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "x Rp. ${_money(harga)}",
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              labelJumlah,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            Text(
              "Rp. ${_money(harga * jumlah)}",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  /// Format tanggal dan jam jadi string
  String _tanggalWaktu(DateTime dt) {
    // format: dd/MM/yyyy – HH:mm
    return "${_dua(dt.day)}/${_dua(dt.month)}/${dt.year} – ${_dua(dt.hour)}:${_dua(dt.minute)}";
  }

  String _dua(int n) => n.toString().padLeft(2, '0');

  String _money(num value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => "${m[1]}.",
    );
  }
}
