import 'dart:convert';
import 'package:flutter/services.dart';


class L10n {
  static Map<String, String>? _localizedStrings;
  static String currentLocale = 'en'; // Default locale


  static Future<void> load(String locale) async {
    currentLocale = locale; // Update the current locale
    String jsonString = await rootBundle.loadString('assets/lang/$locale.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);


    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }


  static String? translate(String key) {
    return _localizedStrings?[key];
  }
}

