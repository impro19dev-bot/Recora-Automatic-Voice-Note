import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'ads_bootstrap_service.dart';
import 'app_open_ad_manager.dart';
import 'ios_consent_bridge.dart';

/// Requests ATT once after the splash route has been replaced.
///
/// Kept separate from UMP. Ads SDK init runs after ATT so measurement / IDFA
/// access happens only after the system prompt when status was notDetermined.
abstract final class AttRequestService {
  static bool _started = false;

  /// Call from the first post-splash screen (home or onboarding).
  static void requestAfterSplashIfNeeded() {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_run());
    });
  }

  static Future<void> _run() async {
    try {
      // Let the route transition finish and ensure no UMP sheet is still up.
      await Future<void>.delayed(const Duration(milliseconds: 600));
      await SchedulerBinding.instance.endOfFrame;

      await IosConsentBridge.requestTrackingAuthorizationIfNeeded();

      // Start Mobile Ads only after UMP + ATT decisions.
      await AdsBootstrapService.initializeAdsAfterAtt();
      await AppOpenAdManager.instance.tryShowOnColdStart();
    } catch (e, st) {
      debugPrint('AttRequestService error: $e\n$st');
    }
  }
}
