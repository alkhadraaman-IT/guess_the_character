import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/player.dart';
import '../game/game_screen.dart';
import 'widgets/final_hero_result_dialog.dart';
import 'widgets/item_card.dart';
import 'widgets/out_player_result_dialog.dart';

class VotingScreen extends StatefulWidget {
  final List<Player> players;
  final int outPlayerId;
  final String outPlayerName;
  final String hero;
  final String info;
  final Map<String, String> allHeroesInStack;

  const VotingScreen({
    super.key, required this.players, required this.outPlayerId,
    required this.outPlayerName, required this.hero, required this.info,
    required this.allHeroesInStack,
  });

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  bool isOutPlayerIdentified = false;

  void _onVote(Player selected) async {
    final correct = selected.id == widget.outPlayerId;
    await OutPlayerResultDialog.show(
      context,
      correct: correct,
      selectedName: selected.name,
      actualOutName: widget.outPlayerName,
    );
    if (mounted) setState(() => isOutPlayerIdentified = true);
  }

  void _onGuess(String guess) async {
    final correct = guess == widget.hero;
    final restart = await FinalHeroResultDialog.show(
      context, correct: correct, hero: widget.hero, info: widget.info,
    );
    if (!mounted) return;
    if (restart) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => GameScreen(players: widget.players, heroes: widget.allHeroesInStack),
        ),
        (route) => route.isFirst,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = width > 800 ? 4 : (width > 500 ? 3 : 2);
    final heroNames = widget.allHeroesInStack.keys.toList();

    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(
        title: Text(isOutPlayerIdentified ? 'تحدي الأبطال' : 'كشف المستور'),
        backgroundColor: Colors.transparent, elevation: 0,
        foregroundColor: AppTheme.historyGreen,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Positioned(
              bottom: -20, left: -20,
              child: Opacity(opacity: 0.5,
                  child: Image.asset('assets/knights.jpg', height: 300)),
            ),
            Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: isOutPlayerIdentified
                      ? Image.asset('assets/logo.jpg', height: 200,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.shield, size: 100, color: AppTheme.historyGreen))
                      : Container(
                          width: 120, height: 120,
                          decoration: const BoxDecoration(
                              color: AppTheme.historyGreen, shape: BoxShape.circle),
                          child: const Icon(Icons.person_search_rounded,
                              size: 70, color: AppTheme.cardLight),
                        ),
                ),
                const SizedBox(height: 30),
                if (!isOutPlayerIdentified) ...[
                  const Text('صوّتوا الآن.. مين اللي برا السالفة؟',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                          color: AppTheme.ancientBrown)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _buildGrid(
                      count: widget.players.length,
                      cols: cols,
                      builder: (i) => ItemCard(
                        label: widget.players[i].name,
                        onTap: () => _onVote(widget.players[i]),
                      ),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'يا ${widget.outPlayerName}..\n لو عرفت الشخصية بتكون بطل!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                          color: AppTheme.ancientBrown),
                    ),
                  ),
                  Expanded(
                    child: _buildGrid(
                      count: heroNames.length,
                      cols: cols,
                      builder: (i) => ItemCard(
                        label: heroNames[i], isHero: true,
                        onTap: () => _onGuess(heroNames[i]),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid({required int count, required int cols,
      required Widget Function(int) builder}) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols, crossAxisSpacing: 15,
        mainAxisSpacing: 15, childAspectRatio: 2.2,
      ),
      itemCount: count,
      itemBuilder: (_, i) => builder(i),
    );
  }
}