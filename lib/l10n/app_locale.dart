import 'package:flutter/material.dart';

enum AppLocale {
  en('en', 'English'),
  fr('fr', 'Français'),
  ar('ar', 'العربية'),
  es('es', 'Español');

  const AppLocale(this.code, this.displayName);

  final String code;
  final String displayName;

  Locale get flutterLocale => Locale(code);

  static AppLocale fromCode(String? code) {
    if (code == null) return AppLocale.en;
    for (final locale in AppLocale.values) {
      if (locale.code == code) return locale;
    }
    return AppLocale.en;
  }
}
