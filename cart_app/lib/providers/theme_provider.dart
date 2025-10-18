import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

 
class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const _prefsKey = 'theme_mode';

  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

   
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_prefsKey);
    if (savedTheme == 'dark') {
      state = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.system;  
    }
  }

  
  void toggleTheme() {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newTheme;
    _saveTheme(newTheme);
  }

 
  Future<void> _saveTheme(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, theme.toString().split('.').last);
  }

  
  bool get isDarkMode => state == ThemeMode.dark;
}

 
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);