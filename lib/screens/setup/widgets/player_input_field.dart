import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class PlayerInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;
  const PlayerInputField(
      {super.key, required this.controller, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.creamOverlay,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppTheme.ancientBrown, width: 2),
        boxShadow: [
          BoxShadow(
              color: AppTheme.ancientBrown.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextField(
        controller: controller,
        style: const TextStyle(
            color: AppTheme.ancientBrown, fontWeight: FontWeight.bold),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => onAdd(),
        decoration: InputDecoration(
          hintText: 'اكتب اسم لاعب هنا...',
          hintStyle:
              TextStyle(color: AppTheme.ancientBrown.withValues(alpha: 0.5)),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.add_circle,
                size: 40, color: AppTheme.historyGreen),
            onPressed: onAdd,
          ),
        ),
      ),
    );
  }
}
