import 'package:flutter/material.dart';
import 'package:recipe_swiper/l10n/l10n.dart';


class LocalizationProvider with ChangeNotifier {
  String _currentLocale = 'en';


  String get currentLocale => _currentLocale;


  Future<void> setLocale(String locale) async {
    _currentLocale = locale;
    await L10n.load(locale);
    notifyListeners();
  }
}

