import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/locale_scope.dart';
import '../../models/recording_item.dart';
import 'recording_type.dart';

Future<RecordingItem?> showLogCallSheet(BuildContext context) {
  return showModalBottomSheet<RecordingItem>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const LogCallSheet(),
  );
}

class LogCallSheet extends StatefulWidget {
  const LogCallSheet({super.key});

  @override
  State<LogCallSheet> createState() => _LogCallSheetState();
}

class _LogCallSheetState extends State<LogCallSheet> {
  final _titleController = TextEditingController();
  final _contactController = TextEditingController();
  final _noteController = TextEditingController();
  RecordingType _type = RecordingType.incomingNote;
  bool _favorite = false;
  bool _ready = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_ready) {
      _titleController.text = context.l10n.recordingTypeLogged;
      _ready = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contactController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    Navigator.pop(
      context,
      RecordingItem(
        id: const Uuid().v4(),
        title: title,
        type: RecordingType.loggedCall,
        duration: Duration.zero,
        createdAt: DateTime.now(),
        filePath: '',
        contactName: _contactController.text.trim().isEmpty
            ? null
            : _contactController.text.trim(),
        note: [
          if (_type != RecordingType.loggedCall)
            context.l10n.recordingTypeBadge(_type),
          if (_noteController.text.trim().isNotEmpty)
            _noteController.text.trim(),
        ].join(' · ').trim(),
        isFavorite: _favorite,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom +
            MediaQuery.viewPaddingOf(context).bottom +
            24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.logCall,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.logCallSubtitle,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: l10n.titleLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(labelText: l10n.contactOptional),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(labelText: l10n.noteOptional),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RecordingType>(
              initialValue: _type,
              decoration: InputDecoration(labelText: l10n.type),
              items: const [
                RecordingType.incomingNote,
                RecordingType.outgoingNote,
                RecordingType.voiceNote,
              ]
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(l10n.recordingTypeTitle(type)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _type = value);
              },
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.addToFavorites),
              value: _favorite,
              activeTrackColor: AppColors.crimson.withValues(alpha: 0.35),
              onChanged: (value) => setState(() => _favorite = value),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _save,
                    child: Text(l10n.save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
