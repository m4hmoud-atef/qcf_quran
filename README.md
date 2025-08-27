# qcf_quran

 [English] | [العربية](https://github.com/m4hmoud-atef/qcf_quran/blob/main/README.ar.md)
<p align="center">
  <img src="https://raw.githubusercontent.com/m4hmoud-atef/qcf_quran/main/assets/Screenshot_1756290211.png" alt="Quran page view" width="48%">
  <img src="https://raw.githubusercontent.com/m4hmoud-atef/qcf_quran/main/assets/Screenshot_1756290218.png" alt="Search and verse" width="48%">
</p>

 High-fidelity Quran Mushaf rendering in Flutter using the QCF (Quranic Computer Font) set. This package bundles per-page QCF fonts and utilities so you can:

- Display a full mushaf with right-to-left paging.
- Render any single ayah with the correct per-page ligatures and verse end symbol.
- Query metadata like page numbers, surah/juz names, verse counts, and search the Arabic text.

The package includes the QCF font families and a compact API to build Quran apps quickly.

 Note: This package bundles 604 per-page QCF font files. The package size is large because of these embedded fonts.

## Features

- Page-accurate mushaf using internal QCF fonts (604 pages)
- `PageviewQuran`: horizontally swipeable pages (RTL), per-page fonts applied automatically
- `QcfVerse`: render a single ayah with the correct font and verse number glyph
- Utilities and data:
  - `getPageNumber`, `getPageData`, `getSurahName(…)/Arabic/English`, `getVerse(…)/QCF`, `getJuzNumber(…)`
  - `searchWords(…)` for simple Arabic text search (up to 50 results)
  - Normalization helpers `normalise(…)` and `removeDiacritics(…)`
- Example app showcasing page view, single verse, search, and page jump

## Getting started

1) Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  qcf_quran: ^0.0.2
```

2) The package already bundles the necessary QCF fonts. No extra asset setup is required in your app.

## Usage

### Render a single ayah

```dart
import 'package:flutter/material.dart';
import 'package:qcf_quran/qcf_quran.dart';

class SingleVerseDemo extends StatelessWidget {
  const SingleVerseDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: QcfVerse(
        surahNumber: 1, // Al-Fatiha
        verseNumber: 1,
      ),
    );
  }
}
```

### Full mushaf with paging

```dart
MaterialApp(
  home: Scaffold(
    body: PageviewQuran(
      initialPageNumber: 1,
      onPageChanged: (page) {
        // Handle page change (1..604)
      },
    ),
  ),
);
```

#### Full mushaf with paging (responsive with ScreenUtil)

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qcf_quran/qcf_quran.dart';

// inside a build method (ensure you've initialized ScreenUtil)
PageviewQuran(
  initialPageNumber: 1,

  ///sp for responsiveness
  sp: 1.sp,

  ///h for responsiveness
  h: 1.h,
  textColor: Colors.black,
  onLongPress: (surah, verse) {
    print("Long Pressed on verse $surah:$verse");
  },
  onLongPressUp: (surah, verse) {
    print("Long Press Up on verse $surah:$verse");
  },
  onLongPressCancel: (surah, verse) {
    print("Long Press Cancel on verse $surah:$verse");
  },
  onLongPressDown: (surah, verse, details) {
    print(
        "Long Press Down on verse $surah:$verse @ ${details.globalPosition}");
  },
),
```

### Querying data

```dart
final page = getPageNumber(2, 255); // page of Al-Baqarah 2:255 (Ayat al-Kursi)
final nameAr = getSurahNameArabic(2); // البقرة
final juz = getJuzNumber(2, 255); // 3

final results = searchWords('الرحمن');
// { occurences: <int>, result: [ {suraNumber: 1, verseNumber: 3}, ... ] }
```

## Example app

See `example/` for a runnable demo that uses:

- `PageviewQuran` with RTL paging and per-page fonts
- `QcfVerse` to show a single ayah
- Page jump dialog and a basic Arabic search powered by `searchWords(…)`

Run it with:

```bash
flutter run -d <device>
```

## Screenshots

<p align="center">
  <img src="https://raw.githubusercontent.com/m4hmoud-atef/qcf_quran/main/assets/Screenshot_1756290211.png" alt="Quran page view" width="48%">
  <img src="https://raw.githubusercontent.com/m4hmoud-atef/qcf_quran/main/assets/Screenshot_1756290218.png" alt="Search and verse" width="48%">
</p>

## API overview

- Rendering widgets:
  - `QcfVerse(surahNumber, verseNumber, fontSize?, textColor?, backgroundColor?, …)`
  - `PageviewQuran(initialPageNumber?, controller?, onPageChanged?, fontSize?, textColor?, pageBackgroundColor?, verseBackgroundColor?, onLongPress?, …)`
- Data & utilities:
  - Counts: `totalPagesCount`, `totalSurahCount`, `totalJuzCount`, `totalVerseCount`
  - Lookup: `getPageData(page)`, `getPageNumber(surah, verse)`, `getVerse(…)/getVerseQCF(…)`, `getVerseNumberQCF(…)`
  - Names: `getSurahName(…)/English/Arabic`, `getPlaceOfRevelation(…)`
  - Search: `searchWords(…)`
  - Text helpers: `normalise(…)`, `removeDiacritics(…)`

## Notes

- The fonts are page-specific. Always use the page’s font family (handled internally by `QcfVerse` and `PageviewQuran`).
- `searchWords(…)` is a simple text search and returns up to 50 matches.
- Directionality is right-to-left for both verse and page view rendering.
- For optimal responsiveness and layout, use `flutter_screenutil` and pass `sp` and `h` to `PageviewQuran` (e.g., `sp: 1.sp`, `h: 1.h`). Ensure ScreenUtil is initialized in your app.

## QCF fonts

- This package bundles 604 per-page QCF font files as WOFF under families named `QCF_P001` … `QCF_P604`.
- Verse-related glyphs (e.g., basmala/verse marks) are provided via the `QCF_BSML` family.
- Widgets `QcfVerse` and `PageviewQuran` resolve and apply the correct per-page family for you; no manual font selection is needed.
- Avoid mixing fonts across pages. Using the page’s matching family ensures ligatures and glyph positions match the official mushaf.

## License

MIT for code. QCF fonts are provided by King Fahd Complex for the Printing of the Holy Quran (KFGQPC). Ensure you comply with their terms when distributing applications.

## Credits

- QCF fonts by KFGQPC
- Data mapping for pages, surahs, and juz sourced from included datasets in `lib/src/data/`