import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  ThemeMode get themeMode => _themeMode;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleSound(bool enabled) {
    _soundEnabled = enabled;
    notifyListeners();
  }

  void toggleVibration(bool enabled) {
    _vibrationEnabled = enabled;
    notifyListeners();
  }
}
