import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const GradientAppBar({
    Key? key,
    required this.title,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient Container persis seperti contoh kamu
        Container(
          width: double.infinity,
          height: preferredSize.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.01, 0.12, 0.83],
              colors: [
                Color(0xFFFFF6E9), // krem putih
                Color(0xFFBBE2EC), // biru muda
                Color(0xFF40A2E3), // biru terang
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x15000000),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
        ),
        SafeArea(
          child: SizedBox(
            height: preferredSize.height,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF656565), // Abu-abu gelap sesuai Figma
                    size: 22,
                  ),
                  onPressed: onBack ?? () => Navigator.pop(context),
                  splashRadius: 20,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 56),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}