import 'package:flutter/material.dart';

/// Crimson + white palette from the Incoming Call Recorder reference.
abstract final class AppColors {
  static const crimson = Color(0xFF9B1C2E);
  static const crimsonDark = Color(0xFF6E1220);
  static const crimsonDeep = Color(0xFF4A0C16);
  static const crimsonSoft = Color(0x149B1C2E);

  static const primary = crimson;
  static const primaryDark = crimsonDark;
  static const primarySoft = crimsonSoft;
  static const accent = crimson;
  static const ink = Color(0xFF1C1C1C);
  static const inkDeep = crimsonDeep;
  static const inkSoft = crimsonDark;

  static const canvas = Color(0xFFFFFFFF);
  static const background = canvas;
  static const surface = Color(0xFFFFFFFF);
  static const surfaceElevated = Color(0xFFFFFFFF);

  static const splashBackground = crimsonDark;
  static const appBarForeground = Color(0xFFFFFFFF);
  static const statusBar = crimsonDark;
  static const statusBarPurple = crimsonDark;
  static const List<Color> appBarGradient = [crimson, crimsonDark];

  static const border = Color(0xFFF0F0F0);
  static const borderLight = Color(0xFFF7F7F7);
  static const divider = Color(0xFFF2F2F2);

  static const textPrimary = Color(0xFF1C1C1C);
  static const textSecondary = Color(0xFF8A8A8A);
  static const textTertiary = Color(0xFFB0B0B0);
  static const iconMuted = Color(0xFFB8B8B8);

  static const error = Color(0xFFC41E3A);
  static const errorLight = Color(0xFFFFE8EC);
  static const errorBorder = Color(0xFFF5C4CB);
  static const onError = Color(0xFFFFFFFF);

  static const chipBackground = Color(0xFFFDECEE);
  static const infoBannerBackground = Color(0x14FFFFFF);
  static const infoBannerBorder = Color(0x33FFFFFF);
  static const consentBackground = Color(0xFFFDECEE);
  static const consentBorder = Color(0x339B1C2E);
  static const cardShadow = Color(0x0A000000);

  static const teal = crimson;
  static const tealDark = crimsonDark;
  static const tealSoft = crimsonSoft;
  static const tealLight = Color(0xFFC44A5A);
  static const terracotta = crimson;
  static const mint = Color(0xFF2F9E6A);
}
