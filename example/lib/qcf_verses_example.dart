import 'package:flutter/material.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Example demonstrating the QcfVerses widget usage
class QcfVersesExample extends StatelessWidget {
  const QcfVersesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QcfVerses Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Example 1: Simple usage - Al-Fatiha (full surah)
            _buildExampleCard(
              title: 'Example 1: Al-Fatiha (Full Surah)',
              child: const QcfVerses(
                surahNumber: 1,
                firstVerse: 1,
                lastVerse: 7,
              ),
            ),

            const SizedBox(height: 24),

            // Example 2: Ayat al-Kursi with custom theme
            _buildExampleCard(
              title: 'Example 2: Ayat al-Kursi (Dark Theme)',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QcfVerses(
                  surahNumber: 2,
                  firstVerse: 255,
                  lastVerse: 255,
                  theme: QcfThemeData.dark(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Example 3: Multiple verses with responsive sizing
            _buildExampleCard(
              title: 'Example 3: Al-Kahf (Verses 1-5) - Responsive',
              child: QcfVerses(
                surahNumber: 18,
                firstVerse: 1,
                lastVerse: 5,
                sp: 1.sp, // Responsive scaling
                h: 1.h,
              ),
            ),

            const SizedBox(height: 24),

            // Example 4: Custom verse number formatting
            _buildExampleCard(
              title: 'Example 4: Western-Style Verse Numbers',
              child: QcfVerses(
                surahNumber: 112,
                firstVerse: 1,
                lastVerse: 4,
                verseNumberFormatter: (number) => '($number)',
              ),
            ),

            const SizedBox(height: 24),

            // Example 5: Highlighted verses
            _buildExampleCard(
              title: 'Example 5: Highlighted Verses',
              child: QcfVerses(
                surahNumber: 55,
                firstVerse: 1,
                lastVerse: 5,
                theme: QcfThemeData(
                  verseBackgroundColor: (surah, verse) {
                    // Highlight verse 3
                    if (verse == 3) {
                      return Colors.yellow.withValues(alpha: 0.3);
                    }
                    return null;
                  },
                  verseTextColor: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Example 6: Sepia theme with custom font size
            _buildExampleCard(
              title: 'Example 6: Sepia Theme with Custom Size',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4ECD8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QcfVerses(
                  surahNumber: 36,
                  firstVerse: 1,
                  lastVerse: 3,
                  theme: QcfThemeData.sepia(),
                  fontSize: 28,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Example 7: Verses spanning multiple pages
            _buildExampleCard(
              title: 'Example 7: Verses Spanning Multiple Pages',
              description: 'Al-Baqarah verses 1-10 (spans pages 2-3)',
              child: const QcfVerses(
                surahNumber: 2,
                firstVerse: 1,
                lastVerse: 10,
              ),
            ),

            const SizedBox(height: 24),

            // Example 8: Without verse numbers
            _buildExampleCard(
              title: 'Example 8: Without Verse Numbers',
              child: const QcfVerses(
                surahNumber: 114,
                firstVerse: 1,
                lastVerse: 6,
                showVerseNumbers: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard({
    required String title,
    String? description,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (description != null) ...[
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// Standalone example for screenshot/sharing functionality
/// Similar to the ScreenShotPreviewPage from the user's code
class QcfVersesScreenshotExample extends StatefulWidget {
  const QcfVersesScreenshotExample({super.key});

  @override
  State<QcfVersesScreenshotExample> createState() =>
      _QcfVersesScreenshotExampleState();
}

class _QcfVersesScreenshotExampleState
    extends State<QcfVersesScreenshotExample> {
  int surahNumber = 1;
  int firstVerse = 1;
  int lastVerse = 7;
  int themeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verse Screenshot Example')),
      body: Column(
        children: [
          // Controls
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('From:'),
                    DropdownButton<int>(
                      value: firstVerse,
                      onChanged: (value) {
                        setState(() {
                          firstVerse = value!;
                          if (firstVerse > lastVerse) {
                            lastVerse = firstVerse;
                          }
                        });
                      },
                      items: List.generate(
                        getVerseCount(surahNumber),
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        ),
                      ),
                    ),
                    const Text('To:'),
                    DropdownButton<int>(
                      value: lastVerse,
                      onChanged: (value) {
                        setState(() {
                          lastVerse = value!;
                        });
                      },
                      items: List.generate(
                        getVerseCount(surahNumber),
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Preview
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Surah header
                    Text(
                      getSurahNameArabic(surahNumber),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Verses
                    QcfVerses(
                      surahNumber: surahNumber,
                      firstVerse: firstVerse,
                      lastVerse: lastVerse,
                      sp: 1.sp,
                      h: 1.h,
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),

                    // Footer
                    Text(
                      'Shared with Al Huda',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
