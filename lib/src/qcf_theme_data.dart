import 'package:flutter/material.dart';

/// Comprehensive theme configuration for QCF Quran widgets.
///
/// This class allows developers to customize every visual aspect of the Quran
/// rendering, including colors, spacing, backgrounds, and component visibility.
///
/// Example:
/// ```dart
/// final darkTheme = QcfThemeData(
///   verseTextColor: Colors.white,
///   verseNumberColor: Colors.amber,
///   pageBackgroundColor: Colors.black87,
///   basmalaColor: Colors.white70,
/// );
///
/// PageviewQuran(
///   theme: darkTheme,
///   initialPageNumber: 1,
/// )
/// ```
class QcfThemeData {
  // ============ Text Colors ============

  /// Color for verse text (Arabic Quran text).
  /// Default: `Color(0xFF000000)` (black)
  final Color verseTextColor;

  /// Color for verse number symbols.
  /// Default: `Color(0xFF8B4513)` (brown)
  final Color verseNumberColor;

  /// Color for Basmala text.
  /// Default: `Colors.black`
  final Color basmalaColor;

  /// Color for surah header text.
  /// Default: `Colors.black`
  final Color headerTextColor;

  // ============ Background Colors ============

  /// Background color for the entire page.
  /// Default: `Color(0xFFFFFFFF)` (white)
  final Color pageBackgroundColor;

  /// Optional callback to provide background color for individual verses.
  /// Useful for highlighting selected verses or search results.
  ///
  /// Returns a Color for the verse, or null for no background.
  ///
  /// Example:
  /// ```dart
  /// verseBackgroundColor: (surah, verse) {
  ///   if (surah == 2 && verse == 255) return Colors.yellow.shade100;
  ///   return null;
  /// }
  /// ```
  final Color? Function(int surahNumber, int verseNumber)? verseBackgroundColor;

  /// Background color for verse number symbols.
  /// Default: `null` (transparent)
  final Color? verseNumberBackgroundColor;

  /// Background color for surah headers.
  /// Default: `null` (transparent)
  final Color? headerBackgroundColor;

  // ============ Spacing & Layout ============

  /// Horizontal padding for page content.
  /// Default: `12.0`
  final double horizontalPadding;

  /// Vertical padding for page content.
  /// Default: `12.0`
  final double verticalPadding;

  /// Height multiplier for verse text lines.
  /// Lower values = tighter line spacing, higher values = looser spacing.
  /// Default: `2.2`
  final double verseHeight;

  /// Height multiplier for verse number symbols.
  /// Default: `1.35`
  final double verseNumberHeight;

  /// Letter spacing for verse text.
  /// Default: `0.0`
  final double letterSpacing;

  /// Word spacing for verse text.
  /// Default: `0.0`
  final double wordSpacing;

  // ============ Typography ============

  /// Override font size for verse text.
  /// If null, uses automatic per-page sizing.
  /// Default: `null`
  final double? fontSize;

  /// Font size for Basmala on large screens.
  /// Default: `13.2`
  final double basmalaFontSizeLarge;

  /// Font size for Basmala on small screens.
  /// Default: `24.0`
  final double basmalaFontSizeSmall;

  /// Font size for special Basmala (Surahs 95, 97) on large screens.
  /// Default: `13.2`
  final double basmalaSpecialFontSizeLarge;

  /// Font size for special Basmala (Surahs 95, 97) on small screens.
  /// Default: `18.0`
  final double basmalaSpecialFontSizeSmall;

  /// Font size for header text on large screens.
  /// Default: `16.0`
  final double headerFontSizeLarge;

  /// Font size for header text on small screens.
  /// Default: `29.0`
  final double headerFontSizeSmall;

  // ============ Component Visibility ============

  /// Whether to show the Basmala at the beginning of surahs.
  /// Default: `true`
  final bool showBasmala;

  /// Whether to show surah headers.
  /// Default: `true`
  final bool showHeader;

  // ============ Header Customization ============

  /// Width of header image on large screens.
  /// Default: `250.0`
  final double headerWidthLarge;

  /// Width of header image on small screens.
  /// Default: `372.0`
  final double headerWidthSmall;

  /// Custom widget builder for surah headers.
  /// If provided, this completely replaces the default header.
  ///
  /// Example:
  /// ```dart
  /// customHeaderBuilder: (surahNumber) {
  ///   return Container(
  ///     padding: EdgeInsets.all(16),
  ///     child: Text('Surah $surahNumber'),
  ///   );
  /// }
  /// ```
  final Widget Function(int surahNumber)? customHeaderBuilder;

  /// Border radius for header container.
  /// Default: `8.0`
  final double headerBorderRadius;

