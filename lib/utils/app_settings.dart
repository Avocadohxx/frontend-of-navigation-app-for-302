import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _language = 'en'; // 'en' or 'zh'

  ThemeMode get themeMode => _themeMode;
  String get language => _language;

  AppSettings() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('darkMode') ?? false;
    final lang = prefs.getString('language') ?? 'en';

    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    _language = lang;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', mode == ThemeMode.dark);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    if (_language == lang) return;

    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }
}
