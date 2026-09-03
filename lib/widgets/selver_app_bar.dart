import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart';

class ProAppBar extends StatelessWidget {
  final String title;
  final String? subtitle; 
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const ProAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 160,
      pinned: true,
      backgroundColor: Colors.transparent,

      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,

      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: onBackPressed ?? Get.back,
            )
          : null,

      flexibleSpace: FlexibleSpaceBar(
        background: ClipPath(
          clipper: WaveClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  appColor.primary,
                  appColor.primary.withBlue(30).withGreen(20),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (subtitle != null && subtitle!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          subtitle!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// WaveClipper
// ============================================================
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width * 0.15,
      size.height,
      size.width * 0.35,
      size.height - 25,
    );
    path.quadraticBezierTo(
      size.width * 0.55,
      size.height - 50,
      size.width * 0.75,
      size.height - 20,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height - 5,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}