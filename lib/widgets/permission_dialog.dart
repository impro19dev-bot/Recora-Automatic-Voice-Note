import 'dart:async';

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

  // A previous "Don't Allow" is permanently denied on iOS. Do not open
  // Settings unless the user taps that button on a later recording attempt.
  if (await microphoneService.isPermanentlyDenied()) {
    if (!context.mounted) return false;
    return _offerMicrophoneSettings(context, microphoneService);
  }

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(l10n.micRequired),
          content: Text(l10n.micRequiredBody),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.continueAction),
            ),
          ],
        ),
      );
    },
  );

  if (!context.mounted) return false;

  // Respect "Don't Allow". Stay in the app.
  return microphoneService.ensurePermission();
}

Future<bool> _offerMicrophoneSettings(
  BuildContext context,
  MicrophoneService microphoneService,
) async {
  final l10n = context.l10n;
  final openSettings = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.micRequired),
        content: Text(l10n.micSettingsBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.notNow),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.openSettings),
          ),
        ],
      );
    },
  );

  if (openSettings != true || !context.mounted) return false;
  return _permissionAfterResume(microphoneService);
}

Future<bool> _permissionAfterResume(MicrophoneService microphoneService) async {
  final completer = Completer<bool>();
  var leftApp = false;
  final listener = AppLifecycleListener(
    onInactive: () => leftApp = true,
    onPause: () => leftApp = true,
    onResume: () async {
      if (!leftApp || completer.isCompleted) return;
      final granted = await microphoneService.hasPermission;
      if (!completer.isCompleted) completer.complete(granted);
    },
  );

  try {
    await microphoneService.openSettings();
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!leftApp && !completer.isCompleted) {
      completer.complete(await microphoneService.hasPermission);
    }
    return await completer.future;
  } finally {
    listener.dispose();
  }
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
