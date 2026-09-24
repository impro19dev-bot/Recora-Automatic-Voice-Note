import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 120,
    this.showGlow = false,
  });

  final double size;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          if (showGlow)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: size * 0.18,
              offset: Offset(0, size * 0.06),
            ),
        ],
      ),
      child: Image.asset(
        'assets/icons/app_icon.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

class EmptyListIcon extends StatelessWidget {
  const EmptyListIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLogo(size: 72);
  }
}
