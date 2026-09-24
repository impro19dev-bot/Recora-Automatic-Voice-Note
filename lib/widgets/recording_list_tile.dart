import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../features/recording/recording_type.dart';
import '../l10n/locale_scope.dart';
import '../models/recording_item.dart';

class RecordingListTile extends StatelessWidget {
  const RecordingListTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onDelete,
  });

  final RecordingItem item;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDelete;

  IconData get _icon {
    switch (item.type) {
      case RecordingType.meeting:
        return Icons.groups_outlined;
      case RecordingType.incomingNote:
        return Icons.call_received_rounded;
      case RecordingType.outgoingNote:
        return Icons.call_made_rounded;
      case RecordingType.voiceNote:
        return Icons.mic_none_rounded;
      case RecordingType.loggedCall:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subtitle = [
      l10n.recordingTypeBadge(item.type),
      if (item.hasAudio) l10n.formatDuration(item.duration),
      l10n.formatRecordingDate(item.createdAt),
    ].join('  ·  ');

    return ListTile(
      onTap: onTap,
      onLongPress: onDelete,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: AppColors.chipBackground,
        child: Icon(_icon, color: AppColors.crimson),
      ),
      title: Text(
        item.contactName?.isNotEmpty == true ? item.contactName! : item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
      trailing: IconButton(
        tooltip: l10n.favoriteTooltip,
        onPressed: onFavoriteToggle,
        icon: Icon(
          item.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
          color: item.isFavorite ? AppColors.crimson : AppColors.iconMuted,
        ),
      ),
    );
  }
}
