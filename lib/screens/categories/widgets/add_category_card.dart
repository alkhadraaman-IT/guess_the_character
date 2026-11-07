import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class AddCategoryCard extends StatelessWidget {
  final VoidCallback onTap;
  const AddCategoryCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppTheme.creamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.historyGreen, width: 2),
        ),
        child: const Center(
          child: Text('إضافة حقبة',
              style: TextStyle(color: AppTheme.historyGreen, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}