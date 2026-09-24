import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../l10n/locale_scope.dart';

class LegalSafetyContent {
  static Widget safetyBox(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoBannerBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.infoBannerBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_moon_outlined, color: AppColors.teal),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.safetyStatement,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<Widget> standardFooter(BuildContext context) {
    final l10n = context.l10n;
    return [
      const SizedBox(height: 16),
      Text(
        l10n.localStorage,
        style: const TextStyle(height: 1.5, color: AppColors.textSecondary),
      ),
      const SizedBox(height: 12),
      Text(
        l10n.sharingPolicy,
        style: const TextStyle(height: 1.5, color: AppColors.textSecondary),
      ),
      const SizedBox(height: 12),
      Text(
        l10n.consentResponsibility,
        style: const TextStyle(height: 1.5, color: AppColors.textSecondary),
      ),
    ];
  }
}
