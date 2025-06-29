import 'package:flutter/material.dart';
import '../pesanan_model.dart';
import '../selesai pesanan/selesai_pesanan_page.dart';

class DetailPesananScaffold extends StatelessWidget {
  final Pesanan pesanan;
  final String status;
  final List<Map<String, dynamic>> listItem;
  final String role;       // Tambahkan parameter role
  final String laundryId;  // Tambahkan parameter laundryId
  final void Function(int, bool)? onChangedKonfirmasi;
  final VoidCallback? onMulaiProses;
  final VoidCallback? onHentikanProses;
  final VoidCallback? onSelesaikanProses;
  final VoidCallback? onLaporkanKendala;

  const DetailPesananScaffold({
    super.key,
    required this.pesanan,
    required this.status,
    required this.listItem,
    required this.role,      // wajib diisi
    required this.laundryId, // wajib diisi
    this.onChangedKonfirmasi,
    this.onMulaiProses,
    this.onHentikanProses,
    this.onSelesaikanProses,
    this.onLaporkanKendala,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> badge = {
      "belum_mulai": {
        "icon": Icons.close_rounded,
        "color": const Color(0xFFFF6A6A),
        "text": "Belum Mulai"
      },
      "proses": {
        "icon": Icons.radio_button_checked_rounded,
        "color": const Color(0xFF52E18C),
        "text": "Proses"
      },
      "selesai": {
        "icon": Icons.done_all_rounded,
        "color": const Color(0xFF40A2E3),
        "text": "Selesai"
      }
    };

    return Column(
      children: [
        // HEADER
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.56, 1],
              colors: [
                Color(0xFF40A2E3),
                Color(0xFFBBE2EC),
                Color(0xFFFFF6E9),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.only(top: 42, left: 0, right: 0, bottom: 18),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Detail Pesanan",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 44),
              ],
            ),
          ),
        ),

        // CARD UTAMA
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.11),
                      blurRadius: 13,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER: Nota, user, badge status
                      Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "Nota–${pesanan.id} ",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.3,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: pesanan.desc,
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pesanan.nama,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.4,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    pesanan.whatsapp,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Badge Status di pojok kanan atas
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(13),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.11),
                                    blurRadius: 7,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    badge[status]["icon"] as IconData,
                                    color: badge[status]["color"] as Color,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    badge[status]["text"].toString(),
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.66),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.grey[400], thickness: 0.8, height: 23),
                      _infoRow(
                        "Status",
                        status == "selesai"
                            ? "Selesai"
                            : (status == "proses" ? "Sedang Diproses" : "Dalam Antrian"),
                        boldValue: true,
                      ),
                      _infoRow(
                        "Tanggal Terima",
                        pesanan.createdAt != null
                            ? "${pesanan.createdAt!.day}/${pesanan.createdAt!.month}/${pesanan.createdAt!.year} – ${pesanan.createdAt!.hour.toString().padLeft(2,'0')}.${pesanan.createdAt!.minute.toString().padLeft(2,'0')}"
                            : "-",
                        boldValue: true,
                      ),
                      Divider(color: Colors.grey[400], thickness: 0.8, height: 24),
                      Row(
                        children: const [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "List Item",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 15.2,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Jumlah",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 15.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Konfirmasi",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 12.1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      ...listItem.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final item = entry.value;
                        return Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  item["nama"] as String,
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14.2,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${item["jumlah"]}",
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Checkbox(
                                  value: item["konfirmasi"] as bool,
                                  onChanged: (onChangedKonfirmasi != null)
                                      ? (val) => onChangedKonfirmasi!(idx, val ?? false)
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // BUTTONS BOTTOM
        Container(
          width: double.infinity,
          color: const Color(0xFFFFF6E9),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onLaporkanKendala,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF40A2E3),
                    backgroundColor: const Color(0xFFE2F4FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: const Text(
                    "Laporkan Kendala",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (status == 'belum_mulai') {
                      return ElevatedButton(
                        onPressed: onMulaiProses,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF40A2E3),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: const Text(
                          "Mulai Proses",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      );
                    } else if (status == 'proses') {
                      return ElevatedButton(
                        onPressed: onHentikanProses,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF52E18C),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: const Text(
                          "Hentikan Proses",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      );
                    } else {
                      // status selesai
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SelesaiPesananPage(
                                kodeLaundry: laundryId, // gunakan parameter laundryId
                                role: role,              // kirimkan parameter role
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF40A2E3),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: const Text(
                          "Selesaikan Proses",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String key, String value, {bool boldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.7),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(
              key,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14.3,
                color: Colors.black.withOpacity(0.74),
              ),
            ),
          ),
          Expanded(
            flex: 11,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: boldValue ? FontWeight.w700 : FontWeight.w400,
                fontSize: 14.5,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
