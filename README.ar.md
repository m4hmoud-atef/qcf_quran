# qcf_quran

[English](https://github.com/m4hmoud-atef/qcf_quran/blob/main/README.md) | العربية
<p align="center">
  <img src="https://raw.githubusercontent.com/m4hmoud-atef/qcf_quran/main/screenshots/Screenshot_1756290211.png" alt="عرض صفحة المصحف" width="48%">
  <img src="https://raw.githubusercontent.com/m4hmoud-atef/qcf_quran/main/screenshots/Screenshot_1756290218.png" alt="البحث وعرض الآية" width="48%">
</p>

عرض مصحف عالي الدقة في Flutter باستخدام تقنية **التحميل الديناميكي للخطوط** لتوفير تجربة عالية الجودة مع تقليل حجم الحزمة بشكل كبير. تجمع الحزمة 604 خطاً خاصاً بالصفحات في أرشيف مضغوط واحد، يتم فكه وتحميله عند الطلب لضمان ظهور كل صفحة تماماً مثل المصحف المدني المطبوع.

> [!NOTE]
> تستخدم هذه الحزمة ملف `qcf4.zip` واحد كأصل (asset). يتم استخراج الخطوط إلى ذاكرة تخزين الجهاز عند أول استخدام وتحميلها ديناميكياً، مما يحافظ على حجم الحزمة الأولي أمثلاً مع ضمان عرض دقيق بنسبة 100%.

## المزايا

- **عرض ديناميكي دقيق للصفحات**: يتم تحميل 604 خطاً من نوع QCF عند الطلب عبر استخراج ملف ZIP.
- `PageviewQuran`: صفحات أفقية قابلة للتمرير RTL وتطبيق الخط المناسب لكل صفحة تلقائيًا
- `QcfVerse`: عرض آية واحدة بالخط الصحيح ورقم الآية
- أدوات وبيانات:
  - البحث `searchWords(…)`
  - الأسماء: أسماء السور بالعربية والإنجليزية
  - التهيئة النصية: `normalise(…)` و `removeDiacritics(…)`

## البدء السريع

1) أضف الاعتماد إلى `pubspec.yaml` في تطبيقك:

```yaml
dependencies:
  qcf_quran: ^0.0.2
```

2) **تهيئة الحزمة**: على عكس الإصدارات السابقة، يجب عليك تهيئة تحميل البيانات (فك ضغط GZip) قبل استخدام واجهات برمجة تطبيقات النص أو الخطوط.

    ```dart
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await initQcf(); // تحميل وفك ضغط بيانات القرآن
      runApp(MyApp());
    }
    ```

3) **الاستخدام**: يتم فك ضغط الخطوط ديناميكياً عند أول استخدام!

## الاستخدام

### عرض آية واحدة

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
        surahNumber: 1, // الفاتحة
        verseNumber: 1,
      ),
    );
  }
}
```

### المصحف مع التمرير بين الصفحات

```dart
MaterialApp(
  home: Scaffold(
    body: PageviewQuran(
      initialPageNumber: 1,
      onPageChanged: (page) {
        // التعامل مع تغيّر الصفحة (1..604)
      },
    ),
  ),
);
```

#### المصحف مع التمرير (Responsive باستخدام ScreenUtil)

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qcf_quran/qcf_quran.dart';

// داخل build (تأكد من تهيئة ScreenUtil)
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

## لقطات شاشة

<p align="center">
  <img src="https://raw.githubusercontent.com/m4hmoud-atef/qcf_quran/main/screenshots/Screenshot_1756290211.png" alt="عرض صفحة المصحف" width="48%">
  <img src="https://raw.githubusercontent.com/m4hmoud-atef/qcf_quran/main/screenshots/Screenshot_1756290218.png" alt="البحث وعرض الآية" width="48%">
</p>

## ملاحظات

- الخطوط مخصصة لكل صفحة. استخدم دائمًا عائلة خط الصفحة (يتم ذلك داخليًا في `QcfVerse` و`PageviewQuran`).
- اتجاه العرض من اليمين إلى اليسار.
- لأفضل استجابة وتنسيق، استخدم `flutter_screenutil`، ومرّر `sp` و`h` إلى `PageviewQuran` (مثلًا: `sp: 1.sp`, `h: 1.h`) بعد تهيئة ScreenUtil في تطبيقك.

## خطوط QCF

- **التخزين**: تضم ملف `qcf4.zip` واحداً يحتوي على 604 ملفات خط WOFF.
- **التحميل الديناميكي**: تستخدم `DynamicFontLoader` لاستخراج الخطوط إلى دليل مستندات التطبيق بشكل فوري.
- **الضغط**: أصبح نص القرآن (الذي كان سابقاً ملف Dart بحجم 4.1 ميجابايت) الآن أصل (asset) مضغوط `quran_text.json.gz` (~700 كيلوبايت)، مما يقلل حجم الحزمة بشكل كبير.
- **الرموز**: يتم التعامل مع أرقام الآيات والرموز عبر عائلة `QCF_BSML`.
- **المنطق**: يقوم `QcfVerse` و `QcfVerses` تلقائياً بتحديد عائلة الخط المطابقة وبدء التحميل.

## مرجع فيديو

فيديو توضيحي: https://www.youtube.com/watch?v=s_6cvcFVP54

## 📜 الترخيص والشكر

> **تنبيه**: هذه الحزمة والخطوط المدمجة معها **ليست للاستخدام التجاري**.

- **الكود**: ترخيص MIT.
- **الخطوط**: **مجمع الملك فهد لطباعة المصحف الشريف (KFGQPC)**. يُرجى الالتزام بشروطهم عند توزيع التطبيقات.
- **البيانات**: مصادر البيانات في `lib/src/data/`.

---

## 📞 للتواصل

- **مطور الحزمة (محمود عاطف)**: [GitHub (@m4hmoud-atef)](https://github.com/m4hmoud-atef)
- **مطور الخطوط**: ديسكورد `ayman24x7`
