import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/locale_scope.dart';
import 'recording_type.dart';

Future<RecordingType?> showCallNoteTypeSheet(BuildContext context) {
  return showModalBottomSheet<RecordingType>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      final l10n = context.l10n;
      final bottom = MediaQuery.viewPaddingOf(context).bottom;

      return SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 8, 20, bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.callNoteSheetTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.callNoteSheetSubtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              _OptionTile(
                icon: Icons.call_received_rounded,
                title: l10n.recordingTypeIncoming,
                subtitle: l10n.callNoteIncomingSubtitle,
                onTap: () => Navigator.pop(context, RecordingType.incomingNote),
              ),
              _OptionTile(
                icon: Icons.call_made_rounded,
                title: l10n.recordingTypeOutgoing,
                subtitle: l10n.callNoteOutgoingSubtitle,
                onTap: () => Navigator.pop(context, RecordingType.outgoingNote),
              ),
              _OptionTile(
                icon: Icons.sticky_note_2_outlined,
                title: l10n.recordingTypeVoice,
                subtitle: l10n.callNoteVoiceSubtitle,
                onTap: () => Navigator.pop(context, RecordingType.voiceNote),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: CircleAvatar(
          backgroundColor: AppColors.chipBackground,
          child: Icon(icon, color: AppColors.crimson),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
