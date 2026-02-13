/// qcf_quran — High-fidelity Quran Mushaf rendering using bundled QCF fonts.
///
/// This package exposes:
///
/// - Rendering widgets:
///   - `QcfVerse` to render a single ayah with per-page QCF ligatures
///   - `PageviewQuran` to render a swipeable mushaf (604 pages, RTL)
/// - Data helpers: page, surah, juz mappings and Quran text
/// - Utility functions: arabic numerals, normalization, simple search
///
import 'src/data/page_data.dart';
import 'src/data/juzs.dart';
import 'src/data/suwar.dart';
import 'src/data/quran_text.dart';
export 'src/qcf_verse.dart';
export 'src/qcf_verses.dart';
export 'src/data/page_font_size.dart';
export 'src/helpers/convert_to_arabic_number.dart';
export 'src/quran_pageview.dart';
export 'src/header_widget.dart';
export 'src/qcf_page.dart';
export 'src/qcf_theme_data.dart';

List getPageData(int pageNumber) {
  if (pageNumber < 1 || pageNumber > 604) {
    throw "Invalid page number. Page number must be between 1 and 604";
  }
  return pageData[pageNumber - 1];
}

///The most standard and common copy of Arabic only Quran total pages count
const int totalPagesCount = 604;

///The constant total of makki surahs
const int totalMakkiSurahs = 89;

///The constant total of madani surahs
const int totalMadaniSurahs = 25;

///The constant total juz count
const int totalJuzCount = 30;

///The constant total surah count
const int totalSurahCount = 114;

///The constant total verse count
const int totalVerseCount = 6236;

///Takes [pageNumber] and returns total surahs count in that page
int getSurahCountByPage(int pageNumber) {
  if (pageNumber < 1 || pageNumber > 604) {
    throw "Invalid page number. Page number must be between 1 and 604";
  }
  return pageData[pageNumber - 1].length;
}

///Takes [pageNumber] and returns total verses count in that page
int getVerseCountByPage(int pageNumber) {
  if (pageNumber < 1 || pageNumber > 604) {
    throw "Invalid page number. Page number must be between 1 and 604";
  }
  int totalVerseCount = 0;
  for (int i = 0; i < pageData[pageNumber - 1].length; i++) {
    totalVerseCount += int.parse(
      pageData[pageNumber - 1][i]!["end"].toString(),
    );
  }
  return totalVerseCount;
}

///Takes [surahNumber] & [verseNumber] and returns Juz number
int getJuzNumber(int surahNumber, int verseNumber) {
  for (var juz in juz) {
    if (juz["verses"].keys.contains(surahNumber)) {
      if (verseNumber >= juz["verses"][surahNumber][0] &&
          verseNumber <= juz["verses"][surahNumber][1]) {
        return int.parse(juz["id"].toString());
      }
    }
  }
  return -1;
}

///Takes [surahNumber] and returns the Surah name
String getSurahName(int surahNumber) {
  if (surahNumber > 114 || surahNumber <= 0) {
    throw "No Surah found with given surahNumber";
  }
  return surah[surahNumber - 1]['name'].toString();
}

///Takes [surahNumber] returns the Surah name in English
String getSurahNameEnglish(int surahNumber) {
  if (surahNumber > 114 || surahNumber <= 0) {
    throw "No Surah found with given surahNumber";
  }
  return surah[surahNumber - 1]['english'].toString();
}

///Takes [surahNumber] returns the Surah name in Arabic
String getSurahNameArabic(int surahNumber) {
  if (surahNumber > 114 || surahNumber <= 0) {
    throw "No Surah found with given surahNumber";
  }
  return surah[surahNumber - 1]['arabic'].toString();
}

