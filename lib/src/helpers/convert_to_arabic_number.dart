import 'package:flutter/material.dart';
String convertToArabicNumber(String number) {
  // print(number);
  String res = '';

  final arabics = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  for (var element in number.characters) {
    res += arabics[int.parse(element)];
  }

  return res;
}



