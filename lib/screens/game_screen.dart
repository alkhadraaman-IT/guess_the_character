import 'dart:math';

import 'package:flutter/material.dart';

import 'voting_screen.dart';

class GameScreen extends StatefulWidget {
  final List<String> players;
  final Map<String, String> heroes;

  const GameScreen({super.key, required this.players, required this.heroes});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  int currentPlayerIndex = 0;
  bool showRole = false;
  bool isDiscussionPhase = false;

  late String outOfLoopPlayer;
  late String selectedHero;
  late String heroInfo;
  List<String> discussionOrders = [];

  late AnimationController _revealController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  static const Color creamBackground = Color(0xFFE9E0C9);
  static const Color historyGreen = Color(0xFF2D5A27);
  static const Color ancientBrown = Color(0xFF5D4037);
  static const Color cardLight = Color(0xFFF5F1E3);

  @override
  void initState() {
    super.initState();
    _setupGame();
    _setupAnimations();
  }

  void _setupGame() {
    if (widget.heroes.isEmpty) return;
    final List<String> heroKeys = widget.heroes.keys.toList();
    selectedHero = heroKeys[Random().nextInt(heroKeys.length)];
    heroInfo = widget.heroes[selectedHero]!;

    final List<String> shuffled = List.from(widget.players);
    shuffled.shuffle();
    outOfLoopPlayer = shuffled.first;

    final List<String> questioners = List.from(widget.players);
    questioners.shuffle();
    for (int i = 0; i < questioners.length; i++) {
      final String asker = questioners[i];
      final String target = widget
          .players[(widget.players.indexOf(asker) + 1) % widget.players.length];
      discussionOrders.add('يا $asker، اسأل $target سؤالاً!');
    }
  }

  void _setupAnimations() {
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  void _revealRole() {
    setState(() => showRole = true);
    _revealController.forward();
  }

  void _nextPlayer() {
    setState(() {
      currentPlayerIndex++;
      showRole = false;
      _revealController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamBackground,
      appBar: AppBar(
        title: Text(isDiscussionPhase ? 'وقت النقاش' : 'كشف الأدوار'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: historyGreen,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: isDiscussionPhase
            ? _buildDiscussionUI()
            : _buildRoleSelectionUI(),
      ),
    );
  }

  Widget _buildRoleSelectionUI() {
    final String currentPlayer = widget.players[currentPlayerIndex];
    final bool isOut = (currentPlayer == outOfLoopPlayer);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'دور البطل: $currentPlayer',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: ancientBrown,
              ),
            ),
            const SizedBox(height: 30),
            AnimatedBuilder(
              animation: _revealController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: showRole
                  ? _buildRoleCard(isOut)
                  : const SizedBox(height: 150),
            ),
            const SizedBox(height: 30),
            if (!showRole)
              _buildLargeButton('اكشف دوري', _revealRole, isPrimary: true),
            if (showRole)
              _buildLargeButton(
                currentPlayerIndex < widget.players.length - 1
                    ? 'مرر للجهاز للتالي'
                    : 'بدء النقاش',
                currentPlayerIndex < widget.players.length - 1
                    ? _nextPlayer
                    : () => setState(() => isDiscussionPhase = true),
                isPrimary: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(bool isOut) {
    final Color cardColor =
        isOut ? const Color(0xFFFDECEA) : const Color(0xFFF5F1E3);
    final Color textColor =
        isOut ? Colors.red.shade900 : historyGreen.withValues(alpha: 0.9);

    return Card(
      elevation: 8,
      shadowColor: ancientBrown.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(
          color: isOut ? Colors.redAccent : historyGreen,
          width: 2,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(35.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFF5F1E3), cardColor],
          ),
        ),
        child: Column(
          children: [
            Icon(
              isOut ? Icons.search_off_rounded : Icons.shield_rounded,
              size: 50,
              color: textColor,
            ),
            const SizedBox(height: 15),
            Text(
              isOut ? 'أنت برا السالفة!' : 'أنت داخل السالفة',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            if (!isOut) ...[
              const SizedBox(height: 15),
              const Divider(color: ancientBrown, thickness: 1),
              const Text(
                'البطل التاريخي هو:',
                style: TextStyle(
                  fontSize: 14,
                  color: ancientBrown,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                selectedHero,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: historyGreen,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDiscussionUI() {
    return Column(
      children: [
        const SizedBox(height: 30),
        const CircleAvatar(
          radius: 50,
          backgroundColor: historyGreen,
          child: Icon(
            Icons.question_answer_outlined,
            size: 70,
            color: Color(0xFFFFF4D2),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'تبادلوا الأسئلة الآن:',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: ancientBrown,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: discussionOrders.length,
            itemBuilder: (context, i) => Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 3,
              shadowColor: ancientBrown.withValues(alpha: 0.1),
              color: cardLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: ancientBrown, width: 1),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: ancientBrown,
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  discussionOrders[i],
                  style: const TextStyle(
                    fontSize: 18,
                    color: ancientBrown,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: _buildLargeButton(
            'انتهينا.. انتقل للتصويت',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => VotingScreen(
                  players: widget.players,
                  outPlayer: outOfLoopPlayer,
                  hero: selectedHero,
                  info: heroInfo,
                  allHeroesInStack: widget.heroes,
                ),
              ),
            ),
            isPrimary: true,
          ),
        ),
      ],
    );
  }

  Widget _buildLargeButton(
    String text,
    VoidCallback onPressed, {
    required bool isPrimary,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? historyGreen : ancientBrown,
        foregroundColor: isPrimary ? const Color(0xFFFFF4D2) : Colors.white,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 5,
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}