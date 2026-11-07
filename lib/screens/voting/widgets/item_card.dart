import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class ItemCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isHero;

  const ItemCard({
    super.key,
    required this.label,
    required this.onTap,
    this.isHero = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isHero ? AppTheme.historyGreen : AppTheme.creamOverlay,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isHero ? AppTheme.creamText : AppTheme.ancientBrown)),
      ),
    );
  }
}