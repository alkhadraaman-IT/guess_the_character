import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class EmptyPlayersView extends StatelessWidget {
  const EmptyPlayersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_edu_sharp, size: 100,
              color: AppTheme.ancientBrown.withValues(alpha: 0.3)),
          const SizedBox(height: 15),
          const Text('مكتب التاريخ فارغ..\nأضف 3 أبطال على الأقل للبدء',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: AppTheme.ancientBrown,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}