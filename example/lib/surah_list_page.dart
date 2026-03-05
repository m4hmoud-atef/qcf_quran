import 'package:example/quran_home_page.dart';
import 'package:flutter/material.dart';
import 'package:qcf_quran/qcf_quran.dart';

class SurahListPage extends StatelessWidget {
  const SurahListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Surah List"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.separated(
        itemCount: 114,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final surahId = index + 1;
          final nameArabic = getSurahNameArabic(surahId);
          final nameEnglish = getSurahNameEnglish(surahId);
          final verseCount = getVerseCount(surahId);
          final place = getPlaceOfRevelation(surahId);

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                surahId.toString(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            title: Row(
              children: [
                Text(nameEnglish),
                const Spacer(),
                Text(
                  nameArabic,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'traditional_arabic', // Optional: if traditional arabic font is available
                  ),
                ),
              ],
            ),
            subtitle: Text("$place • $verseCount Verses"),
            onTap: () {
              final pageNumber = getPageNumber(surahId, 1);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuranHomePage(initialPageNumber: pageNumber),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