  const QcfThemeData({
    // Text Colors
    this.verseTextColor = const Color(0xFF000000),
    this.verseNumberColor = const Color(0xFF8B4513), // brown
    this.basmalaColor = Colors.black,
    this.headerTextColor = Colors.black,

    // Background Colors
    this.pageBackgroundColor = const Color(0xFFFFFFFF),
    this.verseBackgroundColor,
    this.verseNumberBackgroundColor,
    this.headerBackgroundColor,

    // Spacing & Layout
    this.horizontalPadding = 12.0,
    this.verticalPadding = 12.0,
    this.verseHeight = 2.2,
    this.verseNumberHeight = 1.35,
    this.letterSpacing = 0.0,
    this.wordSpacing = 0.0,

    // Typography
    this.fontSize,
    this.basmalaFontSizeLarge = 13.2,
    this.basmalaFontSizeSmall = 24.0,
    this.basmalaSpecialFontSizeLarge = 13.2,
    this.basmalaSpecialFontSizeSmall = 18.0,
    this.headerFontSizeLarge = 16.0,
    this.headerFontSizeSmall = 29.0,

    // Component Visibility
    this.showBasmala = true,
    this.showHeader = true,

    // Header Customization
    this.headerWidthLarge = 250.0,
    this.headerWidthSmall = 372.0,
    this.customHeaderBuilder,
    this.headerBorderRadius = 8.0,
    this.basmalaBuilder,
    this.verseNumberBuilder,
  });

  /// Creates a copy of this theme with the given fields replaced.
  QcfThemeData copyWith({
    Color? verseTextColor,
    Color? verseNumberColor,
    Color? basmalaColor,
    Color? headerTextColor,
    Color? pageBackgroundColor,
    Color? Function(int surahNumber, int verseNumber)? verseBackgroundColor,
    Color? verseNumberBackgroundColor,
    Color? headerBackgroundColor,
    double? horizontalPadding,
    double? verticalPadding,
    double? verseHeight,
    double? verseNumberHeight,
    double? letterSpacing,
    double? wordSpacing,
    double? fontSize,
    double? basmalaFontSizeLarge,
    double? basmalaFontSizeSmall,
    double? basmalaSpecialFontSizeLarge,
    double? basmalaSpecialFontSizeSmall,
    double? headerFontSizeLarge,
    double? headerFontSizeSmall,
    bool? showBasmala,
    bool? showHeader,
    double? headerWidthLarge,
    double? headerWidthSmall,
    Widget Function(int surahNumber)? customHeaderBuilder,
    double? headerBorderRadius,
    Widget Function(int surahNumber)? basmalaBuilder,
    InlineSpan Function(int surah, int verse, String verseNumber)? verseNumberBuilder,
  }) {
    return QcfThemeData(
      verseTextColor: verseTextColor ?? this.verseTextColor,
      verseNumberColor: verseNumberColor ?? this.verseNumberColor,
      basmalaColor: basmalaColor ?? this.basmalaColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      pageBackgroundColor: pageBackgroundColor ?? this.pageBackgroundColor,
      verseBackgroundColor: verseBackgroundColor ?? this.verseBackgroundColor,
      verseNumberBackgroundColor:
          verseNumberBackgroundColor ?? this.verseNumberBackgroundColor,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      verseHeight: verseHeight ?? this.verseHeight,
      verseNumberHeight: verseNumberHeight ?? this.verseNumberHeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      wordSpacing: wordSpacing ?? this.wordSpacing,
      fontSize: fontSize ?? this.fontSize,
      basmalaFontSizeLarge: basmalaFontSizeLarge ?? this.basmalaFontSizeLarge,
      basmalaFontSizeSmall: basmalaFontSizeSmall ?? this.basmalaFontSizeSmall,
      basmalaSpecialFontSizeLarge:
          basmalaSpecialFontSizeLarge ?? this.basmalaSpecialFontSizeLarge,
      basmalaSpecialFontSizeSmall:
          basmalaSpecialFontSizeSmall ?? this.basmalaSpecialFontSizeSmall,
      headerFontSizeLarge: headerFontSizeLarge ?? this.headerFontSizeLarge,
      headerFontSizeSmall: headerFontSizeSmall ?? this.headerFontSizeSmall,
      showBasmala: showBasmala ?? this.showBasmala,
      showHeader: showHeader ?? this.showHeader,
      headerWidthLarge: headerWidthLarge ?? this.headerWidthLarge,
      headerWidthSmall: headerWidthSmall ?? this.headerWidthSmall,
      customHeaderBuilder: customHeaderBuilder ?? this.customHeaderBuilder,
      headerBorderRadius: headerBorderRadius ?? this.headerBorderRadius,
      basmalaBuilder: basmalaBuilder ?? this.basmalaBuilder,
      verseNumberBuilder: verseNumberBuilder ?? this.verseNumberBuilder,
    );
  }

  /// Custom builder for Basmala.
  /// If provided, replaces the default Basmala text/image.
  final Widget Function(int surahNumber)? basmalaBuilder;

  /// Custom builder for verse numbers.
  /// If provided, replaces the default verse number text style.
  /// Must return an [InlineSpan] because it's rendered inside a Text.rich.
  final InlineSpan Function(int surah, int verse, String verseNumber)? verseNumberBuilder;
  factory QcfThemeData.dark() {
    return const QcfThemeData(
      verseTextColor: Color(0xFFE0E0E0),
      verseNumberColor: Color(0xFFFFB74D), // amber
      basmalaColor: Color(0xFFE0E0E0),
      headerTextColor: Color(0xFFE0E0E0),
      pageBackgroundColor: Color(0xFF1E1E1E),
    );
  }

  /// Creates a sepia/vintage theme preset.
  factory QcfThemeData.sepia() {
    return const QcfThemeData(
      verseTextColor: Color(0xFF3E2723),
      verseNumberColor: Color(0xFF6D4C41),
      basmalaColor: Color(0xFF3E2723),
      headerTextColor: Color(0xFF3E2723),
      pageBackgroundColor: Color(0xFFF5E6D3),
    );
  }
}
