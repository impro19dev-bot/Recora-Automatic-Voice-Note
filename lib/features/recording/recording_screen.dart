import 'dart:async';

import 'package:flutter/material.dart';
import 'package:record/record.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/locale_scope.dart';
import '../../services/app_preferences_service.dart';
import '../../services/recording_storage_service.dart';
import 'recording_type.dart';

class RecordingSessionResult {
  RecordingSessionResult({
    required this.filePath,
    required this.duration,
    required this.type,
  });

  final String filePath;
  final Duration duration;
  final RecordingType type;
}

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key, required this.type});

  final RecordingType type;

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final _recorder = AudioRecorder();
  final _storage = RecordingStorageService();
  final _preferences = AppPreferencesService();
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isBusy = false;
  String? _filePath;
  AudioQualityPreference _quality = AudioQualityPreference.standard;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    final quality = await _preferences.getAudioQuality();
    final autoStart = await _preferences.getAutoStartRecording();
    if (!mounted) return;
    setState(() => _quality = quality);
    if (autoStart) await _startRecording();
  }

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_recorder.stop());
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (_isBusy || _isRecording) return;
    setState(() => _isBusy = true);
    try {
      if (!await _recorder.hasPermission()) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.micPermissionShort)),
        );
        return;
      }

      final path = await _storage.createRecordingPath();
      await _recorder.start(AppPreferencesService.configFor(_quality), path: path);
      if (!mounted) return;
      setState(() {
        _isRecording = true;
        _isPaused = false;
        _elapsed = Duration.zero;
        _filePath = path;
      });
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || _isPaused) return;
        setState(() => _elapsed += const Duration(seconds: 1));
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.recordingStartFailed)),
      );
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _togglePause() async {
    if (!_isRecording || _isBusy) return;
    setState(() => _isBusy = true);
    try {
      if (_isPaused) {
        await _recorder.resume();
        setState(() => _isPaused = false);
      } else {
        await _recorder.pause();
        setState(() => _isPaused = true);
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _stopRecording() async {
    setState(() => _isBusy = true);
    _timer?.cancel();
    try {
      await _recorder.stop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.recordingStopFailed)),
        );
      }
      return;
    } finally {
      if (mounted) {
        setState(() {
          _isRecording = false;
          _isPaused = false;
          _isBusy = false;
        });
      }
    }

    if (!mounted) return;
    final path = _filePath;
    if (path == null) return;
    final messenger = ScaffoldMessenger.of(context);
    final fileExists = await _storage.fileExists(path);
    if (!mounted) return;
    if (!fileExists || _elapsed.inSeconds < 1) {
      await _storage.deleteFile(path);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(context.l10n.recordingTooShort)),
      );
      return;
    }

    Navigator.pop(
      context,
      RecordingSessionResult(
        filePath: path,
        duration: _elapsed,
        type: widget.type,
      ),
    );
  }

  Future<void> _handleBack() async {
    if (!_isRecording) {
      if (mounted) Navigator.pop(context);
      return;
    }
    final l10n = context.l10n;
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.recordingInProgress),
        content: Text(l10n.stopAndLeave),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.continueAction),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.leave),
          ),
        ],
      ),
    );
    if (shouldLeave != true || !mounted) return;
    _timer?.cancel();
    await _recorder.stop();
    if (_filePath != null) await _storage.deleteFile(_filePath!);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = l10n.recordingTypeTitle(widget.type);

    return PopScope(
      canPop: !_isRecording,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) await _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _handleBack,
          ),
          title: Text(title),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 148,
                height: 148,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.chipBackground,
                  border: Border.all(color: AppColors.crimson, width: 3),
                ),
                child: Icon(
                  _isPaused
                      ? Icons.pause_rounded
                      : _isRecording
                          ? Icons.graphic_eq_rounded
                          : Icons.mic_none_rounded,
                  size: 56,
                  color: AppColors.crimson,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _format(_elapsed),
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.qualityLabel(_quality),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.consentBeforeRecord,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              if (_isRecording)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isBusy ? null : _togglePause,
                        child: Text(_isPaused ? l10n.resume : l10n.pause),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        onPressed: _isBusy ? null : _stopRecording,
                        child: Text(l10n.stop),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isBusy ? null : _startRecording,
                    child: Text(l10n.start),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _format(Duration duration) {
    final minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
