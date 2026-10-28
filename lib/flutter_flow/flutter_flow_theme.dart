// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

const kThemeModeKey = '__theme_mode__';

SharedPreferences? _prefs;

abstract class FlutterFlowTheme {
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();

  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.system
        : darkMode
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
      ? _prefs?.remove(kThemeModeKey)
      : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static FlutterFlowTheme of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? DarkModeTheme()
        : LightModeTheme();
  }

  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary;
  late Color secondary;
  late Color tertiary;
  late Color alternate;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color accent1;
  late Color accent2;
  late Color accent3;
  late Color accent4;
  late Color success;
  late Color warning;
  late Color error;
  late Color info;

  @Deprecated('Use displaySmallFamily instead')
  String get title1Family => displaySmallFamily;
  @Deprecated('Use displaySmall instead')
  TextStyle get title1 => typography.displaySmall;
  @Deprecated('Use headlineMediumFamily instead')
  String get title2Family => typography.headlineMediumFamily;
  @Deprecated('Use headlineMedium instead')
  TextStyle get title2 => typography.headlineMedium;
  @Deprecated('Use headlineSmallFamily instead')
  String get title3Family => typography.headlineSmallFamily;
  @Deprecated('Use headlineSmall instead')
  TextStyle get title3 => typography.headlineSmall;
  @Deprecated('Use titleMediumFamily instead')
  String get subtitle1Family => typography.titleMediumFamily;
  @Deprecated('Use titleMedium instead')
  TextStyle get subtitle1 => typography.titleMedium;
  @Deprecated('Use titleSmallFamily instead')
  String get subtitle2Family => typography.titleSmallFamily;
  @Deprecated('Use titleSmall instead')
  TextStyle get subtitle2 => typography.titleSmall;
  @Deprecated('Use bodyMediumFamily instead')
  String get bodyText1Family => typography.bodyMediumFamily;
  @Deprecated('Use bodyMedium instead')
  TextStyle get bodyText1 => typography.bodyMedium;
  @Deprecated('Use bodySmallFamily instead')
  String get bodyText2Family => typography.bodySmallFamily;
  @Deprecated('Use bodySmall instead')
  TextStyle get bodyText2 => typography.bodySmall;

  String get displayLargeFamily => typography.displayLargeFamily;
  bool get displayLargeIsCustom => typography.displayLargeIsCustom;
  TextStyle get displayLarge => typography.displayLarge;
  String get displayMediumFamily => typography.displayMediumFamily;
  bool get displayMediumIsCustom => typography.displayMediumIsCustom;
  TextStyle get displayMedium => typography.displayMedium;
  String get displaySmallFamily => typography.displaySmallFamily;
  bool get displaySmallIsCustom => typography.displaySmallIsCustom;
  TextStyle get displaySmall => typography.displaySmall;
  String get headlineLargeFamily => typography.headlineLargeFamily;
  bool get headlineLargeIsCustom => typography.headlineLargeIsCustom;
  TextStyle get headlineLarge => typography.headlineLarge;
  String get headlineMediumFamily => typography.headlineMediumFamily;
  bool get headlineMediumIsCustom => typography.headlineMediumIsCustom;
  TextStyle get headlineMedium => typography.headlineMedium;
  String get headlineSmallFamily => typography.headlineSmallFamily;
  bool get headlineSmallIsCustom => typography.headlineSmallIsCustom;
  TextStyle get headlineSmall => typography.headlineSmall;
  String get titleLargeFamily => typography.titleLargeFamily;
  bool get titleLargeIsCustom => typography.titleLargeIsCustom;
  TextStyle get titleLarge => typography.titleLarge;
  String get titleMediumFamily => typography.titleMediumFamily;
  bool get titleMediumIsCustom => typography.titleMediumIsCustom;
  TextStyle get titleMedium => typography.titleMedium;
  String get titleSmallFamily => typography.titleSmallFamily;
  bool get titleSmallIsCustom => typography.titleSmallIsCustom;
  TextStyle get titleSmall => typography.titleSmall;
  String get labelLargeFamily => typography.labelLargeFamily;
  bool get labelLargeIsCustom => typography.labelLargeIsCustom;
  TextStyle get labelLarge => typography.labelLarge;
  String get labelMediumFamily => typography.labelMediumFamily;
  bool get labelMediumIsCustom => typography.labelMediumIsCustom;
  TextStyle get labelMedium => typography.labelMedium;
  String get labelSmallFamily => typography.labelSmallFamily;
  bool get labelSmallIsCustom => typography.labelSmallIsCustom;
  TextStyle get labelSmall => typography.labelSmall;
  String get bodyLargeFamily => typography.bodyLargeFamily;
  bool get bodyLargeIsCustom => typography.bodyLargeIsCustom;
  TextStyle get bodyLarge => typography.bodyLarge;
  String get bodyMediumFamily => typography.bodyMediumFamily;
  bool get bodyMediumIsCustom => typography.bodyMediumIsCustom;
  TextStyle get bodyMedium => typography.bodyMedium;
  String get bodySmallFamily => typography.bodySmallFamily;
  bool get bodySmallIsCustom => typography.bodySmallIsCustom;
  TextStyle get bodySmall => typography.bodySmall;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends FlutterFlowTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFF164B7E);
  late Color secondary = const Color(0xFF2B9AB5);
  late Color tertiary = const Color(0xFFF59E0B);
  late Color alternate = const Color(0xFFE3E8EE);
  late Color primaryText = const Color(0xFF1B2733);
  late Color secondaryText = const Color(0xFF5B6B7B);
  late Color primaryBackground = const Color(0xFFF6F8FA);
  late Color secondaryBackground = const Color(0xFFFFFFFF);
  late Color accent1 = const Color(0x33164B7E);
  late Color accent2 = const Color(0x332B9AB5);
  late Color accent3 = const Color(0x33F59E0B);
  late Color accent4 = const Color(0xCCFFFFFF);
  late Color success = const Color(0xFF2E9E6B);
  late Color warning = const Color(0xFFF59E0B);
  late Color error = const Color(0xFFD64545);
  late Color info = const Color(0xFFFFFFFF);
}

