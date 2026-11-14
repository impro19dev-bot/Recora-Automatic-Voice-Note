import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:multiads/multiads.dart';

/// iOS bridges used by UMP presentation and ATT.
///
/// ATT is intentionally separate from GDPR / UMP. UMP may already have driven
/// an IDFA explanation message that resolved ATT; this bridge always reads
/// the live ATT status first and only prompts when it is still notDetermined.
abstract final class IosConsentBridge {
  static const _umpWindowChannel = MethodChannel(
    'com.callrecora.automaticvoice/ump_window',
  );
  static const _attChannel = MethodChannel(
    'com.callrecora.automaticvoice/att',
  );

  static bool _attFlowFinished = false;

  /// Mirrors the UIScene window onto AppDelegate.window so google_mobile_ads
  /// can present the UMP form on iOS.
  static Future<void> syncUmpPresentationWindow() async {
    if (!Platform.isIOS) return;
    for (var attempt = 0; attempt < 20; attempt++) {
      try {
        final ready = await _umpWindowChannel.invokeMethod<bool>('syncWindow');
        if (ready == true) return;
      } on MissingPluginException {
        return;
      } catch (e, st) {
        debugPrint('UMP window sync failed: $e\n$st');
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  /// Current ATT status from the OS (`authorized`, `denied`, …).
  static Future<String> trackingAuthorizationStatus() async {
    if (!Platform.isIOS) return 'authorized';
    try {
      final status = await _attChannel.invokeMethod<String>('status');
      return status ?? 'notDetermined';
    } on MissingPluginException {
      return 'notDetermined';
    } catch (_) {
      return 'notDetermined';
    }
  }

  /// Shows the system ATT prompt only when status is still notDetermined.
  ///
  /// Never blocks ads. Updates [TrackingGate.idfaAuthorized] from the result.
  /// Safe against duplicates: returns immediately if already resolved or if
  /// this process already completed an ATT flow.
  static Future<void> requestTrackingAuthorizationIfNeeded() async {
    if (!Platform.isIOS) {
      TrackingGate.idfaAuthorized = true;
      _attFlowFinished = true;
      return;
    }

    if (_attFlowFinished) {
      await _syncTrackingGateFromOs();
      return;
    }

    try {
      final current = await trackingAuthorizationStatus();
      // UMP's optional IDFA message (or a prior launch) may already have
      // resolved ATT — do not present a second prompt.
      if (current != 'notDetermined') {
        TrackingGate.idfaAuthorized = current == 'authorized';
        _attFlowFinished = true;
        debugPrint('ATT already resolved: $current');
        return;
      }

      final status = await _attChannel.invokeMethod<String>('request');
      TrackingGate.idfaAuthorized = status == 'authorized';
      _attFlowFinished = true;
      debugPrint('ATT status after prompt: $status');
    } on MissingPluginException {
      debugPrint('ATT request skipped: native channel unavailable');
      _attFlowFinished = true;
    } catch (e, st) {
      debugPrint('ATT request skipped: $e\n$st');
      await _syncTrackingGateFromOs();
      _attFlowFinished = true;
    }
  }

  static Future<void> _syncTrackingGateFromOs() async {
    final status = await trackingAuthorizationStatus();
    TrackingGate.idfaAuthorized = status == 'authorized';
  }
}
