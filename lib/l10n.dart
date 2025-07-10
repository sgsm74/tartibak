import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Number Puzzle',
      'start_game': 'Start Game',
      'settings': 'Settings',
      'select_size': 'Select puzzle size',
      "congrats_title": "🎉 Congrats!",
      "congrats_message": "You solved the puzzle in {moves} moves and {time}.",
      "restart": "Restart",
      "moves": "Moves",
      "time": "Time",
      "dark_theme": "Dark Theme",
      "click_sound": "Click Sound",
      "vibration": "Vibration",
    },
    'fa': {
      'title': 'پازل عددی',
      'start_game': 'شروع بازی',
      'settings': 'تنظیمات',
      'select_size': 'سایز پازل رو انتخاب کن',
      "congrats_title": "🎉 تبریک!",
      "congrats_message": "شما پازل را با {moves} حرکت و در {time} حل کردید.",
      "restart": "شروع دوباره",
      "moves": "حرکت‌ها",
      "time": "زمان",
      "dark_theme": "تم تاریک",
      "click_sound": "صدای کلیک",
      "vibration": "ویبره",
    },
  };

  String? get(String key) {
    return _localizedValues[locale.languageCode]?[key];
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fa'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
