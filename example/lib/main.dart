import 'dart:io';

import 'package:example/quran_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qcf_quran/qcf_quran.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      enableScaleText: () => false,
      minTextAdapt: true,
      designSize: const Size(392.72727272727275, 800.7272727272727),
      
      builder: (context, c) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1)),
          child: Platform.isIOS
              ? CupertinoApp(title: 'Quran qcf Demo', home: const MyHomePage())
              : MaterialApp(title: 'Quran qcf Demo', home: const MyHomePage()),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("qcf_quran Demo"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Text(
              "📖 qcf_quran — High-fidelity Quran Mushaf rendering",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              "This package provides rendering widgets, Quran data helpers, "
              "and utilities for search & formatting.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const Divider(height: 32),

            /// Rendering widgets
            Text(
              "🔹 Rendering Widgets",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              "• `QcfVerse` → Render a single ayah\n"
              "• `PageviewQuran` → Full mushaf (604 pages, RTL)",
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const QuranHomePage()),
              ),
              child: const Text(' Quran Home Page'),
            ),
            const Text(
              "Make sure to use screenutil package for responsive design\n adding (1.sp, in sp and 1.h, in h parameters)",
            ),

            const SizedBox(height: 12),

            const SizedBox(height: 12),
            const Text("Example (Surah 2, Verse 255):"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: QcfVerse(
                surahNumber: 2,
                verseNumber: 255,
                sp: 1.sp,
                h: 1.h,
              ),
            ),

            const Divider(height: 32),

            /// Data helpers
            Text(
              "🔹 Data Helpers",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "• Total Pages: $totalPagesCount\n"
              "• Total Surahs: $totalSurahCount\n"
              "• Total Verses: $totalVerseCount\n"
              "• Total Juz: $totalJuzCount\n"
              "• Makki Surahs: $totalMakkiSurahs\n"
              "• Madani Surahs: $totalMadaniSurahs",
            ),

            const Divider(height: 32),

            /// Utility functions
            Text(
              "🔹 Utility Functions",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            _buildCodeExample(
              context,
              "Get Surah Name (Arabic)",
              "getSurahNameArabic(1)",
              getSurahNameArabic(1),
            ),
            _buildCodeExample(
              context,
              "Get Verse (1:7)",
              "getVerse(1, 7)",
              getVerse(1, 7),
            ),
            _buildCodeExample(
              context,
              "Get Verse QCF (1:7)",
              "getVerseQCF(1, 7)",
              getVerseQCF(1, 7),
            ),
            _buildCodeExample(
              context,
              "Find Juz of Verse (2:255)",
              "getJuzNumber(2, 255)",
              getJuzNumber(2, 255).toString(),
            ),

            const Divider(height: 32),

            /// Search
            Text("🔹 Search", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text("Example: Search for 'الرحمن'"),
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                final results = searchWords("الرحمن");
                return Text(
                  "Occurrences: ${results["occurences"]}\n"
                  "First: Surah ${results["result"][0]["suraNumber"]}, "
                  "Ayah ${results["result"][0]["verseNumber"]}",
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Helper to show code + result
  Widget _buildCodeExample(
    BuildContext context,
    String title,
    String code,
    String result,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("▶ $title", style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(code, style: const TextStyle(fontFamily: "monospace")),
          ),
          const SizedBox(height: 6),
          Text("Output: $result"),
        ],
      ),
    );
  }
}
