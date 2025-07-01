import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class KendalaModal extends StatelessWidget {
  final String noHp;
  const KendalaModal({super.key, required this.noHp});

  Future<void> _launchWA(BuildContext context) async {
    String noWa = noHp.replaceAll(RegExp(r'[^0-9]'), '');
    if (noWa.startsWith('0')) noWa = '62${noWa.substring(1)}';
    final url = Uri.parse('https://wa.me/$noWa');
    print('Nomor WA: $noWa');
    print('URL WA: $url');
    try {
      bool launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuka WhatsApp!')),
        );
      }
    } catch (e) {
      print('ERROR WA: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuka WhatsApp!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF40A2E3), Color(0xFFBBE2EC), Color(0xFFFFF6E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(27)),
        ),
        padding: const EdgeInsets.only(top: 32, bottom: 32),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Terdapat Kendala?",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: 17),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _launchWA(context);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.phone, color: Color(0xFF2B303A)),
                  label: const Text(
                    "Hubungi Pelanggan",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Color(0xFF2B303A),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF6E9),
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(48),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
