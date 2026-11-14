import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/log.dart';

/// Google UMP (User Messaging Platform) — the certified CMP AdMob expects.
///
/// Kept fully separate from Apple ATT / IDFA. This class never requests
/// tracking authorization and never treats an ATT result as GDPR consent.
abstract final class UmpConsent {
  static bool _gathered = false;

  /// Optional host hook (e.g. mirror the UIScene window) before presenting forms.
  static Future<void> Function()? beforePresent;

  /// Updates consent info and shows the Google form when required.
  ///
  /// Safe to call more than once; later calls are no-ops for this process.
  /// Never throws. Times out so launch is not blocked if UMP stalls.
  static Future<void> gather({
    List<String> testDeviceIds = const [],
    Duration timeout = const Duration(seconds: 20),
  }) async {
    if (_gathered) return;
    _gathered = true;

    try {
      await _runBeforePresent();

      final params = ConsentRequestParameters(
        tagForUnderAgeOfConsent: false,
        // Force EEA geography only while debugging so the CMP can be verified.
        consentDebugSettings: kDebugMode && testDeviceIds.isNotEmpty
            ? ConsentDebugSettings(
                debugGeography: DebugGeography.debugGeographyEea,
                testIdentifiers: testDeviceIds,
              )
            : null,
      );

      final updateError = await _requestConsentInfoUpdate(params, timeout);
      if (updateError != null) {
        Log.log(
          'UMP >> consent info update failed: '
          '${updateError.errorCode} ${updateError.message}',
        );
        return;
      }

      await _runBeforePresent();
      FormError? formError;
      await ConsentForm.loadAndShowConsentFormIfRequired((error) {
        formError = error;
      }).timeout(timeout, onTimeout: () {
        Log.log('UMP >> consent form timed out');
      });

      if (formError != null) {
        Log.log(
          'UMP >> consent form error: '
          '${formError!.errorCode} ${formError!.message}',
        );
      } else {
        Log.log('UMP >> consent form finished (or not required)');
      }

      final status = await ConsentInformation.instance.getConsentStatus();
      final canRequest = await ConsentInformation.instance.canRequestAds();
      final privacy = await ConsentInformation.instance
          .getPrivacyOptionsRequirementStatus();
      Log.log(
        'UMP >> status=$status canRequestAds=$canRequest privacyOptions=$privacy',
      );
    } catch (e, st) {
      Log.log('UMP >> gather error: $e\n$st');
    }
  }

  /// Whether the Mobile Ads SDK may request ads after consent gathering.
  static Future<bool> canRequestAds() async {
    try {
      return await ConsentInformation.instance.canRequestAds();
    } catch (e, st) {
      Log.log('UMP >> canRequestAds error: $e\n$st');
      return false;
    }
  }

  /// True when AdMob messaging requires a privacy-options entry point.
  static Future<bool> isPrivacyOptionsRequired() async {
    try {
      final status = await ConsentInformation.instance
          .getPrivacyOptionsRequirementStatus();
      return status == PrivacyOptionsRequirementStatus.required;
    } catch (e, st) {
      Log.log('UMP >> privacy options status error: $e\n$st');
      return false;
    }
  }

  /// Re-opens the UMP privacy options form so the user can change a choice.
  static Future<void> showPrivacyOptionsForm({
    Duration timeout = const Duration(seconds: 20),
  }) async {
    try {
      await _runBeforePresent();
      FormError? formError;
      await ConsentForm.showPrivacyOptionsForm((error) {
        formError = error;
      }).timeout(timeout, onTimeout: () {
        Log.log('UMP >> privacy options timed out');
      });
      if (formError != null) {
        Log.log(
          'UMP >> privacy options error: '
          '${formError!.errorCode} ${formError!.message}',
        );
      }
    } catch (e, st) {
      Log.log('UMP >> privacy options error: $e\n$st');
    }
  }

  static Future<void> _runBeforePresent() async {
    final hook = beforePresent;
    if (hook == null) return;
    try {
      await hook();
    } catch (e, st) {
      Log.log('UMP >> beforePresent error: $e\n$st');
    }
  }

  static Future<FormError?> _requestConsentInfoUpdate(
    ConsentRequestParameters params,
    Duration timeout,
  ) {
    final completer = Completer<FormError?>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () {
        if (!completer.isCompleted) completer.complete(null);
      },
      (FormError error) {
        if (!completer.isCompleted) completer.complete(error);
      },
    );
    return completer.future.timeout(
      timeout,
      onTimeout: () => FormError(
        errorCode: 0,
        message: 'Consent info update timed out',
      ),
    );
  }
}
