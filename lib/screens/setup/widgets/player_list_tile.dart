import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../models/player.dart';

class PlayerListTile extends StatelessWidget {
  final int index;
  final Player player;
  final VoidCallback onDelete;
  const PlayerListTile(
      {super.key,
      required this.index,
      required this.player,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shadowColor: AppTheme.ancientBrown.withValues(alpha: 0.2),
      color: AppTheme.creamOverlay,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.historyGreen,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.creamText, width: 2),
          ),
          alignment: Alignment.center,
          child: Text('${index + 1}',
              style: const TextStyle(
                  color: AppTheme.creamText, fontWeight: FontWeight.bold)),
        ),
        title: Text(player.name,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.ancientBrown)),
        trailing: IconButton(
          icon:
              const Icon(Icons.delete_sweep, color: Colors.redAccent, size: 28),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
