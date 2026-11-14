import '../constants/networks.dart';

/// Display switches from the Drive JSON `settings` object only.
///
/// Used:
/// - `openads`: network name (e.g. `"admob"`) or `"false"` / empty to disable
/// - `banners` / `inters` / `natives` / `rewards`: list of network names
///
/// Ignored (never control display):
/// - nested blocks such as `settings.admob.open`, `settings.applovin.banner`
class AdsSettings {
  final String openads;
  final List<String> banners;
  final List<String> inters;
  final List<String> natives;
  final List<String> rewards;

  AdsSettings.fromJson(Map<String, dynamic> json)
    : openads = _parseOpenAds(json['openads']),
      banners = _parseNetworkList(json['banners']),
      inters = _parseNetworkList(json['inters']),
      natives = _parseNetworkList(json['natives']),
      rewards = _parseNetworkList(json['rewards']);

  /// `false`, empty list, missing, or `"false"` → disabled.
  /// Only known network names are kept.
  static List<String> _parseNetworkList(dynamic value) {
    if (value == false || value == null) return [];
    if (value is bool) return [];
    if (value is String) {
      final network = _networkOrEmpty(value);
      return network.isEmpty ? [] : [network];
    }
    if (value is List) {
      return value
          .where((e) => e != false && e != null)
          .map((e) => _networkOrEmpty(e.toString()))
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return [];
  }

  /// Only an explicit known network enables App Open ads.
  static String _parseOpenAds(dynamic value) {
    if (value == false || value == null) return '';
    if (value is bool) return '';
    if (value is String) return _networkOrEmpty(value);
    return '';
  }

  static String _networkOrEmpty(String value) {
    final trimmed = value.trim().toLowerCase();
    if (trimmed.isEmpty ||
        trimmed == 'false' ||
        trimmed == '0' ||
        trimmed == 'none') {
      return '';
    }
    if (!_knownNetworks.contains(trimmed)) return '';
    return trimmed;
  }

  static const _knownNetworks = [
    Networks.admob,
    Networks.applovin,
    Networks.facebook,
    Networks.ironsource,
  ];
}
