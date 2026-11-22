import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _mode = AppThemeMode.vintage;
  bool _loaded = false;

  AppThemeMode get mode => _mode;
  bool get isAmoled => _mode == AppThemeMode.amoled;
  bool get loaded => _loaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final isAmoled = prefs.getBool('is_amoled_theme') ?? false;
    _mode = isAmoled ? AppThemeMode.amoled : AppThemeMode.vintage;
    _loaded = true;
    notifyListeners();
  }

  Future<void> toggle() async {
    _mode = _mode == AppThemeMode.amoled ? AppThemeMode.vintage : AppThemeMode.amoled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_amoled_theme', isAmoled);
    notifyListeners();
  }

  Future<void> setMode(AppThemeMode mode) async {
    _mode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_amoled_theme', isAmoled);
    notifyListeners();
  }
}
