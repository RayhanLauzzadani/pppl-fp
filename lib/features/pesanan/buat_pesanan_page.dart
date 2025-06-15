import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ===========================
//     MAIN STATEFUL PAGE
// ===========================
class BuatPesananPage extends StatefulWidget {
  const BuatPesananPage({super.key});

  @override
  State<BuatPesananPage> createState() => _BuatPesananPageState();
}

// ===========================
//        STATE & DATA
// ===========================
class _BuatPesananPageState extends State<BuatPesananPage> {
  int _step = 0;

  // --- Data Pelanggan
  String nama = "";
  String whatsapp = "";
  late TextEditingController namaController;
  late TextEditingController waController;

  // --- Layanan List
  List<Map<String, dynamic>> layananList = [
    {"nama": "Bed Cover Double", "harga": 20000, "qty": 0},
    {"nama": "Bed Cover Jumbo", "harga": 30000, "qty": 0},
    {"nama": "Bed Cover Single", "harga": 12500, "qty": 0},
    {"nama": "Boneka Besar", "harga": 20000, "qty": 0},
    {"nama": "Boneka Kecil", "harga": 5000, "qty": 0},
    {"nama": "Boneka Sedang", "harga": 15000, "qty": 0},
  ];

  // --- Cuci Kiloan State
  double kiloan = 0.0;
  static const int hargaPerKg = 10000;
  int jumlahBaju = 0;
  int jumlahCelana = 0;
  int jumlahLuaran = 0;

  // --- Tambahan
  String catatan = "";
  String jenisParfum = "Junjung Buih";
  String antarJemput = "≤ 2 Km";
  String diskon = "-";
  late TextEditingController catatanController;

  // --- Payment & flow state
  bool sudahBayar = false;
  bool bayarNanti = false;

  int get totalBayar {
    int total = 0;
    for (var item in layananList) {
      total += (item['harga'] as int) * (item['qty'] as int);
    }
    total += (kiloan > 0) ? (kiloan * hargaPerKg).round() : 0;
    return total;
  }

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: nama);
    waController = TextEditingController(text: whatsapp);
    catatanController = TextEditingController(text: catatan);
  }

  void _nextStep() {
    if (_step == 0) {
      if (nama.trim().isEmpty || whatsapp.length < 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nama dan nomor WA harus diisi dengan benar!'),
          ),
        );
        return;
      }
    }
    setState(() => _step++);
  }

  void _prevStep() {
    if (_step > 0) setState(() => _step--);
  }

  // ======================
  // HANDLER LOGIC
  // ======================
  void handleBayarNanti() {
    setState(() {
      bayarNanti = true;
      sudahBayar = false;
      _step = 4; // ke halaman ringkasan dengan tombol sesuai Figma
    });
  }

  void handleBatalkanPesanan() {
    setState(() {
      bayarNanti = false;
      sudahBayar = false;
      _step = 0; // reset ke step awal (input pelanggan)
      // Atau bisa ke halaman list pesanan, sesuai kebutuhan
    });
  }

  void handleBayarSekarang() {
    setState(() {
      sudahBayar = true;
      bayarNanti = false;
      _step = 4; // ke halaman ringkasan selesai bayar
    });
  }

  void handleLihatProses() {
    // Navigasi ke halaman proses atau show dialog
    // Contoh: showDialog, atau Navigator.push(...)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lihat proses laundry (simulasi)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomGradientHeader(
        title: "Buat Pesanan",
        showBack: _step > 0,
        onBack: _prevStep,
      ),
      body: SafeArea(
        child: StepperBody(
          step: _step,
          nama: nama,
          whatsapp: whatsapp,
          layananList: layananList,
          totalBayar: totalBayar,
          catatan: catatan,
          jenisParfum: jenisParfum,
          antarJemput: antarJemput,
          diskon: diskon,
          sudahBayar: sudahBayar,
          bayarNanti: bayarNanti,
          kiloan: kiloan,
          hargaPerKg: hargaPerKg,
          jumlahBaju: jumlahBaju,
          jumlahCelana: jumlahCelana,
          jumlahLuaran: jumlahLuaran,
          namaController: namaController,
          waController: waController,
          catatanController: catatanController,
          onNamaChanged: (v) => setState(() => nama = v),
          onWhatsappChanged: (v) => setState(() => whatsapp = v),
          onTambahLayanan: (i) => setState(() => layananList[i]['qty'] += 1),
          onKurangLayanan: (i) => setState(() {
            if (layananList[i]['qty'] > 0) layananList[i]['qty'] -= 1;
          }),
          onNext: _nextStep,
          onPrev: _prevStep,
          onCatatanChanged: (v) => setState(() => catatan = v),
          onJenisParfumChanged: (v) => setState(() => jenisParfum = v),
          onAntarJemputChanged: (v) => setState(() => antarJemput = v),
          onDiskonChanged: (v) => setState(() => diskon = v),
          onKiloanChanged: (v) => setState(() {
            double val = double.tryParse(v) ?? 0;
            if (val < 0) val = 0;
            kiloan = val;
          }),
          onJumlahBajuChanged: (v) => setState(() => jumlahBaju = v),
          onJumlahCelanaChanged: (v) => setState(() => jumlahCelana = v),
          onJumlahLuaranChanged: (v) => setState(() => jumlahLuaran = v),
          onBuatPesanan: () => setState(() {
            _step = 3;
            bayarNanti = false;
            sudahBayar = false;
          }),
          onBayarNanti: handleBayarNanti,
          onBayarSekarang: handleBayarSekarang,
          onBatalkanPesanan: handleBatalkanPesanan,
          onLihatProses: handleLihatProses,
        ),
      ),
    );
  }
}

