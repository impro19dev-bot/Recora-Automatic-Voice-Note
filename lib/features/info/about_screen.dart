import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/locale_scope.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/legal_safety_content.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.about)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Center(child: AppLogo(size: 100, showGlow: true)),
          const SizedBox(height: 20),
          Text(
            l10n.appName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.version,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.aboutDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          LegalSafetyContent.safetyBox(context),
          ...LegalSafetyContent.standardFooter(context),
        ],
      ),
    );
  }
}
