import 'dart:io';

import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  AudioPlayerService() : _player = AudioPlayer();

  final AudioPlayer _player;
  bool _hasError = false;

  bool get hasError => _hasError;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<bool> get playingStream => _player.playingStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Duration get position => _player.position;
  Duration? get duration => _player.duration;
  bool get isPlaying => _player.playing;

  Future<bool> load(String filePath) async {
    _hasError = false;
    try {
      if (!await File(filePath).exists()) {
        _hasError = true;
        return false;
      }
      await _player.setFilePath(filePath);
      return true;
    } catch (_) {
      _hasError = true;
      return false;
    }
  }

  Future<void> play() async {
    if (_hasError) return;
    await _player.play();
  }

  Future<void> pause() => _player.pause();

  Future<void> stop() => _player.stop();

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  Future<void> dispose() => _player.dispose();
}
