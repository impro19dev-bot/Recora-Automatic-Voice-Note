import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/log.dart';

/// Cross-network gate for IDFA / advertiser tracking.
///
/// IDFA-based tracking is allowed only when:
/// 1. Apple ATT is [authorized], and
/// 2. Applicable GDPR / UMP consent permits personalized advertising
///    ([ConsentStatus.obtained] or [ConsentStatus.notRequired]).
///
/// ATT denial never blocks non-IDFA ad requests gated by [UmpConsent.canRequestAds].
abstract final class TrackingGate {
  /// `true` only when Apple ATT status is authorized (or non-iOS).
  static bool idfaAuthorized = false;

  /// `true` when UMP says personalized / IDFA-linked ads are allowed.
  static bool gdprAllowsIdfa = false;

  /// Combined gate used by mediation adapters before enabling IDFA tracking.
  static bool get canUseIdfa => idfaAuthorized && gdprAllowsIdfa;

  /// Refresh [gdprAllowsIdfa] from the current UMP consent status.
  static Future<void> refreshGdprAllowsIdfa() async {
    try {
      final status = await ConsentInformation.instance.getConsentStatus();
      gdprAllowsIdfa = status == ConsentStatus.obtained ||
          status == ConsentStatus.notRequired;
      Log.log(
        'TrackingGate >> consentStatus=$status gdprAllowsIdfa=$gdprAllowsIdfa '
        'att=$idfaAuthorized canUseIdfa=$canUseIdfa',
      );
    } catch (e, st) {
      gdprAllowsIdfa = false;
      Log.log('TrackingGate >> refreshGdprAllowsIdfa error: $e\n$st');
    }
  }
}
