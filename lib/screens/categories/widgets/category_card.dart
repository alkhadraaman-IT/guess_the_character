import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final Map heroes;
  final bool isSelected;
  final VoidCallback onTap, onDelete, onManage;
  const CategoryCard({
    super.key, required this.name, required this.heroes, required this.isSelected,
    required this.onTap, required this.onDelete, required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final active = heroes.values.where((v) => v['selected'] == true).length;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 10 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppTheme.historyGreen : AppTheme.ancientBrown.withValues(alpha: 0.5),
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [AppTheme.cardLight, Color(0xFFE2D1A4)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 5, left: 5,
                child: IconButton(
                  icon: const Icon(Icons.cancel, color: AppTheme.historyGreen, size: 22),
                  onPressed: onDelete,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_edu, size: 40,
                        color: isSelected ? AppTheme.historyGreen : AppTheme.ancientBrown),
                    Text(name, textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 15, color: AppTheme.ancientBrown)),
                    Text('$active من ${heroes.length} مختارة',
                        style: const TextStyle(fontSize: 11, color: AppTheme.historyGreen,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.settings_suggest, color: AppTheme.ancientBrown),
                      onPressed: onManage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}