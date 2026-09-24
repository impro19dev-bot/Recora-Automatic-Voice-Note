import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/locale_scope.dart';
import '../../services/app_preferences_service.dart';
import '../../widgets/app_logo.dart';
import '../home/home_screen.dart';

class SafetyOnboardingScreen extends StatefulWidget {
  const SafetyOnboardingScreen({super.key});

  @override
  State<SafetyOnboardingScreen> createState() => _SafetyOnboardingScreenState();
}

class _SafetyOnboardingScreenState extends State<SafetyOnboardingScreen> {
  final _preferences = AppPreferencesService();
  bool _accepted = false;

  Future<void> _continue() async {
    await _preferences.setSafetyOnboardingSeen(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 24, 20, bottomInset + 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: AppLogo(size: 84, showGlow: true)),
                    const SizedBox(height: 20),
                    Text(
                      l10n.appName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.6,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.onboardingTagline,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.45,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _InfoCard(
                      step: '1',
                      icon: Icons.touch_app_outlined,
                      iconColor: AppColors.terracotta,
                      title: l10n.onboardingManualTitle,
                      body: l10n.onboardingManualBody,
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      step: '2',
                      icon: Icons.mic_none_rounded,
                      iconColor: AppColors.teal,
                      title: l10n.onboardingMicTitle,
                      body: l10n.onboardingMicBody,
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      step: '3',
                      icon: Icons.shield_moon_outlined,
                      iconColor: AppColors.ink,
                      title: l10n.onboardingImportantTitle,
                      body: l10n.onboardingImportantBody,
                      emphasized: true,
                    ),
                    const SizedBox(height: 20),
                    Material(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () => setState(() => _accepted = !_accepted),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 48),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _accepted
                                  ? AppColors.teal
                                  : AppColors.border,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _accepted,
                                activeColor: AppColors.teal,
                                onChanged: (value) {
                                  setState(() => _accepted = value ?? false);
                                },
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    l10n.onboardingCheckbox,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.4,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                      onPressed: _accepted ? _continue : null,
                      child: Text(l10n.continueAction),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.step,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    this.emphasized = false,
  });

  final String step;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: emphasized ? AppColors.infoBannerBackground : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: emphasized ? AppColors.infoBannerBorder : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: iconColor.withValues(alpha: 0.12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              Positioned(
                top: -6,
                left: -6,
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: AppColors.ink,
                  child: Text(
                    step,
                    style: const TextStyle(
                      color: AppColors.appBarForeground,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
