import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qcf_quran/qcf_quran.dart';

/// Example page demonstrating the QcfVerses widget
class QcfVersesExamplePage extends StatefulWidget {
  const QcfVersesExamplePage({super.key});

  @override
  State<QcfVersesExamplePage> createState() => _QcfVersesExamplePageState();
}

class _QcfVersesExamplePageState extends State<QcfVersesExamplePage> {
  int selectedTheme = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QcfVerses Examples'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              '📖 QcfVerses Widget',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Render multiple verses from a single surah with proper QCF fonts, '
              'alignment, and responsive sizing.',
            ),
            const Divider(height: 32),

            // Example 1: Al-Fatiha (Full Surah)
            _buildExampleCard(
              title: '1. Al-Fatiha (Full Surah)',
              description: 'Renders all 7 verses with responsive sizing',
              child: QcfVerses(
                surahNumber: 1,
                firstVerse: 1,
                lastVerse: 7,
                sp: 1.2.sp,
                h: 1.h,
              ),
            ),

            const SizedBox(height: 24),

            // Example 2: Ayat al-Kursi
            _buildExampleCard(
              title: '2. Ayat al-Kursi (Single Verse)',
              description: 'Surah 2, Verse 255',
              child: QcfVerses(
                surahNumber: 2,
                firstVerse: 255,
                lastVerse: 255,
                sp: 1.2.sp,
                h: 1.h,
              ),
            ),

            const SizedBox(height: 24),

            // Example 3: Multiple Verses
            _buildExampleCard(
              title: '3. Al-Kahf (Verses 1-3)',
              description: 'Multiple verses with responsive sizing',
              child: QcfVerses(
                surahNumber: 18,
                firstVerse: 1,
                lastVerse: 3,
                sp: 1.2.sp,
                h: 1.h,
              ),
            ),

            const SizedBox(height: 24),

            // Example 4: Theme Switcher
            _buildExampleCard(
              title: '4. Theme Examples',
              description: 'Switch between different themes',
              child: Column(
                children: [
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 0, label: Text('Light')),
                      ButtonSegment(value: 1, label: Text('Dark')),
                      ButtonSegment(value: 2, label: Text('Sepia')),
                    ],
                    selected: {selectedTheme},
                    onSelectionChanged: (Set<int> selection) {
                      setState(() => selectedTheme = selection.first);
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selectedTheme == 1
                          ? Colors.grey[900]
                          : selectedTheme == 2
                              ? const Color(0xFFF4ECD8)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: QcfVerses(
                      surahNumber: 112,
                      firstVerse: 1,
                      lastVerse: 4,
                      sp: 1.2.sp,
                      h: 1.h,
                      theme: selectedTheme == 1
                          ? QcfThemeData.dark()
                          : selectedTheme == 2
                              ? QcfThemeData.sepia()
                              : const QcfThemeData(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Example 5: Custom Verse Numbers
            _buildExampleCard(
              title: '5. Western-Style Verse Numbers',
              description: 'Custom verse number formatting',
              child: QcfVerses(
                surahNumber: 114,
                firstVerse: 1,
                lastVerse: 6,
                sp: 1.2.sp,
                h: 1.h,
                verseNumberFormatter: (num) => '($num)',
              ),
            ),

            const SizedBox(height: 24),

            // Example 6: Without Verse Numbers
            _buildExampleCard(
              title: '6. Without Verse Numbers',
              description: 'Hide verse numbers',
              child: QcfVerses(
                surahNumber: 103,
                firstVerse: 1,
                lastVerse: 3,
                sp: 1.2.sp,
                h: 1.h,
                showVerseNumbers: false,
              ),
            ),

            const SizedBox(height: 24),

            // Example 7: Verses Spanning Multiple Pages
            _buildExampleCard(
              title: '7. Verses Spanning Multiple Pages',
              description: 'Al-Baqarah 1-10 (spans pages 2-3)',
              child: QcfVerses(
                surahNumber: 2,
                firstVerse: 1,
                lastVerse: 10,
                sp: 1.2.sp,
                h: 1.h,
              ),
            ),

            const SizedBox(height: 40),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // No padding around verses to preserve alignment
          child,
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
