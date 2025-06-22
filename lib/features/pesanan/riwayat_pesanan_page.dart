import 'package:flutter/material.dart';

class RiwayatPesananPage extends StatefulWidget {
  const RiwayatPesananPage({super.key});

  @override
  State<RiwayatPesananPage> createState() => _RiwayatPesananPageState();
}

class _RiwayatPesananPageState extends State<RiwayatPesananPage> {
  String search = "";

  final List<Map<String, dynamic>> riwayatList = [
    {
      "nota": "1157.1909.21",
      "tipe": "Reguler",
      "masuk": "03/09/2024 - 19:37",
      "selesai": "07/09/2024 - 09:21",
      "total": 50000,
      "status": "Lunas",
      "metode": "Tunai",
      "icon": Icons.shopping_basket_outlined,
    },
    {
      "nota": "1166.1909.23",
      "tipe": "Ekspress",
      "masuk": "03/09/2024 - 19:37",
      "selesai": "07/09/2024 - 09:21",
      "total": 50000,
      "status": "Lunas",
      "metode": "Tunai",
      "icon": Icons.shopping_basket_outlined,
    },
    {
      "nota": "1155.1809.21",
      "tipe": "Reguler",
      "masuk": "03/09/2024 - 19:37",
      "selesai": "07/09/2024 - 09:21",
      "total": 50000,
      "status": "Lunas",
      "metode": "Tunai",
      "icon": Icons.shopping_basket_outlined,
    },
    {
      "nota": "1154.1809.21",
      "tipe": "Reguler",
      "masuk": "03/09/2024 - 19:37",
      "selesai": "07/09/2024 - 09:21",
      "total": 50000,
      "status": "Lunas",
      "metode": "Tunai",
      "icon": Icons.shopping_basket_outlined,
    },
    {
      "nota": "1153.1709.21",
      "tipe": "Reguler",
      "masuk": "03/09/2024 - 19:37",
      "selesai": "07/09/2024 - 09:21",
      "total": 50000,
      "status": "Lunas",
      "metode": "Tunai",
      "icon": Icons.shopping_basket_outlined,
    },
    {
      "nota": "1152.1709.23",
      "tipe": "Ekspress",
      "masuk": "03/09/2024 - 19:37",
      "selesai": "07/09/2024 - 09:21",
      "total": 50000,
      "status": "Lunas",
      "metode": "Tunai",
      "icon": Icons.shopping_basket_outlined,
    },
    {
      "nota": "1151.1709.22",
      "tipe": "Kilat",
      "masuk": "03/09/2024 - 19:37",
      "selesai": "07/09/2024 - 09:21",
      "total": 50000,
      "status": "Lunas",
      "metode": "Tunai",
      "icon": Icons.shopping_basket_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = riwayatList.where((item) {
      final q = search.toLowerCase();
      return item["nota"].toString().toLowerCase().contains(q) ||
          item["tipe"].toString().toLowerCase().contains(q) ||
          item["masuk"].toString().toLowerCase().contains(q) ||
          item["selesai"].toString().toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF40A2E3),
                  Color(0xFFBBE2EC),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.only(top: 42, left: 0, right: 0, bottom: 21),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Riwayat Pesanan",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                  const SizedBox(height: 17),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => search = v),
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search_rounded, color: Colors.black45, size: 24),
                          hintText: "Cari nama / nota / tanggal",
                          hintStyle: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 9),
          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 0),
              itemCount: filteredList.length,
              itemBuilder: (context, i) {
                final item = filteredList[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        margin: const EdgeInsets.only(right: 14, top: 2),
                        child: Icon(item["icon"], size: 39, color: const Color(0xFF40A2E3)),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "Nota–${item["nota"]} ",
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: 14.8,
                                ),
                                children: [
                                  TextSpan(
                                    text: item["tipe"],
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      fontSize: 13.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Masuk : ${item["masuk"]}\nSelesai : ${item["selesai"]}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.black87,
                                fontSize: 12.7,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      // Harga & status
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Rp ${item["total"].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                            ),
                          ),
                          Text(
                            "${item["status"]} • ${item["metode"]}",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                              fontSize: 12.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
