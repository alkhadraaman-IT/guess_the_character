import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';
import '../../models/player.dart';
import '../../utils/safe_value.dart';
import '../game/game_screen.dart';
import 'widgets/add_category_card.dart';
import 'widgets/category_card.dart';
import 'widgets/category_dialogs.dart';
import 'widgets/manage_heroes_dialog.dart';
import 'widgets/select_all_button.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  /// مفتاح الحقبة → خريطة شخصياتها.
  /// القيم محفوظة كـ Map<String, dynamic> (منطقياً)، لكن NullableS بدنا نحرسها.
  Map<String, dynamic> categories = {};
  List<String> selectedCategories = [];

  // ────────────────────────────────────────
  // Lifecycle
  // ────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // ────────────────────────────────────────
  // Persistence
  // ────────────────────────────────────────
  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_categories', json.encode(categories));
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('app_categories');
    if (data == null) return;

    // 🔑 نحوّل أي Map<dynamic, dynamic> قادمة من JSON لـ Map<String, dynamic>
    final Map<String, dynamic> decoded = json.decode(data);
    final Map<String, dynamic> normalized = {};
    decoded.forEach((catName, rawHeroes) {
      if (rawHeroes is Map) {
        final Map<String, dynamic> heroes = {};
        rawHeroes.forEach((heroName, heroData) {
          if (heroData is Map) {
            heroes[heroName.toString()] = <String, dynamic>{
              'info': heroData['info'],
              'selected': heroData['selected'] ?? true,
            };
          }
        });
        normalized[catName.toString()] = heroes;
      }
    });

    if (!mounted) return;
    setState(() => categories = normalized);
  }

  // ────────────────────────────────────────
  // Mutations
  // ────────────────────────────────────────
  void _notifyChanged() {
    setState(() {});
    _saveCategories();
  }

  void _toggleCategory(String name) {
    setState(() {
      if (selectedCategories.contains(name)) {
        selectedCategories.remove(name);
      } else {
        selectedCategories.add(name);
      }
    });
  }

  void _deleteCategory(String name) {
    setState(() {
      categories.remove(name);
      selectedCategories.remove(name);
    });
    _saveCategories();
  }

  void _addCategory(String name) {
    // 🔑 <String, dynamic>{} صراحةً — تجنب _Map<dynamic, dynamic>
    setState(() => categories[name] = <String, dynamic>{});
    _saveCategories();
  }

  void _selectAll() {
    setState(() {
      if (categories.isNotEmpty &&
          selectedCategories.length == categories.length) {
        selectedCategories.clear();
      } else {
        selectedCategories = categories.keys.toList();
      }
    });
  }

  // ────────────────────────────────────────
  // Start game
  // ────────────────────────────────────────
  void _startGame(List<Player> players) {
    if (selectedCategories.isEmpty) return;

    final Map<String, String> finalHeroes = {};
    for (final cat in selectedCategories) {
      final dynamic rawHeroes = categories[cat];
      if (rawHeroes is! Map) continue;

      rawHeroes.forEach((key, value) {
        if (value is Map && value['selected'] == true) {
          finalHeroes[key.toString()] = safeString(value['info']);
        }
      });
    }

    if (finalHeroes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار شخصية واحدة على الأقل من الحقب المختارة!'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(players: players, heroes: finalHeroes),
      ),
    );
  }

  // ────────────────────────────────────────
  // Build
  // ────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    final List<Player> players =
        args is List<Player> ? args : const <Player>[];

    final double width = MediaQuery.of(context).size.width;
    final int cols = width > 900 ? 4 : (width > 600 ? 3 : 2);
    final bool allSelected = categories.isNotEmpty &&
        selectedCategories.length == categories.length;

    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(
        title: const Text(
          'حقب السالفة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.historyGreen,
        actions: [
          SelectAllButton(allSelected: allSelected, onPressed: _selectAll),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(15),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.85,
                ),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  // بطاقة "إضافة حقبة" دائماً أولاً
                  if (index == 0) {
                    return AddCategoryCard(
                      onTap: () =>
                          CategoryDialogs.showAdd(context, _addCategory),
                    );
                  }

                  final String name = categories.keys.elementAt(index - 1);
                  final Map<dynamic, dynamic> heroes =
                      categories[name] as Map<dynamic, dynamic>;

                  return CategoryCard(
                    name: name,
                    heroes: heroes,
                    isSelected: selectedCategories.contains(name),
                    onTap: () => _toggleCategory(name),
                    onDelete: () => CategoryDialogs.showDelete(
                      context,
                      name,
                      () => _deleteCategory(name),
                    ),
                    onManage: () => ManageHeroesDialog.show(
                      context,
                      catName: name,
                      heroes: heroes, // 🔑 نفس المرجع — التعديلات تنعكس
                      onChanged: _notifyChanged,
                    ),
                  );
                },
              ),
            ),
            _buildStartButton(players),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────
  // Start button
  // ────────────────────────────────────────
  Widget _buildStartButton(List<Player> players) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed:
            selectedCategories.isEmpty ? null : () => _startGame(players),
        child: const Text(
          'ابدأ اللعب بالشخصيات المختارة',
          textAlign: TextAlign.center, // ✅ توسيط
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.creamText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}