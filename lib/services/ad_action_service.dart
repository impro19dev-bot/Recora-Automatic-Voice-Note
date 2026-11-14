import 'dart:async';

import 'package:multiads/multiads.dart';

import '../util/global.dart';

/// Runs an action after an optional ad.
///
/// Drive `settings.rewards` / `settings.inters` decide whether an ad is
/// attempted. If ads are off, not ready, or fail, the action still runs.
class AdActionService {
  AdActionService._();

  static const _timeout = Duration(seconds: 45);

  static bool get _busy => isInterShowed || isAppOpenShowing;

  static void runWithRewarded(FutureOr<void> Function() action) {
    unawaited(runWithRewardedAsync(() async => action()));
  }

  static Future<void> runWithRewardedAsync(
    FutureOr<void> Function() action,
  ) async {
    if (!gAdsReady || !gAds.hasRewarded || _busy) {
      await action();
      return;
    }

    final dismissed = Completer<void>();
    try {
      gAds.rewardInstance.showRewardAd((_) {
        if (!dismissed.isCompleted) dismissed.complete();
      });
      await dismissed.future.timeout(_timeout, onTimeout: () {});
    } catch (_) {
      // Continue without the ad.
    } finally {
      isInterShowed = false;
    }

    await action();
  }

  static void runWithInterstitial(FutureOr<void> Function() action) {
    unawaited(runWithInterstitialAsync(() async => action()));
  }

  static Future<T> runWithInterstitialAsync<T>(
    Future<T> Function() action,
  ) async {
    if (!gAdsReady || !gAds.hasInterstitials || _busy) {
      return action();
    }

    final dismissed = Completer<void>();
    AdCallbacks.onInterstitialDismissed = () {
      if (!dismissed.isCompleted) dismissed.complete();
    };

    try {
      gAds.interInstance.showInterstitialAd();
      await dismissed.future.timeout(_timeout, onTimeout: () {});
    } catch (_) {
      // Continue without the ad.
    } finally {
      AdCallbacks.onInterstitialDismissed = null;
      isInterShowed = false;
    }

    return action();
  }
}
