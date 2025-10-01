import 'package:flutter/material.dart';

class ThemeService {
  Future<ThemeMode> themeMode() async => ThemeMode.system;
  Future<void> updateThemeMode(ThemeMode theme) async {
  }
}