// ===============================
//   CUSTOM GRADIENT HEADER
// ===============================
class CustomGradientHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;

  const CustomGradientHeader({
    Key? key,
    required this.title,
    this.showBack = false,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: preferredSize.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF40A2E3), // Biru atas
                Color(0xFFBBE2EC), // Biru muda tengah
                Color(0xFFFFF6E9), // Putih krem bawah
              ],
              stops: [0.0, 0.75, 1.0],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
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
          child: SizedBox(
            height: preferredSize.height,
            child: Row(
              children: [
                showBack
                    ? IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: onBack ?? () => Navigator.pop(context),
                      )
                    : const SizedBox(width: 52),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 52),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

// =============================
//     STEPPER BODY CONTENT
// =============================
class StepperBody extends StatelessWidget {
  final int step;
  final String nama, whatsapp, catatan, jenisParfum, antarJemput, diskon;
  final List<Map<String, dynamic>> layananList;
  final int totalBayar;
  final bool sudahBayar, bayarNanti;
  final double kiloan;
  final int hargaPerKg;
  final int jumlahBaju, jumlahCelana, jumlahLuaran;
  final TextEditingController namaController;
  final TextEditingController waController;
  final TextEditingController catatanController;

  final ValueChanged<String> onNamaChanged,
      onWhatsappChanged,
      onCatatanChanged,
      onJenisParfumChanged,
      onAntarJemputChanged,
      onDiskonChanged,
      onKiloanChanged;

  final Function(int) onTambahLayanan, onKurangLayanan;
  final Function(int) onJumlahBajuChanged,
      onJumlahCelanaChanged,
      onJumlahLuaranChanged;
  final VoidCallback onNext, onPrev, onBuatPesanan;
  final VoidCallback onBayarNanti,
      onBayarSekarang,
      onBatalkanPesanan,
      onLihatProses;

  const StepperBody({
    super.key,
    required this.step,
    required this.nama,
    required this.whatsapp,
    required this.layananList,
    required this.totalBayar,
    required this.catatan,
    required this.jenisParfum,
    required this.antarJemput,
    required this.diskon,
    required this.sudahBayar,
    required this.bayarNanti,
    required this.kiloan,
    required this.hargaPerKg,
    required this.jumlahBaju,
    required this.jumlahCelana,
    required this.jumlahLuaran,
    required this.namaController,
    required this.waController,
    required this.catatanController,
    required this.onNamaChanged,
    required this.onWhatsappChanged,
    required this.onTambahLayanan,
    required this.onKurangLayanan,
    required this.onNext,
    required this.onPrev,
    required this.onCatatanChanged,
    required this.onJenisParfumChanged,
    required this.onAntarJemputChanged,
    required this.onDiskonChanged,
    required this.onKiloanChanged,
    required this.onJumlahBajuChanged,
    required this.onJumlahCelanaChanged,
    required this.onJumlahLuaranChanged,
    required this.onBuatPesanan,
    required this.onBayarNanti,
    required this.onBayarSekarang,
    required this.onBatalkanPesanan,
    required this.onLihatProses,
  });

  Widget _itemCountInput(String label, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          SizedBox(
            width: 135,
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: () => onChanged((value > 0) ? value - 1 : 0),
          ),
          Text(
            "$value",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- Step 0: Data pelanggan ---
    if (step == 0) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama"),
              onChanged: onNamaChanged,
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z\s]')),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: waController,
              decoration: const InputDecoration(labelText: "Nomor Whatsapp"),
              onChanged: onWhatsappChanged,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 30),
            ...[
              {"label": "3 Hari", "desc": "Reguler"},
              {"label": "1 Hari", "desc": "Ekspress"},
              {"label": "3 Jam", "desc": "Kilat"},
            ].map(
              (d) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  tileColor: const Color(0xFFFDF6ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    d["label"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                  subtitle: Text(
                    d["desc"]!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: onNext,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // --- Step 1: Pilih layanan ---
    if (step == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Cari nama layanan",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  // Cuci Kiloan Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F3FF),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.10),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.emoji_emotions,
                              color: Color(0xFF40A2E3),
                              size: 26,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Cuci Kiloan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Text(
                                    "Berat (kg)",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 5),
                                  SizedBox(
                                    width: 38,
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        hintText: "0",
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 6,
                                        ),
                                      ),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      onChanged: onKiloanChanged,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "x Rp. $hargaPerKg",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        _itemCountInput(
                          "Atasan",
                          jumlahBaju,
                          onJumlahBajuChanged,
                        ),
                        _itemCountInput(
                          "Bawahan",
                          jumlahCelana,
                          onJumlahCelanaChanged,
                        ),
                        _itemCountInput(
                          "Pakaian Lainnya",
                          jumlahLuaran,
                          onJumlahLuaranChanged,
                        ),
                      ],
                    ),
                  ),
                  // Layanan Satuan
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: layananList.length,
                    itemBuilder: (context, i) {
                      final l = layananList[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F3FF),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.10),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
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
                                    l['nama'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    "Rp. ${l['harga']}",
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove, size: 22),
                              onPressed: () => onKurangLayanan(i),
                            ),
                            Text(
                              "${l['qty']}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 22),
                              onPressed: () => onTambahLayanan(i),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Info & Next Button (sticky)
          Padding(
            padding: const EdgeInsets.only(
              top: 6,
              bottom: 8,
              left: 16,
              right: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nama, style: const TextStyle(fontSize: 16)),
                      Text(whatsapp, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                Text(
                  "Rp. $totalBayar",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE7DBF6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: onNext,
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9063BF),
                    fontSize: 21,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      );
    }

    // --- Step 2: Tambahan/opsi ---
    if (step == 2) {
      return Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown Jenis Parfum
                const Text(
                  "Jenis Parfum",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2FAFF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Color(0xFFD7E6EE)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: jenisParfum,
                      borderRadius: BorderRadius.circular(15),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF243147),
                      ),
                      items: ["Junjung Buih", "Paris", "Royal"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => onJenisParfumChanged(v ?? ''),
                      isExpanded: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Dropdown Antar Jemput
                const Text(
                  "Layanan Antar Jemput",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2FAFF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Color(0xFFD7E6EE)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: antarJemput,
                      borderRadius: BorderRadius.circular(15),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF243147),
                      ),
                      items: ["≤ 2 Km", "≤ 5 Km"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => onAntarJemputChanged(v ?? ''),
                      isExpanded: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Dropdown Diskon
                const Text(
                  "Diskon",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2FAFF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Color(0xFFD7E6EE)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: diskon,
                      borderRadius: BorderRadius.circular(15),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF243147),
                      ),
                      items: ["-", "10%", "20%"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => onDiskonChanged(v ?? ''),
                      isExpanded: true,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Catatan Tambahan ala sticky note
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8F0),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.note_alt_rounded,
                            color: Colors.orange.shade400,
                            size: 20,
                          ),
                          const SizedBox(width: 7),
                          const Text(
                            "Catatan Tambahan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: catatanController,
                        maxLines: 4,
                        minLines: 2,
                        style: const TextStyle(fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: "Tuliskan disini...",
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: onCatatanChanged,
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 90,
                ), // Padding bawah biar tombol ngambang
              ],
            ),
          ),
          // Floating Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(18),
              color: Colors.transparent,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  backgroundColor: const Color(0xFFB6D6EF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 17),
                ),
                onPressed: onBuatPesanan,
                child: const Text(
                  "Buat Pesanan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3365),
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // --- Step 3/4: Ringkasan Pesanan ---
    if (step == 3 || step == 4) {
      return _SummaryPesanan(
        nama: nama,
        whatsapp: whatsapp,
        layananList: layananList,
        kiloan: kiloan,
        hargaPerKg: hargaPerKg,
        jumlahBaju: jumlahBaju,
        jumlahCelana: jumlahCelana,
        jumlahLuaran: jumlahLuaran,
        totalBayar: totalBayar,
        catatan: catatan,
        jenisParfum: jenisParfum,
        antarJemput: antarJemput,
        diskon: diskon,
        sudahBayar: sudahBayar,
        bayarNanti: bayarNanti,
        onBayarNanti: onBayarNanti,
        onBayarSekarang: onBayarSekarang,
        onBatalkanPesanan: onBatalkanPesanan,
        onLihatProses: onLihatProses,
      );
    }

    // --- Fallback ---
    return const Center(child: Text("Done!"));
  }
}

