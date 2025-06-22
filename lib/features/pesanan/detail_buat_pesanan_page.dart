import 'package:flutter/material.dart';

class DetailBuatPesananPage extends StatefulWidget {
  final String nama;
  final String whatsapp;
  final String waktuLabel;
  final String waktuDesc;

  const DetailBuatPesananPage({
    super.key,
    required this.nama,
    required this.whatsapp,
    required this.waktuLabel,
    required this.waktuDesc,
  });

  @override
  State<DetailBuatPesananPage> createState() => _DetailBuatPesananPageState();
}

class _DetailBuatPesananPageState extends State<DetailBuatPesananPage> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> layananList = [
    {"nama": "Bed Cover Double", "harga": 20000, "qty": 0},
    {"nama": "Bed Cover Jumbo", "harga": 30000, "qty": 0},
    {"nama": "Bed Cover Single", "harga": 12500, "qty": 0},
    {"nama": "Boneka Besar", "harga": 20000, "qty": 0},
    {"nama": "Boneka Kecil", "harga": 5000, "qty": 0},
    {"nama": "Boneka Sedang", "harga": 15000, "qty": 0},
  ];

  double kiloan = 0;
  int satuan = 0;
  int meteran = 0;

  void _showTambahLayananManualDialog() {
    final namaController = TextEditingController();
    final hargaController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text("Tambah Layanan Manual"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Layanan"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: hargaController,
                decoration: const InputDecoration(labelText: "Harga Satuan"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                final nama = namaController.text.trim();
                final harga = int.tryParse(hargaController.text.trim()) ?? 0;
                if (nama.isNotEmpty && harga > 0) {
                  setState(() {
                    layananList.add({
                      "nama": nama,
                      "harga": harga,
                      "qty": 0,
                      "manual": true,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Rehitung summary (satuan, kiloan, meteran)
    satuan = layananList.fold(0, (a, b) => a + (b['qty'] as int));
    // (Kiloan & meteran bisa dari input di step sebelumnya kalau memang dipakai, misal via argumen)
    // Total bayar
    int totalBayar = layananList.fold(
      0,
      (total, item) => total + (item['harga'] as int) * (item['qty'] as int),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFD),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Stack(
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF40A2E3),
                    Color(0xFFBBE2EC),
                    Color(0xFFFFF6E9),
                  ],
                  stops: [0.0, 0.8, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black87,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    const Text(
                      "Buat Pesanan",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(16),
                  shadowColor: const Color(0x1A000000),
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFF4B757A)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: "Cari nama layanan",
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 16),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showTambahLayananManualDialog,
                        icon: const Icon(Icons.add),
                        label: const Text("Tambah Layanan Manual"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD1EAF6),
                          foregroundColor: const Color(0xFF3472A5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 10,
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // List layanan
                Expanded(
                  child: ListView.separated(
                    itemCount: layananList.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFE7E7E7)),
                    itemBuilder: (context, i) {
                      var l = layananList[i];
                      if (searchController.text.isNotEmpty &&
                          !l['nama'].toString().toLowerCase().contains(
                            searchController.text.toLowerCase(),
                          )) {
                        return const SizedBox.shrink();
                      }
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 0,
                        ),
                        title: Text(
                          l['nama'],
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18.5,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            const Text(
                              'Satuan',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black87,
                                fontSize: 13.5,
                              ),
                            ),
                            Text(
                              "Rp. ${l['harga'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                        trailing: l['qty'] == 0
                            ? InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  setState(() {
                                    l['qty'] = 1;
                                  });
                                },
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1EAF6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Color(0xFF5697BF),
                                    size: 24,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      setState(() {
                                        if (l['qty'] > 0) {
                                          l['qty'] = l['qty'] - 1;
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD1EAF6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        color: Color(0xFF5697BF),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      "${l['qty']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      setState(() {
                                        l['qty'] = l['qty'] + 1;
                                      });
                                    },
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD1EAF6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Color(0xFF5697BF),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // BOTTOM CARD (sticky)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // User Info
                  Container(
                    margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 28,
                          ),
                          radius: 23,
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  fontFamily: "Poppins",
                                ),
                              ),
                              Text(
                                widget.whatsapp,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12.5,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "$kiloan",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Text(
                              " Kg  ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "$satuan",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Text(
                              " Sat  ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "$meteran",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Text(
                              " M",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 7),
                  // TOTAL & NEXT BUTTON
                  Container(
                    margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 19,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6E9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.13),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rp. ${totalBayar.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(height: 1),
                              const Text(
                                "Total Pesanan",
                                style: TextStyle(
                                  fontSize: 13.7,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Ke step berikutnya (misal: Navigator.push ke Ringkasan)
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFD1EAF6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 29,
                              vertical: 13,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Row(
                            children: const [
                              Text(
                                "Next",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.5,
                                  color: Color(0xFF3472A5),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Color(0xFF3472A5),
                                size: 19,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
