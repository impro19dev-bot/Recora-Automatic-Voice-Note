import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:multiads/multiads.dart';

import '../util/global.dart';
import 'ios_consent_bridge.dart';

/// Fetches Drive ad config, runs UMP, then starts ads only after ATT.
///
/// ATT is requested separately (after splash) and never blocks non-IDFA ads.
abstract final class AdsBootstrapService {
  static const _configUrl =
      'https://drive.google.com/uc?export=download&id=1dLulDz_meor6_fqw6YUIVxZy3jTBjutz';

  static const _admobTestDeviceIds = ['79738754EC81FA5F64972928128B2FFF'];

  static String? _configJson;
  static bool _umpDone = false;
  static bool _adsInitStarted = false;

  /// Download the remote JSON early. Does not initialize the Mobile Ads SDK.
  static Future<void> prefetchConfig() async {
    try {
      final response = await http.get(Uri.parse(_configUrl));
      if (response.statusCode == 200) {
        _configJson = response.body;
      }
    } catch (_) {
      // Config unavailable; app still launches without ads.
    }
  }

  /// Google UMP / GDPR only. Call from splash before navigating away.
  ///
  /// Does not request ATT and does not call [MobileAds.instance.initialize].
  static Future<void> gatherUmpConsent() async {
    if (_umpDone) return;
    UmpConsent.beforePresent = IosConsentBridge.syncUmpPresentationWindow;
    await UmpConsent.gather(testDeviceIds: _admobTestDeviceIds);
    await TrackingGate.refreshGdprAllowsIdfa();
    // If UMP's optional IDFA message already resolved ATT, record it without
    // showing a second prompt later.
    final attStatus = await IosConsentBridge.trackingAuthorizationStatus();
    if (attStatus != 'notDetermined') {
      TrackingGate.idfaAuthorized = attStatus == 'authorized';
    }
    _umpDone = true;
  }

  /// Initialize mediation + load ads after UMP and ATT have finished.
  static Future<void> initializeAdsAfterAtt() async {
    if (gAdsReady || _adsInitStarted) return;
    _adsInitStarted = true;

    if (!_umpDone) {
      await gatherUmpConsent();
    }
    await TrackingGate.refreshGdprAllowsIdfa();

    if (_configJson == null) return;
    if (!await UmpConsent.canRequestAds()) {
      debugPrint('Ad requests skipped until GDPR consent allows them.');
      return;
    }

    try {
      gAds = MultiAds(
        _configJson!,
        config: MultiAdsConfig(
          admobTestDeviceIds: _admobTestDeviceIds,
          facebookTestingId: 'd1a0df1f-2528-4e41-a4d3-1b401ba14f7d',
          // Facebook IDFA still requires TrackingGate.canUseIdfa at init.
          facebookiOSTrackingEnabled: true,
          enableLogs: kDebugMode,
        ),
      );
      await gAds.init();
      if (!await UmpConsent.canRequestAds()) return;
      await gAds.loadAds();
      gAdsReady = true;
      debugPrint(
        'Ads ready (att=${TrackingGate.idfaAuthorized} '
        'gdprIdfa=${TrackingGate.gdprAllowsIdfa} '
        'canUseIdfa=${TrackingGate.canUseIdfa})',
      );
    } catch (e, st) {
      gAdsReady = false;
      _adsInitStarted = false;
      debugPrint('Ads bootstrap failed: $e\n$st');
    }
  }
}
