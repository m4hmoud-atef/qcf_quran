import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:qcf_quran/src/helpers/dynamic_font_loader.dart';

class QcfVerse extends StatefulWidget {
  final int surahNumber;
  final int verseNumber;
  final double? fontSize;

  /// Optional theme configuration for customizing all visual aspects.
  /// If null, uses default theme values.
  final QcfThemeData? theme;

  /// Verse text color.
  /// DEPRECATED: Use theme.verseTextColor instead.
  final Color textColor;

  /// Background color for verse.
  /// DEPRECATED: Use theme.verseBackgroundColor instead.
  final Color backgroundColor;

  final VoidCallback? onLongPress;
  final VoidCallback? onLongPressUp;

  final VoidCallback? onLongPressCancel;
  final Function(LongPressDownDetails)? onLongPressDown;
  //sp (adding 1.sp to get the ratio of screen size for responsive font design)
  final double sp;

  //h (adding 1.h to get the ratio of screen size for responsive font design)
  final double h;

  const QcfVerse({
    super.key,
    required this.surahNumber,
    required this.verseNumber,
    this.fontSize,
    this.theme,
    this.textColor = const Color(0xFF000000),
    this.backgroundColor = const Color(0x00000000),
    this.onLongPress,
    this.onLongPressUp,
    this.onLongPressCancel,
    this.onLongPressDown,
    this.sp = 1,
    this.h = 1,
  });

  @override
  State<QcfVerse> createState() => _QcfVerseState();
}

class _QcfVerseState extends State<QcfVerse> {
  @override
  Widget build(BuildContext context) {
    var pageNumber = getPageNumber(widget.surahNumber, widget.verseNumber);
    final effectiveTheme = widget.theme ?? const QcfThemeData();
    var pageFontSize = getFontSize(pageNumber, context);

    return FutureBuilder(
      future: DynamicFontLoader.loadFont(pageNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Failed to load font: ${snapshot.error}'));
        }

        final verseTextColor = widget.theme?.verseTextColor ?? widget.textColor;
        final verseBgColor =
            widget.theme?.verseBackgroundColor?.call(
              widget.surahNumber,
              widget.verseNumber,
            ) ??
            (widget.backgroundColor.a > 0 ? widget.backgroundColor : null);

        final String fontFamily =
            "QCF_P${pageNumber.toString().padLeft(3, '0')}";
        final double effectiveFontSize =
            widget.fontSize ?? pageFontSize / widget.sp;

        // getVerseQCF(verseEndSymbol: false) now correctly strips both the glyph
        // and trailing '\n' (if any), returning pure verse text.
        final String textWithoutSymbol = getVerseQCF(
          widget.surahNumber,
          widget.verseNumber,
          verseEndSymbol: false,
        );

        // getVerseNumberQCF now correctly returns the glyph even when followed by '\n'.
        final String verseNumberGlyph = getVerseNumberQCF(
          widget.surahNumber,
          widget.verseNumber,
        );

        // Check if the original string had a trailing newline so we can append it
        // after the colored glyph span without it affecting the background color box.
        final String fullVerseText = getVerseQCF(
          widget.surahNumber,
          widget.verseNumber,
          verseEndSymbol: true,
        );
        final bool hasTrailingNewline = fullVerseText.endsWith('\n');

        return RichText(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          text: TextSpan(
            recognizer:
                LongPressGestureRecognizer()
                  ..onLongPress = widget.onLongPress
                  ..onLongPressDown = widget.onLongPressDown
                  ..onLongPressUp = widget.onLongPressUp
                  ..onLongPressCancel = widget.onLongPressCancel,
            text: textWithoutSymbol,
            locale: const Locale("ar"),
            children: [
              TextSpan(
                text: verseNumberGlyph,
                style: TextStyle(
                  fontFamily: fontFamily,
                  // package parameter removed for dynamic fonts
                  color: effectiveTheme.verseNumberColor,
                  height: effectiveTheme.verseNumberHeight / widget.h,
                  fontSize: effectiveFontSize,
                  backgroundColor:
                      effectiveTheme.verseNumberBackgroundColor ?? verseBgColor,
                ),
              ),
              if (hasTrailingNewline) const TextSpan(text: '\n'),
            ],
            style: TextStyle(
              color: verseTextColor,
              height: effectiveTheme.verseHeight / widget.h,
              letterSpacing: effectiveTheme.letterSpacing,
              // package parameter removed for dynamic fonts
              wordSpacing: effectiveTheme.wordSpacing,
              fontFamily: fontFamily,
              fontSize: effectiveFontSize,
              backgroundColor: verseBgColor,
            ),
          ),
        );
      },
    );
  }
}
