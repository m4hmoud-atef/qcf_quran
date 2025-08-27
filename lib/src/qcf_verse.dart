import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:qcf_quran/src/data/page_font_size.dart';
import 'package:qcf_quran/src/helpers/convert_to_arabic_number.dart';

class QcfVerse extends StatefulWidget {
  final int surahNumber;
  final int verseNumber;
  var fontSize;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback? onLongPress;
  final VoidCallback? onLongPressUp;
  final VoidCallback? onLongPressCancel;
  final Function(LongPressDownDetails)? onLongPressDown;

  QcfVerse({
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
  });

  @override
  State<QcfVerse> createState() => _QcfVerseState();
}

class _QcfVerseState extends State<QcfVerse> {
  @override
  Widget build(BuildContext context) {
    var pageNumber = getPageNumber(widget.surahNumber, widget.verseNumber);
    var pageFontSize = getFontSize(pageNumber, context);
    print("QCF_P${pageNumber.toString().padLeft(3, '0')}");
    return RichText(
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
              height: 1.35,
            ),
          ),
        ],
        style: TextStyle(
          color: widget.textColor,
          height: 2.0,
          letterSpacing: 0,
          package: 'qcf_quran', // 👈 required

          wordSpacing: 0,
          fontFamily: "QCF_P${pageNumber.toString().padLeft(3, '0')}",
          fontSize: widget.fontSize ?? pageFontSize,
          backgroundColor: widget.backgroundColor,
        ),
      ),
    );
  }
}
