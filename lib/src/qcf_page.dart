import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:qcf_quran/src/header_widget.dart';
// ignore: implementation_imports
import 'package:qcf_quran/src/data/page_font_size.dart';

/// A widget that renders a single page of the Quran.
///
/// Use this if you want to build your own [PageView] or layout
/// and need granular control over each page's state and rendering.
class QcfPage extends StatelessWidget {
  /// The 1-based page number (1..604).
  final int pageNumber;

  /// Theme configuration for styling the page.
  final QcfThemeData theme;

  /// Optional font size override.
  final double? fontSize;

  /// Scaling factor for screen width/pixel density (default 1.0).
  /// Used for responsive sizing of fonts and layout.
  final double sp;

  /// Scaling factor for screen height (default 1.0).
  /// Used for responsive vertical spacing.
  final double h;

  /// Callback when a verse is long-pressed.
  final void Function(int surahNumber, int verseNumber)? onLongPress;

  /// Callback when long-press ends.
  final void Function(int surahNumber, int verseNumber)? onLongPressUp;

  /// Callback when long-press is cancelled.
  final void Function(int surahNumber, int verseNumber)? onLongPressCancel;

  /// Callback when long-press starts (includes details).
  final void Function(
    int surahNumber,
    int verseNumber,
    LongPressStartDetails details,
  )?
  onLongPressDown;

  /// Callback when a verse is tapped.
  /// Note: If [onTap] is provided, it takes precedence over [onLongPress] for the gesture recognizer
  /// if both are active on the same text span (TextSpan supports only one recognizer).
  final void Function(int surahNumber, int verseNumber)? onTap;

  /// Optional callback to customize verse background color dynamically.
  /// This takes precedence over [theme.verseBackgroundColor] if provided.
  final Color? Function(int surahNumber, int verseNumber)? verseBackgroundColor;

