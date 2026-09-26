import 'package:flutter/material.dart';

class HdfcColors {
  static const Color navy = Color(0xFF004C8F);
  static const Color deepNavy = Color(0xFF002F6C);
  static const Color darkBlue = Color(0xFF001B44);
  static const Color red = Color(0xFFED1C24);
  static const Color lightRed = Color(0xFFFEE2E2);
  static const Color gold = Color(0xFFB8860B);
  static const Color lightGold = Color(0xFFFEF3C7);
  static const Color bg = Color(0xFFF4F6F9);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textSubtle = Color(0xFF94A3B8);
  static const Color green = Color(0xFF16A34A);
  static const Color greenBg = Color(0xFFDCFCE7);
}

class HdfcStyles {
  static BoxDecoration cardDecoration = BoxDecoration(
    color: HdfcColors.surface,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: HdfcColors.border, width: 1),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF0F172A).withValues(alpha: 0.04),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ],
  );

  static TextStyle title = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: HdfcColors.textDark,
    letterSpacing: -0.3,
  );

  static TextStyle subtitle = const TextStyle(
    fontSize: 13,
    color: HdfcColors.textMuted,
    fontWeight: FontWeight.w400,
  );
}

class HdfcLogoWidget extends StatelessWidget {
  final double size;
  const HdfcLogoWidget({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/hdfc_emblem.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (ctx, err, stack) {
        return _buildVectorFallback(size);
      },
    );
  }

  static Widget _buildVectorFallback(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: HdfcColors.red,
              borderRadius: BorderRadius.circular(size * 0.12),
            ),
          ),
          Container(
            width: size * 0.72,
            height: size * 0.72,
            color: Colors.white,
          ),
          Container(
            width: size * 0.44,
            height: size * 0.44,
            color: HdfcColors.navy,
          ),
          Container(
            width: size * 0.14,
            height: size,
            color: HdfcColors.red,
          ),
          Container(
            width: size,
            height: size * 0.14,
            color: HdfcColors.red,
          ),
          Container(
            width: size * 0.36,
            height: size * 0.36,
            color: HdfcColors.navy,
          ),
        ],
      ),
    );
  }
}

class HdfcFullLogoWidget extends StatelessWidget {
  final double height;
  const HdfcFullLogoWidget({super.key, this.height = 24});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/hdfc_logo.png',
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (ctx, err, stack) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HdfcLogoWidget(size: height),
            const SizedBox(width: 8),
            Text(
              'HDFC BANK',
              style: TextStyle(
                fontSize: height * 0.6,
                fontWeight: FontWeight.w800,
                color: HdfcColors.deepNavy,
                letterSpacing: 1.1,
              ),
            ),
          ],
        );
      },
    );
  }
}