///Takes [surahNumber], [verseNumber] and returns the page number of the Quran
int getPageNumber(int surahNumber, int verseNumber) {
  if (surahNumber > 114 || surahNumber <= 0) {
    throw "No Surah found with given surahNumber";
  }

  for (int pageIndex = 0; pageIndex < pageData.length; pageIndex++) {
    for (
      int surahIndexInPage = 0;
      surahIndexInPage < pageData[pageIndex].length;
      surahIndexInPage++
    ) {
      final e = pageData[pageIndex][surahIndexInPage];
      if (e['surah'] == surahNumber &&
          e['start'] <= verseNumber &&
          e['end'] >= verseNumber) {
        return pageIndex + 1;
      }
    }
  }

  throw "Invalid verse number.";
}

///Takes [surahNumber] and returns the place of revelation (Makkah / Madinah) of the surah
String getPlaceOfRevelation(int surahNumber) {
  if (surahNumber > 114 || surahNumber <= 0) {
    throw "No Surah found with given surahNumber";
  }
  return surah[surahNumber - 1]['place'].toString();
}

///Takes [surahNumber] and returns the count of total Verses in the Surah
int getVerseCount(int surahNumber) {
  if (surahNumber > 114 || surahNumber <= 0) {
    throw "No verse found with given surahNumber";
  }
  return int.parse(surah[surahNumber - 1]['aya'].toString());
}

///Takes [surahNumber], [verseNumber] & [verseEndSymbol] (optional) and returns the Verse in Arabic
String getVerse(
  int surahNumber,
  int verseNumber, {
  bool verseEndSymbol = false,
}) {
  String verse = "";
  for (var i in quranText) {
    if (i['surah_number'] == surahNumber && i['verse_number'] == verseNumber) {
      verse = i['content'].toString();
      break;
    }
  }

  if (verse == "") {
    throw "No verse found with given surahNumber and verseNumber.\n\n";
  }

  return verse + (verseEndSymbol ? getVerseEndSymbol(verseNumber) : "");
}

///Takes [verseNumber], [arabicNumeral] (optional) and returns '۝' symbol with verse number
String getVerseEndSymbol(int verseNumber, {bool arabicNumeral = true}) {
  var arabicNumeric = '';
  var digits = verseNumber.toString().split("").toList();

  if (!arabicNumeral) return '\u06dd${verseNumber.toString()}';

  const Map arabicNumbers = {
    "0": "٠",
    "1": "۱",
    "2": "۲",
    "3": "۳",
    "4": "٤",
    "5": "٥",
    "6": "٦",
    "7": "۷",
    "8": "۸",
    "9": "۹",
  };

  for (var e in digits) {
    arabicNumeric += arabicNumbers[e];
  }

  return '\u06dd$arabicNumeric';
}

String getVerseQCF(
  int surahNumber,
  int verseNumber, {
  bool verseEndSymbol = true,
}) {
  String verse = "";
  for (var i in quranText) {
    if (i['surah_number'] == surahNumber && i['verse_number'] == verseNumber) {
      verse = (verseEndSymbol
          ? i['qcfData'].toString()
          : i['qcfData'].toString().substring(
              0,
              i['qcfData'].toString().length - 1,
            ));
      break;
    }
  }

  if (verse == "") {
    throw "No verse found with given surahNumber and verseNumber.\n\n";
  }

  return verse;
}

String getVerseNumberQCF(
  int surahNumber,
  int verseNumber, {
  bool verseEndSymbol = true,
}) {
  String lastCharacter = "";
  for (var i in quranText) {
    if (i['surah_number'] == surahNumber && i['verse_number'] == verseNumber) {
      lastCharacter = i['qcfData'].toString().substring(
        i['qcfData'].toString().length - 1,
      );
      break;
    }
  }

  if (lastCharacter == "") {
    throw "No verse found with given surahNumber and verseNumber.\n\n";
  }

  return lastCharacter;
}

