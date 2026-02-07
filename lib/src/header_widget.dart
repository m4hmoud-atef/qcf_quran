import 'package:flutter/material.dart';
import 'package:qcf_quran/qcf_quran.dart';

class HeaderWidget extends StatelessWidget {
  final int suraNumber;
  
  /// Optional theme configuration for customizing header appearance.
  /// If null, uses default theme values.
  final QcfThemeData? theme;
  
  const HeaderWidget({
    super.key, 
    required this.suraNumber,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final effectiveTheme = theme ?? const QcfThemeData();
    
    // If custom header builder is provided, use it
    if (effectiveTheme.customHeaderBuilder != null) {
      return effectiveTheme.customHeaderBuilder!(suraNumber);
    }
    
    return InkWell(
      borderRadius: BorderRadius.circular(effectiveTheme.headerBorderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: effectiveTheme.headerBackgroundColor,
        ),
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: const AssetImage("assets/mainframe.png", package: 'qcf_quran'),
              width:isPortrait? getScreenType(context) == ScreenType.large 
                  ? effectiveTheme.headerWidthLarge 
                  : effectiveTheme.headerWidthSmall:MediaQuery.of(  context).size.width * 0.8,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "$suraNumber",
                style: TextStyle(
                  fontFamily: "arsura",
                  package: 'qcf_quran',
                  fontSize:isPortrait?  getScreenType(context) == ScreenType.large
                      ? effectiveTheme.headerFontSizeLarge
                      : effectiveTheme.headerFontSizeSmall:MediaQuery.of(context).size.width * 0.05,
                  color: effectiveTheme.headerTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
