import 'package:flutter/widgets.dart';
import 'package:qcf_quran/qcf_quran.dart';

/// A widget that renders multiple verses from the Quran in QCF format.
///
/// This widget displays a range of verses from a single surah with proper
/// alignment, responsive sizing, and theme support. It handles verses that
/// may span multiple pages, automatically selecting the correct QCF font
/// for each verse.
///
/// Example:
/// ```dart
/// QcfVerses(
///   surahNumber: 2,
///   firstVerse: 1,
///   lastVerse: 5,
///   sp: 1.sp,  // Responsive scaling
///   h: 1.h,
/// )
/// ```
class QcfVerses extends StatelessWidget {
  /// The surah number (1-114)
  final int surahNumber;

  /// The first verse number in the range
  final int firstVerse;

  /// The last verse number in the range
  final int lastVerse;

  /// Optional theme configuration for customizing all visual aspects.
  /// If null, uses default theme values.
  final QcfThemeData? theme;

  /// Text alignment for the verses.
  /// Defaults to center alignment (recommended for Quranic text).
  final TextAlign textAlign;

  /// Whether to show verse numbers.
  /// Defaults to true.
  final bool showVerseNumbers;

  /// Optional custom formatter for verse numbers.
  /// If null, uses Arabic numerals via convertToArabicNumber.
  /// Example: (num) => "($num)" for Western-style numbering
  final String Function(int)? verseNumberFormatter;

  /// Scaling factor for screen width/pixel density (default 1.0).
  /// Used for responsive sizing of fonts.
  /// When using flutter_screenutil, pass 1.sp
  final double sp;

  /// Scaling factor for screen height (default 1.0).
  /// Used for responsive vertical spacing and line height.
  /// When using flutter_screenutil, pass 1.h
  final double h;

  /// Optional base font size override.
  /// If null, uses automatic page-based sizing.
  final double? fontSize;

  const QcfVerses({
    super.key,
    required this.surahNumber,
    required this.firstVerse,
    required this.lastVerse,
    this.theme,
    this.textAlign = TextAlign.center,
    this.showVerseNumbers = true,
    this.verseNumberFormatter,
    this.sp = 1.0,
    this.h = 1.0,
    this.fontSize,
  }) : assert(firstVerse <= lastVerse, 'firstVerse must be <= lastVerse'),
       assert(surahNumber >= 1 && surahNumber <= 114, 'surahNumber must be between 1 and 114');

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? const QcfThemeData();
    final verseSpans = _buildVerseSpans(context, effectiveTheme);

    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: textAlign,
      locale: const Locale("ar"),
      text: TextSpan(
        children: verseSpans,
        style: TextStyle(
          color: effectiveTheme.verseTextColor,
        ),
      ),
    );
  }

  /// Builds the list of TextSpan widgets for all verses in the range.
  List<InlineSpan> _buildVerseSpans(BuildContext context, QcfThemeData effectiveTheme) {
    List<InlineSpan> verseSpans = [];

    for (int verseNumber = firstVerse; verseNumber <= lastVerse; verseNumber++) {
      // Get the verse text and page information
      String verseText = getVerseQCF(surahNumber, verseNumber, verseEndSymbol: true);
      int pageNumber = getPageNumber(surahNumber, verseNumber);
      String fontFamily = "QCF_P${pageNumber.toString().padLeft(3, '0')}";

      // Get page data to check if this verse starts a page
      final pageData = getPageData(pageNumber);
      bool isPageStart = pageData[0]["start"] == verseNumber;

      // Add thin space after first character if verse starts a page
      if (isPageStart && verseText.length > 1) {
        verseText = "${verseText.substring(0, 1)}\u200A${verseText.substring(1)}";
      }

      // Remove leading newline for the first verse in the range
      if (verseNumber == firstVerse && verseText.startsWith("\n")) {
        verseText = verseText.replaceFirst("\n", "");
      }

      // Determine if verse ends with newline
      bool endsWithNewline = verseText.endsWith("\n");
      
      // Remove the verse number glyph (last character or last 2 if newline)
      String verseTextWithoutNumber = endsWithNewline
          ? verseText.substring(0, verseText.length - 2)
          : verseText.substring(0, verseText.length - 1);

      // Calculate responsive font size
      double effectiveFontSize = fontSize ?? (getFontSize(pageNumber, context) / sp);

      // Build verse number span
      InlineSpan? verseNumberSpan;
      if (showVerseNumbers) {
        String verseNumberText;
        if (verseNumberFormatter != null) {
          // Use custom formatter
          verseNumberText = verseNumberFormatter!(verseNumber);
          
          // Add newline or space after verse number
          if (endsWithNewline && verseNumber != lastVerse) {
            verseNumberText += "\n";
          } else {
            verseNumberText += " ";
          }
          
          verseNumberSpan = TextSpan(
            text: verseNumberText,
            style: TextStyle(
              fontSize: effectiveTheme.verseNumberHeight > 0 
                  ? effectiveFontSize * 0.8
                  : effectiveFontSize,
              height: effectiveTheme.verseNumberHeight / h,
              fontFamily: fontFamily,
              package: 'qcf_quran',
              color: effectiveTheme.verseNumberColor,
              backgroundColor: effectiveTheme.verseNumberBackgroundColor,
            ),
          );
        } else {
          // Use QCF verse number glyph (default)
          verseNumberText = getVerseNumberQCF(surahNumber, verseNumber);
          
          verseNumberSpan = TextSpan(
            text: verseNumberText,
            style: TextStyle(
              fontSize: effectiveFontSize,
              height: effectiveTheme.verseNumberHeight / h,
              fontFamily: fontFamily,
              package: 'qcf_quran',
              color: effectiveTheme.verseNumberColor,
              backgroundColor: effectiveTheme.verseNumberBackgroundColor,
            ),
          );
        }
      }

      // Build the verse span
      final verseBgColor = effectiveTheme.verseBackgroundColor?.call(surahNumber, verseNumber);

      verseSpans.add(
        TextSpan(
          text: verseTextWithoutNumber,
          style: TextStyle(
            fontFamily: fontFamily,
            package: 'qcf_quran',
            fontSize: effectiveFontSize,
            height: effectiveTheme.verseHeight / h,
            letterSpacing: effectiveTheme.letterSpacing,
            wordSpacing: effectiveTheme.wordSpacing,
            color: effectiveTheme.verseTextColor,
            backgroundColor: verseBgColor,
          ),
          children: verseNumberSpan != null ? [verseNumberSpan] : null,
        ),
      );
    }

    return verseSpans;
  }
}
