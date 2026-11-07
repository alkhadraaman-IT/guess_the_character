import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import 'discussion_order_card.dart';
import 'large_action_button.dart';

class DiscussionView extends StatelessWidget {
  final List<String> orders;
  final VoidCallback onProceed;
  const DiscussionView({super.key, required this.orders, required this.onProceed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const CircleAvatar(
          radius: 50, backgroundColor: AppTheme.historyGreen,
          child: Icon(Icons.question_answer_outlined, size: 70, color: AppTheme.cardLight),
        ),
        const SizedBox(height: 20),
        const Text('تبادلوا الأسئلة الآن:',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                color: AppTheme.ancientBrown)),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: orders.length,
            itemBuilder: (_, i) => DiscussionOrderCard(index: i, text: orders[i]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25),
          child: LargeActionButton(text: 'انتهينا.. انتقل للتصويت', onPressed: onProceed),
        ),
      ],
    );
  }
}