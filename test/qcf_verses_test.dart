import 'package:flutter_test/flutter_test.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:qcf_quran/src/helpers/dynamic_font_loader.dart';
import 'package:flutter/material.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    DynamicFontLoader.isTestMode = true;
    await initQcf();
  });

  group('QcfVerses Widget Tests', () {
    testWidgets('renders single verse correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QcfVerses(surahNumber: 1, firstVerse: 1, lastVerse: 1),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('renders multiple verses correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QcfVerses(surahNumber: 1, firstVerse: 1, lastVerse: 7),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('applies custom theme correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QcfVerses(
              surahNumber: 1,
              firstVerse: 1,
              lastVerse: 7,
              theme: QcfThemeData.dark(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('hides verse numbers when showVerseNumbers is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QcfVerses(
              surahNumber: 1,
              firstVerse: 1,
              lastVerse: 7,
              showVerseNumbers: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('applies custom verse number formatter', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QcfVerses(
              surahNumber: 1,
              firstVerse: 1,
              lastVerse: 7,
              verseNumberFormatter: (number) => '($number)',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('handles verses spanning multiple pages', (
      WidgetTester tester,
    ) async {
      // Al-Baqarah verses 1-10 span pages 2-3
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QcfVerses(surahNumber: 2, firstVerse: 1, lastVerse: 10),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('applies responsive scaling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 500,
                child: QcfVerses(
                  surahNumber: 1,
                  firstVerse: 1,
                  lastVerse: 7,
                  sp: 1.5,
                  h: 1.2,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RichText), findsWidgets);
    });

    test('validates surah number range', () {
      expect(
        () => QcfVerses(surahNumber: 0, firstVerse: 1, lastVerse: 1),
        throwsAssertionError,
      );

      expect(
        () => QcfVerses(surahNumber: 115, firstVerse: 1, lastVerse: 1),
        throwsAssertionError,
      );
    });

    test('validates verse range', () {
      expect(
        () => QcfVerses(surahNumber: 1, firstVerse: 5, lastVerse: 3),
        throwsAssertionError,
      );
    });
  });

  group('QcfVerses Integration Tests', () {
    test('getVerseQCF returns correct data', () {
      final verse = getVerseQCF(1, 1);
      expect(verse, isNotEmpty);
      expect(verse, isA<String>());
    });

    test('getPageNumber returns correct page', () {
      expect(getPageNumber(1, 1), equals(1));
      expect(getPageNumber(2, 255), equals(42)); // Ayat al-Kursi
    });

    test('convertToArabicNumber converts correctly', () {
      expect(convertToArabicNumber('1'), equals('١'));
      expect(convertToArabicNumber('123'), equals('١٢٣'));
    });
  });
}
