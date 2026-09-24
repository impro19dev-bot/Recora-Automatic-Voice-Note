import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/locale_scope.dart';
import '../../widgets/legal_safety_content.dart';

class RecordingConsentScreen extends StatelessWidget {
  const RecordingConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recordingConsent)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.tealSoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              size: 32,
              color: AppColors.teal,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.recordingConsent,
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
            l10n.consentIntro,
            style: const TextStyle(height: 1.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.consentManualStart,
            style: const TextStyle(height: 1.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.consentUseFor,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.consentUseBullets,
            style: const TextStyle(height: 1.6, color: AppColors.textSecondary),
          ),
          ...LegalSafetyContent.standardFooter(context),
        ],
      ),
    );
  }
}
