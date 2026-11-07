import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class RoleCard extends StatelessWidget {
  final bool isOut;
  final String hero;
  const RoleCard({super.key, required this.isOut, required this.hero});

  @override
  Widget build(BuildContext context) {
    final textColor = isOut
        ? Colors.red.shade900
        : AppTheme.historyGreen.withValues(alpha: 0.9);
    final cardColor = isOut ? const Color(0xFFFDECEA) : AppTheme.creamText;

    return Card(
      elevation: 8,
      shadowColor: AppTheme.ancientBrown.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(
            color: isOut ? Colors.redAccent : AppTheme.historyGreen,
            width: 2),
      ),
      child: Container(
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.creamText, cardColor],
          ),
        ),
        child: Column(
          children: [
            Icon(isOut ? Icons.search_off_rounded : Icons.shield_rounded,
                size: 50, color: textColor),
            const SizedBox(height: 15),
            Text(isOut ? 'أنت برا السالفة!' : 'أنت داخل السالفة',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
            if (!isOut) ...[
              const SizedBox(height: 15),
              const Divider(color: AppTheme.ancientBrown, thickness: 1),
              const Text('البطل التاريخي هو:',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.ancientBrown,
                      fontStyle: FontStyle.italic)),
              Text(hero,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.historyGreen)),
            ],
          ],
        ),
      ),
    );
  }
}