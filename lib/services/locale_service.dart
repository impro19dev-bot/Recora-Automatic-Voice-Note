import 'package:flutter/foundation.dart';

import '../l10n/app_locale.dart';
import '../l10n/app_strings.dart';
import 'app_preferences_service.dart';

class LocaleService extends ChangeNotifier {
  LocaleService(this._preferences);

  final AppPreferencesService _preferences;
  AppLocale _locale = AppLocale.en;
  bool _isLoaded = false;

  AppLocale get locale => _locale;
  AppStrings get strings => AppStrings(_locale);
  bool get isLoaded => _isLoaded;

  Future<void> load() async {
    _locale = await _preferences.getLocale();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setLocale(AppLocale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await _preferences.setLocale(locale);
    notifyListeners();
  }
}
