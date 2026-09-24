import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/locale_scope.dart';
import '../../models/recording_item.dart';
import 'recording_screen.dart';
import 'recording_type.dart';

class SaveRecordingSheet extends StatefulWidget {
  const SaveRecordingSheet({super.key, required this.session});

  final RecordingSessionResult session;

  @override
  State<SaveRecordingSheet> createState() => _SaveRecordingSheetState();
}

class _SaveRecordingSheetState extends State<SaveRecordingSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _contactController;
  late final TextEditingController _noteController;
  late RecordingType _selectedType;
  bool _isFavorite = false;
  bool _titleInitialized = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.session.type;
    _titleController = TextEditingController();
    _contactController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_titleInitialized) {
      _titleController.text = context.l10n.recordingTypeTitle(_selectedType);
      _titleInitialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contactController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool _isDefaultTitle(String title) {
    final trimmed = title.trim();
    for (final type in RecordingType.values) {
      if (context.l10n.recordingTypeTitle(type) == trimmed) return true;
    }
    return false;
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) return;
    _completeSave();
  }

  void _completeSave() {
    if (!mounted) return;

    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final item = RecordingItem(
      id: const Uuid().v4(),
      title: title,
      type: _selectedType,
      duration: widget.session.duration,
      createdAt: DateTime.now(),
      filePath: widget.session.filePath,
      contactName: _contactController.text.trim().isEmpty
          ? null
          : _contactController.text.trim(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      isFavorite: _isFavorite,
    );

    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom:
            MediaQuery.viewInsetsOf(context).bottom +
            MediaQuery.viewPaddingOf(context).bottom +
            24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.save,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.formatDurationLabel(widget.session.duration),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.titleLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(
                labelText: l10n.contactOptional,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.noteOptional,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RecordingType>(
              initialValue: _selectedType,
              decoration: InputDecoration(
                labelText: l10n.type,
                border: const OutlineInputBorder(),
              ),
              items: RecordingType.values
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(l10n.recordingTypeTitle(type)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedType = value;
                  if (_titleController.text.trim().isEmpty ||
                      _isDefaultTitle(_titleController.text)) {
                    _titleController.text = l10n.recordingTypeTitle(value);
                  }
                });
              },
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.addToFavorites),
              value: _isFavorite,
              onChanged: (value) => setState(() => _isFavorite = value),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(0, 48),
                    ),
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

Future<RecordingItem?> showSaveRecordingSheet(
  BuildContext context,
  RecordingSessionResult session,
) {
  return showModalBottomSheet<RecordingItem>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => SaveRecordingSheet(session: session),
  );
}
