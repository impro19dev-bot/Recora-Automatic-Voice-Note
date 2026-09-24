import 'package:flutter/material.dart';

import '../services/locale_service.dart';
import 'app_strings.dart';

class LocaleScope extends InheritedNotifier<LocaleService> {
  const LocaleScope({
    super.key,
    required LocaleService localeService,
    required super.child,
  }) : super(notifier: localeService);

  static LocaleService serviceOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope not found in widget tree');
    return scope!.notifier!;
  }

  static AppStrings of(BuildContext context) => serviceOf(context).strings;
}

extension L10nContext on BuildContext {
  AppStrings get l10n => LocaleScope.of(this);
}
