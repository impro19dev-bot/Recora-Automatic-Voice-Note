import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:just_audio/just_audio.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/locale_scope.dart';
import '../../models/recording_item.dart';
import '../../services/audio_player_service.dart';
import '../../services/recording_storage_service.dart';
import '../../services/recordings_repository.dart';
import '../../widgets/permission_dialog.dart';
import 'edit_recording_sheet.dart';

class PlaybackSheet extends StatefulWidget {
  const PlaybackSheet({
    super.key,
    required this.item,
    required this.repository,
    required this.onDeleted,
    required this.onUpdated,
  });

  final RecordingItem item;
  final RecordingsRepository repository;
  final VoidCallback onDeleted;
  final VoidCallback onUpdated;

  @override
  State<PlaybackSheet> createState() => _PlaybackSheetState();
}

class _PlaybackSheetState extends State<PlaybackSheet> {
  final _playerService = AudioPlayerService();
  final _storage = RecordingStorageService();

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<bool>? _playingSub;
  StreamSubscription<PlayerState>? _stateSub;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _fileMissing = false;
  bool _loadFailed = false;
  bool _isSeeking = false;
  double _speed = 1;
  late RecordingItem _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    if (!_item.hasAudio) {
      setState(() => _fileMissing = true);
      return;
    }
    final exists = await _storage.fileExists(_item.filePath);
    if (!mounted) return;

    if (!exists) {
      setState(() => _fileMissing = true);
      return;
    }

    final loaded = await _playerService.load(_item.filePath);
    if (!mounted) return;

    if (!loaded) {
      setState(() => _loadFailed = true);
      return;
    }

    _duration = _playerService.duration ?? _item.duration;

    _positionSub = _playerService.positionStream.listen((position) {
      if (!mounted || _isSeeking) return;
      setState(() => _position = position);
    });

    _durationSub = _playerService.durationStream.listen((duration) {
      if (!mounted || duration == null) return;
      setState(() => _duration = duration);
    });

    _playingSub = _playerService.playingStream.listen((playing) {
      if (!mounted) return;
      setState(() => _isPlaying = playing);
    });

