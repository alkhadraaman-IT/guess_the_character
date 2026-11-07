import 'package:flutter/material.dart';

class AppTheme {
  static const Color historyGreen    = Color(0xFF2D5A27);
  static const Color ancientBrown    = Color(0xFF5D4037);
  static const Color creamBackground = Color(0xFFE9E0C9);
  static const Color cardLight       = Color(0xFFFFF4D2);
  static const Color creamText       = Color(0xFFF5F1E3);
  static const Color softRed         = Color(0xFFE57373);
  static const Color creamOverlay    = Color(0xFFFFFCF5);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Marhey',
    scaffoldBackgroundColor: creamBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: historyGreen,
      centerTitle: true,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.bold, color: historyGreen, fontSize: 32),
      titleLarge:   TextStyle(fontWeight: FontWeight.bold, color: historyGreen, fontSize: 24),
      bodyLarge:    TextStyle(color: ancientBrown, fontSize: 18),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: historyGreen,
        foregroundColor: creamText,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontFamily: 'Marhey', fontSize: 20, fontWeight: FontWeight.bold),
        elevation: 4,
      ),
    ),
  );
}