abstract class Typography {
  String get displayLargeFamily;
  bool get displayLargeIsCustom;
  TextStyle get displayLarge;
  String get displayMediumFamily;
  bool get displayMediumIsCustom;
  TextStyle get displayMedium;
  String get displaySmallFamily;
  bool get displaySmallIsCustom;
  TextStyle get displaySmall;
  String get headlineLargeFamily;
  bool get headlineLargeIsCustom;
  TextStyle get headlineLarge;
  String get headlineMediumFamily;
  bool get headlineMediumIsCustom;
  TextStyle get headlineMedium;
  String get headlineSmallFamily;
  bool get headlineSmallIsCustom;
  TextStyle get headlineSmall;
  String get titleLargeFamily;
  bool get titleLargeIsCustom;
  TextStyle get titleLarge;
  String get titleMediumFamily;
  bool get titleMediumIsCustom;
  TextStyle get titleMedium;
  String get titleSmallFamily;
  bool get titleSmallIsCustom;
  TextStyle get titleSmall;
  String get labelLargeFamily;
  bool get labelLargeIsCustom;
  TextStyle get labelLarge;
  String get labelMediumFamily;
  bool get labelMediumIsCustom;
  TextStyle get labelMedium;
  String get labelSmallFamily;
  bool get labelSmallIsCustom;
  TextStyle get labelSmall;
  String get bodyLargeFamily;
  bool get bodyLargeIsCustom;
  TextStyle get bodyLarge;
  String get bodyMediumFamily;
  bool get bodyMediumIsCustom;
  TextStyle get bodyMedium;
  String get bodySmallFamily;
  bool get bodySmallIsCustom;
  TextStyle get bodySmall;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final FlutterFlowTheme theme;