// =============================
//      RINGKASAN PESANAN BARU
// =============================
class _SummaryPesanan extends StatelessWidget {
  final String nama, whatsapp, catatan, jenisParfum, antarJemput, diskon;
  final List<Map<String, dynamic>> layananList;
  final int totalBayar;
  final bool sudahBayar, bayarNanti;
  final VoidCallback onBayarNanti,
      onBayarSekarang,
      onBatalkanPesanan,
      onLihatProses;
  final double kiloan;
  final int hargaPerKg;
  final int jumlahBaju, jumlahCelana, jumlahLuaran;

  const _SummaryPesanan({
    super.key,
    required this.nama,
    required this.whatsapp,
    required this.layananList,
    required this.kiloan,
    required this.hargaPerKg,
    required this.jumlahBaju,
    required this.jumlahCelana,
    required this.jumlahLuaran,
    required this.totalBayar,
    required this.catatan,
    required this.jenisParfum,
    required this.antarJemput,
    required this.diskon,
    required this.sudahBayar,
    required this.bayarNanti,
    required this.onBayarNanti,
    required this.onBayarSekarang,
    required this.onBatalkanPesanan,
    required this.onLihatProses,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy tanggal, nota, dsb.
    String nota = "Nota-1157.1909.21 Reguler";
    String status = "Dalam Antrian";
    String tglTerima = "22/10/2024 - 15:37";
    String tglSelesai = "26/10/2024 - 08:00";

    final tableLabel = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
    final tableVal = const TextStyle(fontWeight: FontWeight.bold, fontSize: 14);

    // ========== UI Layout Ringkasan ==========
    return Container(
      color: const Color(0xFFFDF6ED),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
        children: [
          // App Bar Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nota dan Print
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      nota,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.print_rounded, size: 26),
                      onPressed: () {}, // No-op for now
                      tooltip: "Print Nota",
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    CircleAvatar(
                      // ignore: sort_child_properties_last
                      child: Text(
                        nama.isNotEmpty ? nama[0] : "?",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      radius: 21,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nama,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            whatsapp,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 0, thickness: 1, color: Colors.grey[350]),

          // Status & Table Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Text("Status", style: tableLabel)),
                    Text(status, style: tableVal),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: Text("Tanggal Terima", style: tableLabel)),
                    Text(tglTerima, style: tableVal),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text("Tanggal Selesai", style: tableLabel)),
                    Text(tglSelesai, style: tableVal),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text("Jenis Parfum", style: tableLabel)),
                    Text(jenisParfum, style: tableVal),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text("Layanan Antar Jemput", style: tableLabel),
                    ),
                    Text(antarJemput, style: tableVal),
                  ],
                ),
                if (diskon != "-")
                  Row(
                    children: [
                      Expanded(child: Text("Diskon", style: tableLabel)),
                      Text(diskon, style: tableVal),
                    ],
                  ),
              ],
            ),
          ),

          // Laundry List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(thickness: 1),
                const Text(
                  "Layanan Laundry :",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // Kiloan block
                if (kiloan > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Cuci Kiloan",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Kiloan",
                              style: TextStyle(fontSize: 13),
                            ),
                            const Spacer(),
                            Text(
                              "${kiloan.toStringAsFixed(2)} kg",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              "Rp. ${(kiloan * hargaPerKg).round()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 2),
                          child: Text(
                            "• Atasan: $jumlahBaju\n• Bawahan: $jumlahCelana\n• Pakaian Lainnya: $jumlahLuaran",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Satuan block
                ...layananList
                    .where((l) => l['qty'] > 0)
                    .map(
                      (l) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l['nama'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "Satuan",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "${l['qty']}pcs",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              "Rp. ${(l['qty'] as int) * (l['harga'] as int)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),

          // Total & Status Payment
          Container(
            margin: const EdgeInsets.only(top: 7),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: const Color(0xFFECE7DC),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Total Pembayaran",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(
                  "Rp. $totalBayar",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  sudahBayar
                      ? "(Sudah Bayar)"
                      : bayarNanti
                      ? "(Belum Bayar)"
                      : "(Belum Bayar)",
                  style: TextStyle(
                    fontSize: 14,
                    color: sudahBayar ? Colors.blue : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Button actions, menyesuaikan status bayar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Builder(
              builder: (_) {
                if (sudahBayar) {
                  return ElevatedButton(
                    onPressed: onLihatProses,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Lihat Proses"),
                  );
                }
                if (bayarNanti) {
                  // Figma: tombol Batalkan Pesanan dan Lihat Proses
                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onBatalkanPesanan,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(
                              color: Color(0xFF868686),
                              width: 1.3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Batalkan Pesanan",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onLihatProses,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF68A3DF),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Lihat Proses",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                // Default (belum bayar): Bayar Nanti & Bayar Sekarang
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onBayarNanti,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: Color(0xFF868686),
                            width: 1.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Bayar Nanti",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9063BF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onBayarSekarang,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF68A3DF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Bayar Sekarang",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
