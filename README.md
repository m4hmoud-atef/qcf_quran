# qcf_quran 📖

[![Pub Version](https://img.shields.io/pub/v/qcf_quran)](https://pub.dev/packages/qcf_quran)
[![License](https://img.shields.io/github/license/m4hmoud-atef/qcf_quran)](https://github.com/m4hmoud-atef/qcf_quran/blob/main/LICENSE)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Support-yellow.svg)](https://buymeacoffee.com/m4hmoudd)

[English] | [العربية](https://github.com/m4hmoud-atef/qcf_quran/blob/main/README.ar.md)

<p align="center">
  <img src="https://raw.githubusercontent.com/m4hmoud-atef/qcf_quran/main/assets/Screenshot_1756290211.png" alt="Quran page view" width="48%">
  <img src="https://raw.githubusercontent.com/m4hmoud-atef/qcf_quran/main/assets/Screenshot_1756290218.png" alt="Search and verse" width="48%">
</p>

**High-fidelity Quran Mushaf rendering in Flutter.**

`qcf_quran` bundles **604 page-specific QCF fonts** to ensure every page looks exactly like the printed Madani Mushaf, with correct ligatures, verse endings, and scaling.

> **Note**: This package includes ~600 font files (one for each page), which increases the package size but guarantees 100% accurate rendering without internet dependency.

---

## 📑 Table of Contents

- [Features](#-features)
- [Getting Started](#-getting-started)
- [Basic Usage](#-basic-usage)
  - [Full Quran](#full-quran-pageview)
  - [Single Verse](#single-verse-rendering)
  - [Responsive Design](#responsive-design-screenutil)
  - [Data & Search](#data--search)
- [Advanced Usage](#-advanced-usage)
  - [Customization (Themes)](#customization-themes)
  - [Developer Controls](#developer-controls)
  - [Custom Builders](#custom-builders)
  - [State Management](#state-management)
- [Technical Details](#-technical-details-qcf-fonts)
- [Support](#-support)

---

## ✨ Features

- **Page-Accurate Rendering**: 604 QCF fonts for exact Mushaf replication.
- **`PageviewQuran` Widget**: Ready-to-use horizontally swipeable Quran (RTL format).
- **`QcfVerse` Widget**: Render any single ayah with the correct font and verse number glyph.
- **Rich Data API**: Get page numbers, surah names (EN/AR), juz info, verses, and more.
- **Search**: Built-in simple Arabic text search.
- **Full Customization**: Control colors, backgrounds, headers, and interactions via `QcfThemeData`.

---

## 🚀 Getting Started

1.  **Add dependency**:
    ```yaml
    dependencies:
      qcf_quran: ^0.0.2
    ```

2.  **Use it**: The fonts are bundled, so no extra asset configuration is needed!

---

## 🟢 Basic Usage

### Full Quran PageView
The easiest way to display the Quran. Handles paging, fonts, and layout automatically.

```dart
import 'package:qcf_quran/qcf_quran.dart';

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: PageviewQuran(
      initialPageNumber: 1, // Start at Al-Fatiha
      onPageChanged: (page) {
        print("Current page: $page");
      },
    ),
  );
}
```

### Single Verse Rendering
Render a specific verse anywhere in your app.

```dart
QcfVerse(
  surahNumber: 2, // Al-Baqarah
  verseNumber: 255, // Ayat al-Kursi
)
```

### Responsive Design (ScreenUtil)
For best results across mobile and tablets, use `flutter_screenutil` and pass scale factors:

```dart
PageviewQuran(
  sp: 1.sp, // Scale font size
  h: 1.h,   // Scale line height/spacing
)
```

### Data & Search
Access Quranic data easily:

```dart
// Get Surah Name
print(getSurahNameArabic(114)); // "الناس"

// Get Page Number for a Verse
print(getPageNumber(2, 255)); // 42

// Search Arabic Text
final results = searchWords("الرحمن");
// Returns: { "occurences": 57, "result": [ { "suraNumber": 1, "verseNumber": 3 }, ... ] }
```

---

## 🔴 Advanced Usage

### Customization (Themes)
Customize colors, fonts, and visibility using `QcfThemeData`.

```dart
// Built-in Themes
PageviewQuran(theme: QcfThemeData.dark())
PageviewQuran(theme: QcfThemeData.sepia())

// Custom Theme
PageviewQuran(
  theme: QcfThemeData(
    verseTextColor: Colors.indigo.shade900,
    pageBackgroundColor: Colors.grey.shade50,
    verseBackgroundColor: (surah, verse) {
      if (surah == 18 && verse == 1) return Colors.yellow.withOpacity(0.3);
      return null;
    },
  ),
)
```

### Developer Controls
Handle user interactions and scroll physics.

```dart
PageviewQuran(
  // Interactions
  onTap: (surah, verse) => print("Tapped $surah:$verse"),
  onLongPress: (surah, verse) => print("Long pressed $surah:$verse"),
  
  // Physics
  physics: BouncingScrollPhysics(), // e.g. iOS style bounce
)
```

### Custom Builders
Replace default elements (headers, basmala, verse numbers) with your own widgets.

```dart
final theme = QcfThemeData(
  // Use an image for Basmala
  basmalaBuilder: (surah) => Image.asset('assets/bismillah.png'),
  
  // Custom verse number styling
  verseNumberBuilder: (surah, verse, text) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  },
  
  // Custom Surah Header
  customHeaderBuilder: (surah) => MyCustomHeaderWidget(surah),
);
```

### State Management
For full control (e.g., using **Bloc** or **Provider**), use the `QcfPage` widget directly to build your own `PageView`.

```dart
PageView.builder(
  itemBuilder: (context, index) {
    return BlocProvider(
      create: (_) => PageBloc(),
      child: BlocBuilder<PageBloc, PageState>(
        builder: (context, state) {
          return QcfPage(
            pageNumber: index + 1,
            theme: state.theme, 
            onTap: (s, v) => context.read<PageBloc>().add(VerseTapped(s, v)),
          );
        },
      ),
    );
  },
)
```

---

## ℹ️ Technical Details (QCF Fonts)

- **Fonts**: Bundles 604 WOFF font files (`QCF_P001` to `QCF_P604`).
- **Glyphs**: Verse numbers and symbols are handled via the `QCF_BSML` family.
- **Logic**: `QcfVerse` automatically resolves the correct font family for the requested page number.
- **Normalization**: Helper functions `normalise()` and `removeDiacritics()` are available for search implementation.

---

## ❤️ Support

If you find this package useful, consider buying me a coffee!

<a href="https://buymeacoffee.com/m4hmoudd" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

---

## 📜 License & Credits

- **Code**: MIT License.
- **Fonts**: **King Fahd Complex for the Printing of the Holy Quran (KFGQPC)**.
- **Data**: Mapped internally from standard datasets.