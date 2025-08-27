import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:qcf_quran/qcf_quran.dart';

class QcfVerse extends StatefulWidget {
  final int surahNumber;
  final int verseNumber;
  final double? fontSize;
  final Color textColor;
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
    var pageFontSize = getFontSize(pageNumber, context);
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
              height: 1.35 / widget.h,
            ),
          ),
        ],
        style: TextStyle(
          color: widget.textColor,
          height: 2.0 / widget.h,
          letterSpacing: 0,
          package: 'qcf_quran', // 👈 required

          wordSpacing: 0,
          fontFamily: "QCF_P${pageNumber.toString().padLeft(3, '0')}",
          fontSize: widget.fontSize ?? pageFontSize / widget.sp,
          backgroundColor: widget.backgroundColor,
        ),
      ),
    );
  }
}
