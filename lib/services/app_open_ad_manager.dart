import 'dart:async';

import 'package:multiads/multiads.dart';

import '../util/global.dart';
import 'recording_activity.dart';

/// Presents an App Open ad on cold start and when the app returns
/// from the background. Failures and missing ads never block the app.
class AppOpenAdManager {
  AppOpenAdManager._();

  static final AppOpenAdManager instance = AppOpenAdManager._();

  static const _minInterval = Duration(minutes: 5);
  static const _launchResumeGrace = Duration(seconds: 6);
  static const _loadWait = Duration(seconds: 3);

  bool _coldStartHandled = false;
  bool _isShowing = false;
  DateTime? _lastShownAt;
  DateTime? _launchedAt;

  /// Splash calls this once. Waits briefly for a loaded ad, then continues.
  Future<void> tryShowOnColdStart() async {
    if (_coldStartHandled) return;
    _coldStartHandled = true;
    _launchedAt = DateTime.now();
    await _tryShow(waitForLoad: _loadWait);
  }

  /// Called when the app returns to the foreground.
  Future<void> tryShowOnResume() async {
    if (!_coldStartHandled) return;
    if (_launchedAt != null &&
        DateTime.now().difference(_launchedAt!) < _launchResumeGrace) {
      return;
    }
    await _tryShow(waitForLoad: Duration.zero);
  }

  Future<void> _tryShow({required Duration waitForLoad}) async {
    // Drive `settings.openads` is the only display switch for this format.
    if (!gAdsReady || !gAds.hasAppOpen) return;
    if (_isShowing || isInterShowed || isAppOpenShowing) return;
    if (RecordingActivity.isScreenOpen) return;
    if (_lastShownAt != null &&
        DateTime.now().difference(_lastShownAt!) < _minInterval) {
      return;
    }

    if (!gAds.isAppOpenAdReady && waitForLoad > Duration.zero) {
      final deadline = DateTime.now().add(waitForLoad);
      while (!gAds.isAppOpenAdReady && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        if (RecordingActivity.isScreenOpen) return;
      }
    }
    if (!gAds.isAppOpenAdReady || RecordingActivity.isScreenOpen) return;

    _isShowing = true;
    isAppOpenShowing = true;
    final done = Completer<void>();
    AdCallbacks.onAppOpenDismissed = () {
      if (!done.isCompleted) done.complete();
    };

    try {
      final shown = gAds.showAppOpenAdIfAvailable();
      if (!shown) {
        AdCallbacks.onAppOpenDismissed = null;
        return;
      }
      _lastShownAt = DateTime.now();
      await done.future.timeout(const Duration(seconds: 45), onTimeout: () {});
    } catch (_) {
      AdCallbacks.onAppOpenDismissed = null;
    } finally {
      _isShowing = false;
      isAppOpenShowing = false;
    }
  }
}
