import 'package:flutter/material.dart';
import '../services/database_service.dart';

class ThemeProvider extends ChangeNotifier {
  late bool _isDarkMode;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _isDarkMode = DatabaseService.isDarkMode();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await DatabaseService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  void setDarkMode(bool value) {
    if (_isDarkMode != value) {
      toggleTheme();
    }
  }
}