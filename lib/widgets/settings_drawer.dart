import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../core/theme/app_colors.dart';
import '../features/info/about_screen.dart';
import '../features/info/privacy_policy_screen.dart';
import '../features/info/recording_consent_screen.dart';
import '../l10n/locale_scope.dart';
import '../services/app_preferences_service.dart';
import '../widgets/app_logo.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({
    super.key,
    this.onRecordingModeChanged,
  });

  final ValueChanged<RecordingModePreference>? onRecordingModeChanged;

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final _preferences = AppPreferencesService();
  RecordingModePreference _recordingMode = RecordingModePreference.manual;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMode();
  }

  Future<void> _loadMode() async {
    final mode = await _preferences.getRecordingMode();
    if (mounted) {
      setState(() {
        _recordingMode = mode;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Drawer(
      width: 320,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(l10n.appName),
          _buildInfoBanner(l10n.drawerSafetyBanner),
          _sectionTitle(l10n.settings),
          _SettingsTile(
            icon: Icons.mic,
            title: l10n.recordingMode,
            subtitle: _isLoading
                ? l10n.loading
                : l10n.recordingModeLabel(_recordingMode),
            onTap: _showRecordingModePicker,
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: l10n.privacyPolicy,
            onTap: () => _openScreen(const PrivacyPolicyScreen()),
          ),
          _SettingsTile(
            icon: Icons.verified_user_outlined,
            title: l10n.recordingConsent,
            onTap: () => _openScreen(const RecordingConsentScreen()),
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: l10n.about,
            onTap: () => _openScreen(const AboutScreen()),
          ),
          _SettingsTile(
            icon: Icons.share_outlined,
            title: l10n.share,
            onTap: _shareApp,
          ),
        ],
      ),
    );
  }

  void _openScreen(Widget screen) {
    Navigator.pop(context);
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Future<void> _shareApp() async {
    final shareText = context.l10n.shareAppText;
    Navigator.pop(context);
    await SharePlus.instance.share(ShareParams(text: shareText));
  }

  Future<void> _showRecordingModePicker() async {
    final l10n = context.l10n;
    final selected = await showModalBottomSheet<RecordingModePreference>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: RecordingModePreference.values
                .map(
                  (mode) => ListTile(
                    title: Text(l10n.recordingModeLabel(mode)),
                    trailing: mode == _recordingMode
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () => Navigator.pop(sheetContext, mode),
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    if (selected != null && mounted) {
      await _preferences.setRecordingMode(selected);
      setState(() => _recordingMode = selected);
      widget.onRecordingModeChanged?.call(selected);
    }
  }

  Widget _buildHeader(String appName) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 24,
        20,
        24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.appBarGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const AppLogo(size: 72, showGlow: true),
          const SizedBox(height: 14),
          Text(
            appName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.appBarForeground,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.chipBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.consentBorder),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.crimson),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: onTap != null
          ? Icon(Icons.chevron_right, color: AppColors.iconMuted)
          : null,
      onTap: onTap,
    );
  }
}
