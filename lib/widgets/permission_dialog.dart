import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../l10n/locale_scope.dart';
import '../services/microphone_service.dart';

Future<bool> showMicrophonePermissionDialog(
  BuildContext context,
  MicrophoneService microphoneService,
) async {
  final l10n = context.l10n;

  if (await microphoneService.hasPermission) return true;
  if (!context.mounted) return false;

  final shouldRequest = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.micRequired),
        content: Text(l10n.micRequiredBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.allow),
          ),
        ],
      );
    },
  );

  if (shouldRequest != true) return false;

  var granted = await microphoneService.ensurePermission();
  if (granted) return true;

  if (await microphoneService.isPermanentlyDenied()) {
    await microphoneService.openSettings();
    granted = await microphoneService.hasPermission;
  }

  return granted;
}

Future<bool> showDeleteRecordingDialog(BuildContext context) async {
  final l10n = context.l10n;

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteRecordingTitle),
        content: Text(l10n.deleteRecordingBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.confirm),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
