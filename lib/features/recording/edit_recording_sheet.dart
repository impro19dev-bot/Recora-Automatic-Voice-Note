import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/locale_scope.dart';
import '../../models/recording_item.dart';
import 'recording_type.dart';

class EditRecordingSheet extends StatefulWidget {
  const EditRecordingSheet({super.key, required this.item});

  final RecordingItem item;

  @override
  State<EditRecordingSheet> createState() => _EditRecordingSheetState();
}

class _EditRecordingSheetState extends State<EditRecordingSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _contactController;
  late final TextEditingController _noteController;
  late RecordingType _selectedType;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.item.type;
    _isFavorite = widget.item.isFavorite;
    _titleController = TextEditingController(text: widget.item.title);
    _contactController = TextEditingController(
      text: widget.item.contactName ?? '',
    );
    _noteController = TextEditingController(text: widget.item.note ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contactController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) return;
    _completeSave();
  }

  void _completeSave() {
    if (!mounted) return;

    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final contact = _contactController.text.trim();
    final note = _noteController.text.trim();

    final updated = RecordingItem(
      id: widget.item.id,
      title: title,
      type: _selectedType,
      duration: widget.item.duration,
      createdAt: widget.item.createdAt,
      filePath: widget.item.filePath,
      contactName: contact.isEmpty ? null : contact,
      note: note.isEmpty ? null : note,
      isFavorite: _isFavorite,
    );

    Navigator.pop(context, updated);
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
              l10n.edit,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.formatDurationLabel(widget.item.duration),
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
                labelText: l10n.contact,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.note,
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
                setState(() => _selectedType = value);
              },
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.favorite),
              value: _isFavorite,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.4),
              activeThumbColor: AppColors.primary,
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

Future<RecordingItem?> showEditRecordingSheet(
  BuildContext context,
  RecordingItem item,
) {
  return showModalBottomSheet<RecordingItem>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => EditRecordingSheet(item: item),
  );
}