Map searchWords(String words) {
  List<Map> result = [];
  // print(words);
  for (var i in quranText) {
    // bool exist = false;

    // bool exist = false;
    //  print(DartArabic.stripTashkeel( DartArabic.stripDiacritics(i['content'].toString()
    //         )));

    if (i['text_normal'].toString().toLowerCase().contains(
      words.toLowerCase(),
    )) {
      if (result.length < 50)
        result.add({
          "suraNumber": i["surah_number"],
          "verseNumber": i["verse_number"],
        });

      // print(i['content']);
      // result.add({"surah": i["surah_number"], "verse": i["verse_number"]});
    }
    // result.add({"surah": i["surah_number"], "verse": i["verse_number"]});
  }
  if (result.isEmpty) {
    for (var i in quranText) {
      if (i['content'].toString().toLowerCase().contains(words.toLowerCase())) {
        if (result.length < 50)
          result.add({
            "suraNumber": i["surah_number"],
            "verseNumber": i["verse_number"],
          });

        // print(i['content']);
        // result.add({"surah": i["surah_number"], "verse": i["verse_number"]});
      }
    }
  }

  return {"occurences": result.length, "result": result};
}

/// Converts Quran text to a normalized form suitable for search/comparison.
///
/// Removes koranic annotations, tatweel, tashkeel, and unifies certain letters
/// (e.g. ya/hamza forms, alif variants). This is useful before calling
/// `searchWords(…)` or for custom search pipelines.
String normalise(String input) => input
    .replaceAll('\u0610', '') //ARABIC SIGN SALLALLAHOU ALAYHE WA SALLAM
    .replaceAll('\u0611', '') //ARABIC SIGN ALAYHE ASSALLAM
    .replaceAll('\u0612', '') //ARABIC SIGN RAHMATULLAH ALAYHE
    .replaceAll('\u0613', '') //ARABIC SIGN RADI ALLAHOU ANHU
    .replaceAll('\u0614', '') //ARABIC SIGN TAKHALLUS
    //Remove koranic anotation
    .replaceAll('\u0615', '') //ARABIC SMALL HIGH TAH
    .replaceAll(
      '\u0616',
      '',
    ) //ARABIC SMALL HIGH LIGATURE ALEF WITH LAM WITH YEH
    .replaceAll('\u0617', '') //ARABIC SMALL HIGH ZAIN
    .replaceAll('\u0618', '') //ARABIC SMALL FATHA
    .replaceAll('\u0619', '') //ARABIC SMALL DAMMA
    .replaceAll('\u061A', '') //ARABIC SMALL KASRA
    .replaceAll(
      '\u06D6',
      '',
    ) //ARABIC SMALL HIGH LIGATURE SAD WITH LAM WITH ALEF MAKSURA
    .replaceAll(
      '\u06D7',
      '',
    ) //ARABIC SMALL HIGH LIGATURE QAF WITH LAM WITH ALEF MAKSURA
    .replaceAll('\u06D8', '') //ARABIC SMALL HIGH MEEM INITIAL FORM
    .replaceAll('\u06D9', '') //ARABIC SMALL HIGH LAM ALEF
    .replaceAll('\u06DA', '') //ARABIC SMALL HIGH JEEM
    .replaceAll('\u06DB', '') //ARABIC SMALL HIGH THREE DOTS
    .replaceAll('\u06DC', '') //ARABIC SMALL HIGH SEEN
    .replaceAll('\u06DD', '') //ARABIC END OF AYAH
    .replaceAll('\u06DE', '') //ARABIC START OF RUB EL HIZB
    .replaceAll('\u06DF', '') //ARABIC SMALL HIGH ROUNDED ZERO
    .replaceAll('\u06E0', '') //ARABIC SMALL HIGH UPRIGHT RECTANGULAR ZERO
    .replaceAll('\u06E1', '') //ARABIC SMALL HIGH DOTLESS HEAD OF KHAH
    .replaceAll('\u06E2', '') //ARABIC SMALL HIGH MEEM ISOLATED FORM
    .replaceAll('\u06E3', '') //ARABIC SMALL LOW SEEN
    .replaceAll('\u06E4', '') //ARABIC SMALL HIGH MADDA
    .replaceAll('\u06E5', '') //ARABIC SMALL WAW
    .replaceAll('\u06E6', '') //ARABIC SMALL YEH
    .replaceAll('\u06E7', '') //ARABIC SMALL HIGH YEH
    .replaceAll('\u06E8', '') //ARABIC SMALL HIGH NOON
    .replaceAll('\u06E9', '') //ARABIC PLACE OF SAJDAH
    .replaceAll('\u06EA', '') //ARABIC EMPTY CENTRE LOW STOP
    .replaceAll('\u06EB', '') //ARABIC EMPTY CENTRE HIGH STOP
    .replaceAll('\u06EC', '') //ARABIC ROUNDED HIGH STOP WITH FILLED CENTRE
    .replaceAll('\u06ED', '') //ARABIC SMALL LOW MEEM
    //Remove tatweel
    .replaceAll('\u0640', '')
    //Remove tashkeel
    .replaceAll('\u064B', '') //ARABIC FATHATAN
    .replaceAll('\u064C', '') //ARABIC DAMMATAN
    .replaceAll('\u064D', '') //ARABIC KASRATAN
    .replaceAll('\u064E', '') //ARABIC FATHA
    .replaceAll('\u064F', '') //ARABIC DAMMA
    .replaceAll('\u0650', '') //ARABIC KASRA
    .replaceAll('\u0651', '') //ARABIC SHADDA
    .replaceAll('\u0652', '') //ARABIC SUKUN
    .replaceAll('\u0653', '') //ARABIC MADDAH ABOVE
    .replaceAll('\u0654', '') //ARABIC HAMZA ABOVE
    .replaceAll('\u0655', '') //ARABIC HAMZA BELOW
    .replaceAll('\u0656', '') //ARABIC SUBSCRIPT ALEF
    .replaceAll('\u0657', '') //ARABIC INVERTED DAMMA
    .replaceAll('\u0658', '') //ARABIC MARK NOON GHUNNA
    .replaceAll('\u0659', '') //ARABIC ZWARAKAY
    .replaceAll('\u065A', '') //ARABIC VOWEL SIGN SMALL V ABOVE
    .replaceAll('\u065B', '') //ARABIC VOWEL SIGN INVERTED SMALL V ABOVE
    .replaceAll('\u065C', '') //ARABIC VOWEL SIGN DOT BELOW
    .replaceAll('\u065D', '') //ARABIC REVERSED DAMMA
    .replaceAll('\u065E', '') //ARABIC FATHA WITH TWO DOTS
    .replaceAll('\u065F', '') //ARABIC WAVY HAMZA BELOW
    .replaceAll('\u0670', '') //ARABIC LETTER SUPERSCRIPT ALEF
    //Replace Waw Hamza Above by Waw
    .replaceAll('\u0624', '\u0648')
    //Replace Ta Marbuta by Ha
    .replaceAll('\u0629', '\u0647')
    //Replace Ya
    // and Ya Hamza Above by Alif Maksura
    .replaceAll('\u064A', '\u0649')
    .replaceAll('\u0626', '\u0649')
    // Replace Alifs with Hamza Above/Below
    // and with Madda Above by Alif
    .replaceAll('\u0622', '\u0627')
    .replaceAll('\u0623', '\u0627')
    .replaceAll('\u0625', '\u0627');

/// Removes Arabic diacritics (tashkeel) from the input text.
///
/// Keeps base letters and removes characters such as Fatha, Damma, Kasra,
/// Shadda and tanwin marks. Helpful for lightweight fuzzy matching.
String removeDiacritics(String input) {
  Map<String, String> diacriticsMap = {
    'َ': '', // Fatha
    'ُ': '', // Damma
    'ِ': '', // Kasra
    'ّ': '', // Shadda
    'ً': '', // Tanwin Fatha
    'ٌ': '', // Tanwin Damma
    'ٍ': '', // Tanwin Kasra
  };

  // Create a regular expression pattern that matches Arabic diacritics
  String diacriticsPattern = diacriticsMap.keys
      .map((e) => RegExp.escape(e))
      .join('|');
  RegExp exp = RegExp('[$diacriticsPattern]');

  // Remove diacritics using the regular expression
  String textWithoutDiacritics = input.replaceAll(exp, '');

  return textWithoutDiacritics;
}