  String get displayLargeFamily => kUseAeonikPro ? 'Aeonik Pro' : 'Manrope';
  bool get displayLargeIsCustom => false;
  TextStyle get displayLarge => fcHeadline(
    color: theme.primaryText,
    fontWeight: FontWeight.w800,
    fontSize: 64.0,
    letterSpacing: -1.5, // Tight, premium spacing
    height: 1.1, // Compact line height
  );
  String get displayMediumFamily => kUseAeonikPro ? 'Aeonik Pro' : 'Manrope';
  bool get displayMediumIsCustom => false;
  TextStyle get displayMedium => fcHeadline(
    color: theme.primaryText,
    fontWeight: FontWeight.w800,
    fontSize: 44.0,
    letterSpacing: -1.0,
    height: 1.2,
  );
  String get displaySmallFamily => kUseAeonikPro ? 'Aeonik Pro' : 'Manrope';
  bool get displaySmallIsCustom => false;
  TextStyle get displaySmall => fcHeadline(
    color: theme.primaryText,
    fontWeight: FontWeight.w700,
    fontSize: 36.0,
    letterSpacing: -0.8,
    height: 1.2,
  );
  String get headlineLargeFamily => kUseAeonikPro ? 'Aeonik Pro' : 'Manrope';
  bool get headlineLargeIsCustom => false;
  TextStyle get headlineLarge => fcHeadline(
    color: theme.primaryText,
    fontWeight: FontWeight.w700,
    fontSize: 32.0,
    letterSpacing: -0.5,
    height: 1.3,
  );
  String get headlineMediumFamily => kUseAeonikPro ? 'Aeonik Pro' : 'Manrope';
  bool get headlineMediumIsCustom => false;
  TextStyle get headlineMedium => fcHeadline(
    color: theme.primaryText,
    fontWeight: FontWeight.w700,
    fontSize: 28.0,
    letterSpacing: -0.4,
    height: 1.3,
  );
  String get headlineSmallFamily => kUseAeonikPro ? 'Aeonik Pro' : 'Manrope';
  bool get headlineSmallIsCustom => false;
  TextStyle get headlineSmall => fcHeadline(
    color: theme.primaryText,
    fontWeight: FontWeight.w700,
    fontSize: 24.0,
    letterSpacing: -0.2,
    height: 1.4,
  );
  String get titleLargeFamily => 'Inter';
  bool get titleLargeIsCustom => false;
  TextStyle get titleLarge => GoogleFonts.inter(
    color: theme.primaryText,
    fontWeight: FontWeight.w700,
    fontSize: 20.0,
    letterSpacing: 0.0, // Neutral at medium sizes
    height: 1.4,
  );
  String get titleMediumFamily => 'Inter';
  bool get titleMediumIsCustom => false;
  TextStyle get titleMedium => GoogleFonts.inter(
    color: theme.primaryText,
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
    letterSpacing: 0.0,
    height: 1.5,
  );
  String get titleSmallFamily => 'Inter';
  bool get titleSmallIsCustom => false;
  TextStyle get titleSmall => GoogleFonts.inter(
    color: theme.primaryText,
    fontWeight: FontWeight.w700,
    fontSize: 16.0,
    letterSpacing: 0.1, // Slight expansion for smaller sizes
    height: 1.5,
  );
  String get labelLargeFamily => 'Inter';
  bool get labelLargeIsCustom => false;
  TextStyle get labelLarge => GoogleFonts.inter(
    color: theme.secondaryText,
    fontWeight: FontWeight.w500, // Medium weight for clarity
    fontSize: 16.0,
    letterSpacing: 0.15,
    height: 1.6,
  );
  String get labelMediumFamily => 'Inter';
  bool get labelMediumIsCustom => false;
  TextStyle get labelMedium => GoogleFonts.inter(
    color: theme.secondaryText,
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    letterSpacing: 0.2,
    height: 1.6,
  );
  String get labelSmallFamily => 'Inter';
  bool get labelSmallIsCustom => false;
  TextStyle get labelSmall => GoogleFonts.inter(
    color: theme.secondaryText,
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
    letterSpacing: 0.3,
    height: 1.6,
  );
  String get bodyLargeFamily => 'Inter';
  bool get bodyLargeIsCustom => false;
  TextStyle get bodyLarge => GoogleFonts.inter(
    color: theme.primaryText,
    fontWeight: FontWeight.w400, // Regular for body text
    fontSize: 16.0,
    letterSpacing: 0.15,
    height: 1.6, // Generous for readability
  );
  String get bodyMediumFamily => 'Inter';
  bool get bodyMediumIsCustom => false;
  TextStyle get bodyMedium => GoogleFonts.inter(
    color: theme.primaryText,
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    letterSpacing: 0.2,
    height: 1.6,
  );
  String get bodySmallFamily => 'Inter';
  bool get bodySmallIsCustom => false;
  TextStyle get bodySmall => GoogleFonts.inter(
    color: theme.primaryText,
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    letterSpacing: 0.3,
    height: 1.6,
  );
}

