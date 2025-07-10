import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('fa');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'fa'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }
}
