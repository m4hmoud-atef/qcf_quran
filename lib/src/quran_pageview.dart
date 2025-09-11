import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:qcf_quran/qcf_quran.dart';

/// A horizontally swipeable Quran mushaf using internal QCF fonts.
///
/// - Uses `pageData` to determine surah/verse ranges for each page.
/// - Renders each verse with `QcfVerse`, which applies the correct per-page font.
/// - Supports RTL page order via `reverse: true` and `Directionality.rtl`.
class PageviewQuran extends StatefulWidget {
  /// 1-based initial page number (1..604)
  final int initialPageNumber;

  /// Optional external controller. If not provided, an internal one is created.
  final PageController? controller;

  //sp (adding 1.sp to get the ratio of screen size for responsive font design)
  final double sp;

  //h (adding 1.h to get the ratio of screen size for responsive font design)
  final double h;

  /// Optional callback when page changes. Provides 1-based page number.
  final ValueChanged<int>? onPageChanged;

  /// Optional override font size passed to each `QcfVerse`.
  final double? fontSize;

  /// Verse text color.
  final Color textColor;

  /// Background color for the whole page container.
  final Color pageBackgroundColor;

  /// Long-press callbacks that include the pressed verse info.
  final void Function(int surahNumber, int verseNumber)? onLongPress;
  final void Function(int surahNumber, int verseNumber)? onLongPressUp;
  final void Function(int surahNumber, int verseNumber)? onLongPressCancel;
  final void Function(
    int surahNumber,
    int verseNumber,
    LongPressStartDetails details,
  )?
  onLongPressDown;

  const PageviewQuran({
    super.key,
    this.initialPageNumber = 1,
    this.controller,
    this.onPageChanged,
    this.fontSize,
    this.sp = 1,
    this.h = 1,
    this.textColor = const Color(0xFF000000),
    this.pageBackgroundColor = const Color(0xFFFFFFFF),
    this.onLongPress,
    this.onLongPressUp,
    this.onLongPressCancel,
    this.onLongPressDown,
  }) : assert(initialPageNumber >= 1 && initialPageNumber <= totalPagesCount);

  @override
  State<PageviewQuran> createState() => _PageviewQuranState();
}

class _PageviewQuranState extends State<PageviewQuran> {
  PageController? _internalController;

  PageController get _controller => widget.controller ?? _internalController!;

  bool get _ownsController => widget.controller == null;

  @override
  void initState() {
    super.initState();
    if (_ownsController) {
      _internalController = PageController(
        initialPage: widget.initialPageNumber - 1,
      );
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _internalController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: widget.pageBackgroundColor,
        child: PageView.builder(
          controller: _controller,
          reverse: false, // right-to-left paging order
          itemCount: totalPagesCount,
          onPageChanged: (index) =>
              widget.onPageChanged?.call(index + 1), // 1-based
          itemBuilder: (context, index) {
            final pageNumber = index + 1; // 1-based page
            return _PageContent(
              pageNumber: pageNumber,
              fontSize: widget.fontSize,
              textColor: widget.textColor,
              onLongPress: widget.onLongPress,
              onLongPressUp: widget.onLongPressUp,
              onLongPressCancel: widget.onLongPressCancel,
              onLongPressDown: widget.onLongPressDown,
              sp: widget.sp,
              h: widget.h,
            );
          },
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final int pageNumber;
  final double? fontSize;
  final Color textColor;
  final void Function(int surahNumber, int verseNumber)? onLongPress;
  final void Function(int surahNumber, int verseNumber)? onLongPressUp;
  final void Function(int surahNumber, int verseNumber)? onLongPressCancel;

  //sp (adding 1.sp to get the ratio of screen size for responsive font design)
  final double sp;

  //h (adding 1.h to get the ratio of screen size for responsive font design)
  final double h;

  final void Function(
    int surahNumber,
    int verseNumber,
    LongPressStartDetails details,
  )?
  onLongPressDown;

  const _PageContent({
    required this.pageNumber,
    required this.fontSize,
    required this.textColor,
    required this.onLongPress,
    required this.onLongPressUp,
    required this.onLongPressCancel,
    required this.onLongPressDown,
    required this.sp,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    final ranges = getPageData(pageNumber);
    final pageFont = "QCF_P${pageNumber.toString().padLeft(3, '0')}";
    final baseFontSize = getFontSize(pageNumber, context) / sp;

    final verseSpans = <InlineSpan>[];
    if (pageNumber == 2 || pageNumber == 1) {
      verseSpans.add(
        WidgetSpan(
          child: SizedBox(height: MediaQuery.of(context).size.height * .175),
        ),
      );
    }
    for (final r in ranges) {
      final surah = int.parse(r['surah'].toString());
      final start = int.parse(r['start'].toString());
      final end = int.parse(r['end'].toString());

      for (int v = start; v <= end; v++) {
        if (v == start && v == 1) {
          verseSpans.add(WidgetSpan(child: HeaderWidget(suraNumber: surah)));
          if (pageNumber != 1 && pageNumber != 187) {
            if(surah != 97){
             verseSpans.add(
              TextSpan(
                text: " ﱁ  ﱂﱃﱄ\n",
                style: TextStyle(
                  fontFamily: "QCF_P001",
                  package: 'qcf_quran',
                  fontSize: getScreenType(context) == ScreenType.large
                      ? 13.2 / sp
                      : 24 / sp,
                  color: Colors.black,
                ),
              ),
            );
            }else
          {  verseSpans.add(
                TextSpan(
                text:  "齃𧻓𥳐龎\n" ,
                  style: TextStyle(
                    fontFamily: "QCF_BSML",
                    package: 'qcf_quran',
                    fontSize: getScreenType(context) == ScreenType.large
                        ? 13.2 / sp
                        : 18 / sp,
                    color: Colors.black,
                  ),
                ),
              ); }
          }
        }
        final spanRecognizer = LongPressGestureRecognizer();
        spanRecognizer.onLongPress = () => onLongPress?.call(surah, v);
        spanRecognizer.onLongPressStart = (LongPressStartDetails d) =>
            onLongPressDown?.call(surah, v, d);
        spanRecognizer.onLongPressUp = () => onLongPressUp?.call(surah, v);
        spanRecognizer.onLongPressEnd = (LongPressEndDetails d) =>
            onLongPressCancel?.call(surah, v);

        verseSpans.add(
          TextSpan(
            text:v==ranges[0]['start']        ?  "${getVerseQCF(surah, v, verseEndSymbol: false).substring(0, 1)}\u200A${getVerseQCF(surah, v, verseEndSymbol: false).substring(1, getVerseQCF(surah, v, verseEndSymbol: false).length )}"
        : getVerseQCF(surah, v, verseEndSymbol: false
          ),
            recognizer: spanRecognizer,
            children: [
              TextSpan(
                text: getVerseNumberQCF(surah, v),
                style: TextStyle(
                  fontFamily: pageFont,
                  package: 'qcf_quran',
                  color: Colors.brown,
                  height: 1.35 / h,
                ),
              ),
            ],
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      color: Colors.transparent,
      child: Text.rich(
        TextSpan(children: verseSpans),
        locale: const Locale("ar"),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: pageFont,
          package: 'qcf_quran',
          fontSize: baseFontSize,
          color: textColor,
          height: (pageNumber == 1 || pageNumber == 2)
              ? 2.2
              : MediaQuery.of(context).systemGestureInsets.left > 0 == false
              ? 2.2
              : MediaQuery.of(context).viewPadding.top > 0
              ? 2.2
              : 2.2,
        ),
      ),
    );
  }
}
