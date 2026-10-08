import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/categories_screen.dart';

void main() => runApp(const BatalApp());

class BatalApp extends StatelessWidget {
  const BatalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/setup': (context) => SetupScreen(),
        '/categories': (context) => CategoriesScreen(),
      },
    );
  }
}