import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class SelectAllButton extends StatelessWidget {
  final bool allSelected;
  final VoidCallback onPressed;
  const SelectAllButton({super.key, required this.allSelected, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.historyGreen)),
        onPressed: onPressed,
        child: Text(allSelected ? 'إلغاء الكل' : 'تحديد الكل',
            style: const TextStyle(color: AppTheme.historyGreen, fontSize: 12)),
      ),
    );
  }
}