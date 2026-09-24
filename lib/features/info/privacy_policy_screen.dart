import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/locale_scope.dart';
import '../../widgets/legal_safety_content.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyPolicy)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.privacyPolicy,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          LegalSafetyContent.safetyBox(context),
          const SizedBox(height: 16),
          Text(
            l10n.privacyIntro,
            style: const TextStyle(height: 1.5, color: AppColors.textSecondary),
          ),
          ...LegalSafetyContent.standardFooter(context),
        ],
      ),
    );
  }
}
