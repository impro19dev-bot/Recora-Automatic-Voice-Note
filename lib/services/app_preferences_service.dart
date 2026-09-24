import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_locale.dart';

enum RecordingModePreference { manual, meeting, callNote }

enum AudioQualityPreference { low, standard, high }

class AppPreferencesService {
  static const hasSeenOnboardingKey = 'recora_has_seen_safety_onboarding';
  static const recordingModeKey = 'recora_recording_mode_preference';
  static const localeKey = 'recora_app_locale';
  static const audioQualityKey = 'recora_audio_quality';
  static const autoStartKey = 'recora_auto_start_recording';

  static const _legacyModeLabels = {
    'Enregistrement manuel': RecordingModePreference.manual,
    'Réunion': RecordingModePreference.meeting,
    'Note après appel': RecordingModePreference.callNote,
  };

  Future<bool> hasSeenSafetyOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(hasSeenOnboardingKey) ?? false;
  }

  Future<void> setSafetyOnboardingSeen(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(hasSeenOnboardingKey, value);
  }

  Future<RecordingModePreference> getRecordingMode() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(recordingModeKey);
    if (stored == null) return RecordingModePreference.manual;

    for (final mode in RecordingModePreference.values) {
      if (mode.name == stored) return mode;
    }
    return _legacyModeLabels[stored] ?? RecordingModePreference.manual;
  }

  Future<void> setRecordingMode(RecordingModePreference mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(recordingModeKey, mode.name);
  }

  Future<AudioQualityPreference> getAudioQuality() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(audioQualityKey);
    for (final quality in AudioQualityPreference.values) {
      if (quality.name == stored) return quality;
    }
    return AudioQualityPreference.standard;
  }

  Future<void> setAudioQuality(AudioQualityPreference quality) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(audioQualityKey, quality.name);
  }

  Future<bool> getAutoStartRecording() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(autoStartKey) ?? false;
  }

  Future<void> setAutoStartRecording(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(autoStartKey, value);
  }

  Future<AppLocale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return AppLocale.fromCode(prefs.getString(localeKey));
  }

  Future<void> setLocale(AppLocale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(localeKey, locale.code);
  }

  static RecordConfig configFor(AudioQualityPreference quality) {
    switch (quality) {
      case AudioQualityPreference.low:
        return const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 64000,
          sampleRate: 22050,
        );
      case AudioQualityPreference.standard:
        return const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        );
      case AudioQualityPreference.high:
        return const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 192000,
          sampleRate: 48000,
        );
    }
  }
}