    _stateSub = _playerService.playerStateStream.listen((state) {
      if (!mounted) return;
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
        unawaited(_playerService.seek(Duration.zero));
        unawaited(_playerService.pause());
      }
    });

    setState(() {});
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playingSub?.cancel();
    _stateSub?.cancel();
    unawaited(_playerService.dispose());
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (_fileMissing || _loadFailed) return;
    if (_isPlaying) {
      await _playerService.pause();
    } else {
      await _playerService.play();
    }
  }

  Future<void> _toggleFavorite() async {
    await widget.repository.toggleFavorite(_item.id);
    final updated = widget.repository.findById(_item.id);
    if (updated != null && mounted) {
      setState(() => _item = updated);
      widget.onUpdated();
    }
  }

  Future<void> _edit() async {
    final updated = await showEditRecordingSheet(context, _item);
    if (updated == null || !mounted) return;

    await widget.repository.updateRecording(updated);
    setState(() => _item = updated);
    widget.onUpdated();
  }

  Future<void> _delete() async {
    await _performDelete();
  }

  Future<void> _performDelete() async {
    final confirmed = await showDeleteRecordingDialog(context);
    if (!confirmed || !mounted) return;

    await _playerService.stop();
    final deleted = await widget.repository.deleteRecording(_item.id);
    if (!deleted || !mounted) return;

    widget.onDeleted();
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.recordingDeleted)));
  }

  Future<void> _removeMissingFromList() async {
    await _performRemoveMissing();
  }

  Future<void> _performRemoveMissing() async {
    final deleted = await widget.repository.removeRecordingMetadata(_item.id);
    if (!deleted || !mounted) return;

    widget.onDeleted();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.recordingRemovedFromList)),
    );
  }

  Future<void> _share() async {
    await _performShare();
  }

  Future<void> _performShare() async {
    if (_fileMissing) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.fileNotFound)));
      return;
    }

    final exists = await _storage.fileExists(_item.filePath);
    if (!mounted) return;

    if (!exists) {
      setState(() => _fileMissing = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.fileNotFound)));
      return;
    }

    await SharePlus.instance.share(
      ShareParams(files: [XFile(_item.filePath)], text: _item.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final progress = _duration.inMilliseconds == 0
        ? 0.0
        : _position.inMilliseconds / _duration.inMilliseconds;
    final canPlay = !_fileMissing && !_loadFailed;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.viewPaddingOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              _item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.chipBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.recordingTypeBadge(_item.type),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: l10n.duration,
              value: l10n.formatDuration(_item.duration),
            ),
            _InfoRow(
              label: l10n.date,
              value: l10n.formatRecordingDate(_item.createdAt),
            ),
            if (_item.contactName != null && _item.contactName!.isNotEmpty)
              _InfoRow(label: l10n.contact, value: _item.contactName!),
            if (_item.note != null && _item.note!.isNotEmpty)
              _InfoRow(label: l10n.note, value: _item.note!),
            const SizedBox(height: 16),
            if (_fileMissing) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.errorBorder),
                ),
                child: Text(
                  l10n.audioFileMissing,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.errorBorder),
                ),
                onPressed: _removeMissingFromList,
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.removeFromList),
              ),
            ] else if (_loadFailed) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.errorBorder),
                ),
                child: Text(
                  l10n.playbackFailed,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ] else ...[
              Slider(
                value: progress.clamp(0.0, 1.0),
                activeColor: AppColors.primary,
                onChangeStart: (_) => _isSeeking = true,
                onChanged: (value) {
                  setState(() {
                    _position = Duration(
                      milliseconds: (_duration.inMilliseconds * value).round(),
                    );
                  });
                },
                onChangeEnd: (value) async {
                  final target = Duration(
                    milliseconds: (_duration.inMilliseconds * value).round(),
                  );
                  await _playerService.seek(target);
                  if (mounted) {
                    setState(() => _isSeeking = false);
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.formatDuration(_position),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  Text(
                    l10n.formatDuration(_duration),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final next = _position - const Duration(seconds: 10);
                        await _playerService.seek(
                          next.isNegative ? Duration.zero : next,
                        );
                      },
                      child: Text(l10n.skipBack),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: _togglePlayback,
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      label: Text(_isPlaying ? l10n.pause : l10n.play),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await _playerService.seek(
                          _position + const Duration(seconds: 10),
                        );
                      },
                      child: Text(l10n.skipForward),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [0.75, 1.0, 1.5, 2.0].map((speed) {
                  final selected = _speed == speed;
                  return ChoiceChip(
                    label: Text('${speed}x'),
                    selected: selected,
                    selectedColor: AppColors.crimson,
                    labelStyle: TextStyle(
                      color: selected
                          ? AppColors.appBarForeground
                          : AppColors.textPrimary,
                    ),
                    onSelected: (_) async {
                      await _playerService.setSpeed(speed);
                      setState(() => _speed = speed);
                    },
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.favorite),
              value: _item.isFavorite,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.4),
              activeThumbColor: AppColors.primary,
              onChanged: (_) => _toggleFavorite(),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _edit,
              icon: const Icon(Icons.edit_outlined),
              label: Text(l10n.edit),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                    ),
                    onPressed: canPlay ? _share : null,
                    icon: const Icon(Icons.share_outlined),
                    label: Text(l10n.share),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.error,
                      minimumSize: const Size(0, 48),
                    ),
                    onPressed: _delete,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l10n.delete),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showPlaybackSheet(
  BuildContext context, {
  required RecordingItem item,
  required RecordingsRepository repository,
  required VoidCallback onDeleted,
  required VoidCallback onUpdated,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => PlaybackSheet(
      item: item,
      repository: repository,
      onDeleted: onDeleted,
      onUpdated: onUpdated,
    ),
  );
}
