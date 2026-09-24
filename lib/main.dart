import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'l10n/app_locale.dart';
import 'l10n/locale_scope.dart';
import 'services/app_preferences_service.dart';
import 'services/locale_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.crimsonDark,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const RecoraApp());
}

class RecoraApp extends StatefulWidget {
  const RecoraApp({super.key});

  @override
  State<RecoraApp> createState() => _RecoraAppState();
}

class _RecoraAppState extends State<RecoraApp> {
  late final LocaleService _localeService;

  @override
  void initState() {
    super.initState();
    _localeService = LocaleService(AppPreferencesService());
    _localeService.load();
  }

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      localeService: _localeService,
      child: ListenableBuilder(
        listenable: _localeService,
        builder: (context, _) {
          if (!_localeService.isLoaded) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: ColoredBox(
                  color: AppColors.crimsonDark,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appBarForeground,
                    ),
                  ),
                ),
              ),
            );
          }

          return MaterialApp(
            title: 'Recora Automatic Voice Note',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: _localeService.locale.flutterLocale,
            supportedLocales: AppLocale.values
                .map((locale) => locale.flutterLocale)
                .toList(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