class DarkModeTheme extends FlutterFlowTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFF5CC3DC);
  late Color secondary = const Color(0xFF2B9AB5);
  late Color tertiary = const Color(0xFFF5B342);
  late Color alternate = const Color(0xFF26333F);
  late Color primaryText = const Color(0xFFF1F5F9);
  late Color secondaryText = const Color(0xFF9AA9B8);
  late Color primaryBackground = const Color(0xFF0F1A24);
  late Color secondaryBackground = const Color(0xFF16232F);
  late Color accent1 = const Color(0x4C5CC3DC);
  late Color accent2 = const Color(0x4D2B9AB5);
  late Color accent3 = const Color(0x4DF5B342);
  late Color accent4 = const Color(0xB226333F);
  late Color success = const Color(0xFF4CBF8B);
  late Color warning = const Color(0xFFF5B342);
  late Color error = const Color(0xFFFF7A7A);
  late Color info = const Color(0xFF0B2236);
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    TextStyle? font,
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = false,
    TextDecoration? decoration,
    double? lineHeight,
    List<Shadow>? shadows,
    String? package,
  }) {
    if (useGoogleFonts && fontFamily != null) {
      font = GoogleFonts.getFont(
        fontFamily,
        fontWeight: fontWeight ?? this.fontWeight,
        fontStyle: fontStyle ?? this.fontStyle,
      );
    }

    return font != null
        ? font.copyWith(
            color: color ?? this.color,
            fontSize: fontSize ?? this.fontSize,
            letterSpacing: letterSpacing ?? this.letterSpacing,
            fontWeight: fontWeight ?? this.fontWeight,
            fontStyle: fontStyle ?? this.fontStyle,
            decoration: decoration,
            height: lineHeight,
            shadows: shadows,
          )
        : copyWith(
            fontFamily: fontFamily,
            package: package,
            color: color,
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            decoration: decoration,
            height: lineHeight,
            shadows: shadows,
          );
  }
}

/// Brand neutrals and status colors for screens that use fixed colors.
const Color kFcPrimary = Color(0xFF164B7E);
const Color kFcInk = Color(0xFF1B2733);
const Color kFcMuted = Color(0xFF5B6B7B);
const Color kFcSubtle = Color(0xFFAAB7C4);
const Color kFcLine = Color(0xFFE3E8EE);
const Color kFcSurface = Color(0xFFF6F8FA);
const Color kFcTint = Color(0xFFEAF4F8);
const Color kFcSuccess = Color(0xFF2E9E6B);
const Color kFcWarning = Color(0xFFF59E0B);
const Color kFcDanger = Color(0xFFD64545);

/// Headline font, Revolut-style: a geometric grotesk for headlines, Inter for
/// body and UI. Aeonik Pro is a paid font; Manrope stands in for it. To use
/// the real thing, add the licensed files under assets/fonts, declare the
/// family "Aeonik Pro" in pubspec.yaml and set this to true.
const bool kUseAeonikPro = false;

TextStyle fcHeadline({
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? height,
  double? letterSpacing,
}) {
  if (kUseAeonikPro) {
    return TextStyle(
      fontFamily: 'Aeonik Pro',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
  return GoogleFonts.manrope(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}
