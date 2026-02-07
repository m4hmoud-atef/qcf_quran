import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:qcf_quran/qcf_quran.dart';

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
    final effectiveTheme = widget.theme ?? const QcfThemeData();
    var pageNumber = getPageNumber(widget.surahNumber, widget.verseNumber);
    var pageFontSize = getFontSize(pageNumber, context);
    
    final verseTextColor = widget.theme?.verseTextColor ?? widget.textColor;
    final verseBgColor = widget.theme?.verseBackgroundColor?.call(widget.surahNumber, widget.verseNumber) ?? 
                         (widget.backgroundColor.alpha > 0 ? widget.backgroundColor : null);
    
    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      text: TextSpan(
        recognizer: LongPressGestureRecognizer()
          ..onLongPress = widget.onLongPress
          ..onLongPressDown = widget.onLongPressDown
          ..onLongPressUp = widget.onLongPressUp
          ..onLongPressCancel = widget.onLongPressCancel,
        text: getVerseQCF(
          widget.surahNumber,
          widget.verseNumber,
          verseEndSymbol: false,
        ),
        locale: const Locale("ar"),
        children: [
          TextSpan(
            text: getVerseNumberQCF(widget.surahNumber, widget.verseNumber),
            style: TextStyle(
              fontFamily: "QCF_P${pageNumber.toString().padLeft(3, '0')}",
              package: 'qcf_quran', // 👈 required
              color: effectiveTheme.verseNumberColor,
              height: effectiveTheme.verseNumberHeight / widget.h,
              backgroundColor: effectiveTheme.verseNumberBackgroundColor ?? verseBgColor,
            ),
          ),
        ],
        style: TextStyle(
          color: verseTextColor,
          height: effectiveTheme.verseHeight / widget.h,
          letterSpacing: effectiveTheme.letterSpacing,
          package: 'qcf_quran', // 👈 required
          wordSpacing: effectiveTheme.wordSpacing,
          fontFamily: "QCF_P${pageNumber.toString().padLeft(3, '0')}",
          fontSize: widget.fontSize ?? pageFontSize / widget.sp,
          backgroundColor: verseBgColor,
        ),
      ),
    );
  }
}
