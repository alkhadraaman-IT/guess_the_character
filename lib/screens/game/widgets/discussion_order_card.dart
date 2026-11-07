import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class DiscussionOrderCard extends StatelessWidget {
  final int index;
  final String text;
  const DiscussionOrderCard({super.key, required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      color: AppTheme.cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppTheme.ancientBrown, width: 1),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.ancientBrown,
          child: Text('${index + 1}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        title: Text(text, style: const TextStyle(fontSize: 18, color: AppTheme.ancientBrown)),
      ),
    );
  }
}