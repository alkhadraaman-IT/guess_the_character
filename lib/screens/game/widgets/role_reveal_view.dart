import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../models/player.dart';
import 'large_action_button.dart';
import 'role_card.dart';

class RoleRevealView extends StatelessWidget {
  final Player currentPlayer;
  final bool isOutOfLoop;
  final String selectedHero;
  final bool showRole, isLastPlayer;
  final Animation<double> scaleAnimation, fadeAnimation;
  final AnimationController revealController;
  final VoidCallback onReveal, onNext, onStartDiscussion;

  const RoleRevealView({
    super.key,
    required this.currentPlayer,
    required this.isOutOfLoop,
    required this.selectedHero,
    required this.showRole,
    required this.isLastPlayer,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.revealController,
    required this.onReveal,
    required this.onNext,
    required this.onStartDiscussion,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('دور البطل: ${currentPlayer.name}',
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.ancientBrown)),
            const SizedBox(height: 30),
            AnimatedBuilder(
              animation: revealController,
              builder: (_, child) => Opacity(
                opacity: fadeAnimation.value,
                child: Transform.scale(scale: scaleAnimation.value, child: child),
              ),
              child: showRole
                  ? RoleCard(isOut: isOutOfLoop, hero: selectedHero)
                  : const SizedBox(height: 150),
            ),
            const SizedBox(height: 30),
            if (!showRole) LargeActionButton(text: 'اكشف دوري', onPressed: onReveal),
            if (showRole)
              LargeActionButton(
                text: isLastPlayer ? 'بدء النقاش' : 'مرر للجهاز للتالي',
                onPressed: isLastPlayer ? onStartDiscussion : onNext,
              ),
          ],
        ),
      ),
    );
  }
}