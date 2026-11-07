import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class LargeActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  const LargeActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isPrimary ? AppTheme.historyGreen : AppTheme.ancientBrown,
        foregroundColor: isPrimary ? AppTheme.cardLight : AppTheme.creamText,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Text(text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
