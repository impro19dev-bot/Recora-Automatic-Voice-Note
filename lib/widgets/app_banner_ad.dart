import 'package:flutter/material.dart';
import 'package:multiads/multiads.dart';

import '../core/theme/app_colors.dart';
import '../util/global.dart';

/// Bottom banner slot controlled only by Drive `settings.banners`.
///
/// Renders nothing when ads are unavailable or the banner fails to load,
/// so core screens stay usable. Waits briefly for post-ATT ads bootstrap.
class AppBannerAd extends StatefulWidget {
  const AppBannerAd({super.key});

  static const Key adKey = ValueKey('app_bottom_banner');

  @override
  State<AppBannerAd> createState() => _AppBannerAdState();
}

class _AppBannerAdState extends State<AppBannerAd> {
  Ads? _bannerAds;
  bool _requested = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerWhenReady();
  }

  Future<void> _loadBannerWhenReady() async {
    for (var i = 0; i < 50; i++) {
      if (!mounted) return;
      if (gAdsReady) break;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    if (!mounted) return;
    _loadBanner();
  }

  void _loadBanner() {
    if (!gAdsReady || !gAds.hasBanners || _requested) return;
    _requested = true;
    try {
      // Keep one network instance for load / show / dispose.
      final ads = gAds.bannerInstance;
      _bannerAds = ads;
      ads.loadBannerAd(() {
        if (mounted) setState(() => _loaded = true);
      }, AppBannerAd.adKey);
    } catch (_) {
      _bannerAds = null;
      _loaded = false;
      _requested = false;
    }
  }

  @override
  void dispose() {
    final ads = _bannerAds;
    if (ads != null) {
      try {
        ads.disposeBanner(AppBannerAd.adKey);
      } catch (_) {}
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ads = _bannerAds;
    if (!gAdsReady || !gAds.hasBanners || !_loaded || ads == null) {
      return const SizedBox.shrink();
    }

    return Material(
      color: AppColors.surface,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(child: ads.getBannerAdWidget(AppBannerAd.adKey)),
      ),
    );
  }
}
