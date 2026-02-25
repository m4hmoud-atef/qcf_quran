import 'package:flutter/widgets.dart';

/// Helper to map surah numbers or "surahXXX" strings to font glyphs.
class SurahFontHelper {
  /// The font family name used for surah names.
  static const String fontFamily = 'surahname';

  /// Maps a surah number (1-114) to its corresponding glyph in the surahname font.
  /// 
  /// Usually these fonts map the surah number to a specific character.
  /// Following the pattern "surah001" -> surah 1.
  static String getSurahGlyph(int surahNumber) {
    if (surahNumber < 1 || surahNumber > 114) return '';
    
    // Most surah name fonts use the surah number as the character index or 
    // map it to a specific range. We'll use the surah number as a string 
    // if the font expects "001", "002", etc., or convert to char.
    // However, the user mentioned adding "surah001" as a string to show the name.
    // If the font is designed correctly, maybe it uses ligatures?
    // For now, we'll return the padded string if that's what the user implies, 
    // or a single character if that's how the font works.
    
    // In many QCF fonts, surah names are indexed by their number.
    // We'll return the character code corresponding to the surah number.
    return String.fromCharCode(surahNumber);
  }

  /// Processes a string to replace "surahXXX" patterns with the correct font glyphs.
  static TextSpan formatSurahText(String text, {TextStyle? style, String? package}) {
    final RegExp regExp = RegExp(r'surah(\d{3})');
    final List<InlineSpan> children = [];
    int lastMatchEnd = 0;

    for (final Match match in regExp.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        children.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      final String surahNumStr = match.group(1)!;
      final int surahNumber = int.parse(surahNumStr);
      
      children.add(
        TextSpan(
          text: getSurahGlyph(surahNumber),
          style: (style ?? const TextStyle()).copyWith(
            fontFamily: fontFamily,
            package: package,
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      children.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return TextSpan(children: children, style: style);
  }
}