  const QcfPage({
    super.key,
    required this.pageNumber,
    this.theme = const QcfThemeData(),
    this.fontSize,
    this.sp = 1.0,
    this.h = 1.0,
    this.onLongPress,
    this.onLongPressUp,
    this.onLongPressCancel,
    this.onLongPressDown,
    this.onTap,
    this.verseBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Validate page number
    if (pageNumber < 1 || pageNumber > 604) {
      return Center(child: Text('Invalid page number: $pageNumber'));
    }

    final ranges = getPageData(pageNumber);
    final pageFont = "QCF_P${pageNumber.toString().padLeft(3, '0')}";
    // Note: User preferred multiplication logic for scaling
    final baseFontSize = getFontSize(pageNumber, context) * sp;
    final screenSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final verseSpans = <InlineSpan>[];
    if (pageNumber == 2 || pageNumber == 1) {
      verseSpans.add(
        WidgetSpan(child: SizedBox(height: screenSize.height * .175)),
      );
    }
    for (final r in ranges) {
      final surah = int.parse(r['surah'].toString());
      final start = int.parse(r['start'].toString());
      final end = int.parse(r['end'].toString());

      for (int v = start; v <= end; v++) {
        if (v == start && v == 1) {
          if (theme.showHeader) {
            verseSpans.add(
              WidgetSpan(child: HeaderWidget(suraNumber: surah, theme: theme)),
            );
          }
          if (theme.showBasmala && pageNumber != 1 && pageNumber != 187) {
            // Check for custom Basmala builder
            if (theme.basmalaBuilder != null) {
              verseSpans.add(
                WidgetSpan(
                  child: theme.basmalaBuilder!(surah),
                  alignment: PlaceholderAlignment.middle,
                ),
              );
              // Add a newline after custom builder to maintain layout flow if needed
              // or let the builder handle it. Usually basmala is a block.
              // We'll add a newline ensuring separation.
              verseSpans.add(const TextSpan(text: "\n"));
            } else {
              verseSpans.add(
                TextSpan(
                  text: " ﱁ  ﱂﱃﱄ\n",
                  style: TextStyle(
                    fontFamily: "QCF_P001",
                    package: 'qcf_quran',
                    fontSize:
                        getScreenType(context) == ScreenType.large
                            ? theme.basmalaFontSizeLarge * sp
                            : theme.basmalaFontSizeSmall * sp,
                    color: theme.basmalaColor,
                  ),
                ),
              );
            }
          }
        }

        // Gesture Handling
        GestureRecognizer? recognizer;
        if (onTap != null) {
          recognizer =
              TapGestureRecognizer()..onTap = () => onTap?.call(surah, v);
        } else if (onLongPress != null ||
            onLongPressDown != null ||
            onLongPressUp != null) {
          final longPressRecognizer = LongPressGestureRecognizer();
          longPressRecognizer.onLongPress = () => onLongPress?.call(surah, v);
          longPressRecognizer.onLongPressStart =
              (d) => onLongPressDown?.call(surah, v, d);
          longPressRecognizer.onLongPressUp =
              () => onLongPressUp?.call(surah, v);
          longPressRecognizer.onLongPressEnd =
              (d) => onLongPressCancel?.call(surah, v);
          recognizer = longPressRecognizer;
        }

        final verseBgColor =
            theme.verseBackgroundColor?.call(surah, v) ??
            verseBackgroundColor?.call(surah, v);

        // Verse Number Logic
        InlineSpan verseNumberSpan;
        if (theme.verseNumberBuilder != null) {
          verseNumberSpan = theme.verseNumberBuilder!(
            surah,
            v,
            getVerseNumberQCF(surah, v),
          );
        } else {
          verseNumberSpan = TextSpan(
            text: getVerseNumberQCF(surah, v),
            style: TextStyle(
              fontFamily: pageFont,
              package: 'qcf_quran',
              color: theme.verseNumberColor,
              height: theme.verseNumberHeight * h,
              backgroundColor: theme.verseNumberBackgroundColor ?? verseBgColor,
            ),
          );
        }

        // Check if the original string had a trailing newline so we can append it
        // after the colored glyph span without it affecting the background color box.
        final String fullVerseText = getVerseQCF(
          surah,
          v,
          verseEndSymbol: true,
        );
        final bool hasTrailingNewline = fullVerseText.endsWith('\n');

        String textWithoutSymbol = getVerseQCF(surah, v, verseEndSymbol: false);

        // Remove leading newline for the first verse in the range
        if (v == ranges[0]['start'] && textWithoutSymbol.startsWith("\n")) {
          textWithoutSymbol = textWithoutSymbol.replaceFirst("\n", "");
        }

        // Add thin space after first character if verse starts a page/range
        if (v == ranges[0]['start'] && textWithoutSymbol.length > 1) {
          textWithoutSymbol =
              "${textWithoutSymbol.substring(0, 1)}\u200A${textWithoutSymbol.substring(1)}";
        }

        verseSpans.add(
          TextSpan(
            text: textWithoutSymbol,
            recognizer: recognizer,
            style:
                verseBgColor != null
                    ? TextStyle(backgroundColor: verseBgColor)
                    : null,
            children: [
              verseNumberSpan,
              if (hasTrailingNewline) const TextSpan(text: '\n'),
            ],
          ),
        );
      }
    }

    return Stack(
      children: [
        Scrollbar(
          child: SingleChildScrollView(
            child: SizedBox(
              height: screenSize.height,
              width: screenSize.width,
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: Text.rich(
                        TextSpan(children: verseSpans),
                        locale: const Locale("ar"),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: pageFont,
                          package: 'qcf_quran',
                          fontSize:
                              isPortrait
                                  ? baseFontSize
                                  : (pageNumber == 1 || pageNumber == 2)
                                  ? 20 * sp
                                  : baseFontSize - (17 * sp),
                          color: theme.verseTextColor,
                          height:
                              isPortrait
                                  ? (pageNumber == 1 || pageNumber == 2)
                                      ? 2.2 * h
                                      : theme.verseHeight * h
                                  : (pageNumber == 1 || pageNumber == 2)
                                  ? 4 *
                                      h // simplified based on user's manual edit evaluation
                                  : 4 *
                                      h, // simplified based on user's manual edit evaluation
                          letterSpacing: theme.letterSpacing,
                          wordSpacing: theme.wordSpacing,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
