import 'package:flutter/material.dart';

import '../../l10n/locale_scope.dart';
import '../../models/recording_item.dart';
import '../../services/microphone_service.dart';
import '../../services/recording_storage_service.dart';
import '../../services/recordings_repository.dart';
import '../../widgets/permission_dialog.dart';
import 'call_note_type_sheet.dart';
import 'log_call_sheet.dart';
import 'recording_screen.dart';
import 'recording_type.dart';
import 'save_recording_sheet.dart';

class RecordingFlow {
  RecordingFlow({
    required this.repository,
    MicrophoneService? microphone,
    RecordingStorageService? storage,
  })  : _microphone = microphone ?? MicrophoneService(),
        _storage = storage ?? RecordingStorageService();

  final RecordingsRepository repository;
  final MicrophoneService _microphone;
  final RecordingStorageService _storage;

  Future<bool> ensureMicrophone(BuildContext context) async {
    if (await _microphone.hasPermission) return true;
    if (!context.mounted) return false;

    final granted = await showMicrophonePermissionDialog(context, _microphone);
    if (!context.mounted) return false;
    if (granted) return true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.micPermissionRequired)),
    );
    return false;
  }

  Future<void> startMeeting(BuildContext context) async {
    if (!await ensureMicrophone(context) || !context.mounted) return;
    await _openRecorder(context, RecordingType.meeting);
  }

  Future<void> startCallNote(BuildContext context) async {
    final type = await showCallNoteTypeSheet(context);
    if (type == null || !context.mounted) return;
    if (!await ensureMicrophone(context) || !context.mounted) return;
    await _openRecorder(context, type);
  }

  Future<void> startType(BuildContext context, RecordingType type) async {
    if (!type.hasAudio) {
      await logCall(context);
      return;
    }
    if (!await ensureMicrophone(context) || !context.mounted) return;
    await _openRecorder(context, type);
  }

  Future<void> logCall(BuildContext context) async {
    final item = await showLogCallSheet(context);
    if (item == null || !context.mounted) return;
    await repository.addRecording(item);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.callLogged)),
    );
  }

  Future<void> _openRecorder(BuildContext context, RecordingType type) async {
    final session = await Navigator.push<RecordingSessionResult>(
      context,
      MaterialPageRoute(builder: (_) => RecordingScreen(type: type)),
    );
    if (session == null || !context.mounted) return;

    final savedItem = await showSaveRecordingSheet(context, session);
    if (!context.mounted) return;

    if (savedItem == null) {
      await _storage.deleteFile(session.filePath);
      return;
    }

    final fileExists = await _storage.fileExists(savedItem.filePath);
    if (!context.mounted) return;
    if (!fileExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.audioSaveFailed)),
      );
      return;
    }

    await repository.addRecording(savedItem);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.recordingSaved)),
    );
  }

  Future<void> delete(BuildContext context, RecordingItem item) async {
    final deleted = await repository.deleteRecording(item.id);
    if (!deleted || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.recordingDeleted)),
    );
  }

  Future<void> confirmDelete(BuildContext context, RecordingItem item) async {
    final confirmed = await showDeleteRecordingDialog(context);
    if (!confirmed || !context.mounted) return;
    await delete(context, item);
  }
}
