import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../features/info/about_screen.dart';
import '../../features/info/privacy_policy_screen.dart';
import '../../features/info/recording_consent_screen.dart';
import '../../l10n/locale_scope.dart';
import '../../services/app_preferences_service.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/language_selector.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.onRecordingModeChanged});

  final ValueChanged<RecordingModePreference>? onRecordingModeChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _preferences = AppPreferencesService();
  RecordingModePreference _mode = RecordingModePreference.manual;
  AudioQualityPreference _quality = AudioQualityPreference.standard;
  bool _autoStart = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final mode = await _preferences.getRecordingMode();
    final quality = await _preferences.getAudioQuality();
    final autoStart = await _preferences.getAutoStartRecording();
    if (!mounted) return;
    setState(() {
      _mode = mode;
      _quality = quality;
      _autoStart = autoStart;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                const Center(child: AppLogo(size: 72)),
                const SizedBox(height: 10),
                Text(
                  l10n.appName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                _card([
                  ListTile(
                    title: Text(l10n.recordingMode),
                    subtitle: Text(l10n.recordingModeLabel(_mode)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _pickMode,
                  ),
                  ListTile(
                    title: Text(l10n.audioQuality),
                    subtitle: Text(l10n.qualityLabel(_quality)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _pickQuality,
                  ),
                  SwitchListTile.adaptive(
                    title: Text(l10n.autoStart),
                    subtitle: Text(l10n.autoStartBody),
                    value: _autoStart,
                    activeTrackColor: AppColors.crimson.withValues(alpha: 0.4),
                    onChanged: (value) async {
                      await _preferences.setAutoStartRecording(value);
                      setState(() => _autoStart = value);
                    },
                  ),
                  ListTile(
                    title: Text(l10n.language),
                    onTap: () => showLanguageSelector(context),
                  ),
                ]),
                const SizedBox(height: 12),
                _card([
                  ListTile(
                    title: Text(l10n.privacyPolicy),
                    onTap: () => _open(const PrivacyPolicyScreen()),
                  ),
                  ListTile(
                    title: Text(l10n.recordingConsent),
                    onTap: () => _open(const RecordingConsentScreen()),
                  ),
                  ListTile(
                    title: Text(l10n.about),
                    onTap: () => _open(const AboutScreen()),
                  ),
                  ListTile(
                    title: Text(l10n.share),
                    onTap: () => SharePlus.instance.share(
                      ShareParams(text: l10n.shareAppText),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                Text(
                  l10n.drawerSafetyBanner,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _card(List<Widget> children) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }

  void _open(Widget screen) {
    Navigator.push<void>(context, MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _pickMode() async {
    final selected = await showModalBottomSheet<RecordingModePreference>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: RecordingModePreference.values
              .map(
                (mode) => ListTile(
                  title: Text(context.l10n.recordingModeLabel(mode)),
                  trailing: mode == _mode
                      ? const Icon(Icons.check, color: AppColors.crimson)
                      : null,
                  onTap: () => Navigator.pop(sheetContext, mode),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (selected == null) return;
    await _preferences.setRecordingMode(selected);
    setState(() => _mode = selected);
    widget.onRecordingModeChanged?.call(selected);
  }

  Future<void> _pickQuality() async {
    final selected = await showModalBottomSheet<AudioQualityPreference>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: AudioQualityPreference.values
              .map(
                (quality) => ListTile(
                  title: Text(context.l10n.qualityLabel(quality)),
                  trailing: quality == _quality
                      ? const Icon(Icons.check, color: AppColors.crimson)
                      : null,
                  onTap: () => Navigator.pop(sheetContext, quality),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (selected == null) return;
    await _preferences.setAudioQuality(selected);
    setState(() => _quality = selected);
  }
}
