import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qcf_quran/qcf_quran.dart';

class QuranHomePage extends StatefulWidget {
  const QuranHomePage({super.key});

  @override
  State<QuranHomePage> createState() => _QuranHomePageState();
}

class _QuranHomePageState extends State<QuranHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageviewQuran(
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
    );
  }
}
