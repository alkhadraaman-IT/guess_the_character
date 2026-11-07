import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../logic.dart';
import '../../models/player.dart';
import '../voting/voting_screen.dart';
import 'widgets/discussion_view.dart';
import 'widgets/role_reveal_view.dart';

class GameScreen extends StatefulWidget {
  final List<Player> players;
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

  /// nullable لأن setupGame قد تفشل — نتحقق في build.
  GameSetup? _setup;
  late final List<String> discussionOrders;

  late final AnimationController _revealController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _setup = GameLogic.setupGame(widget.players, widget.heroes);

    if (_setup == null) {
      // خروج آمن لو البيانات غير صالحة.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('بيانات اللعبة غير مكتملة.')),
        );
        Navigator.pop(context);
      });
      discussionOrders = const [];
    } else {
      discussionOrders = _buildDiscussionOrders();
    }

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

  List<String> _buildDiscussionOrders() {
    final List<Player> questioners = List<Player>.from(widget.players)..shuffle();
    return questioners.map((asker) {
      final Player next = widget.players[
          (widget.players.indexOf(asker) + 1) % widget.players.length];
      return 'يا ${asker.name}، اسأل ${next.name} سؤالاً!';
    }).toList();
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

  void _goToVoting() {
    final setup = _setup!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VotingScreen(
          players: widget.players,
          outPlayerId: setup.outOfLoopPlayer.id,
          outPlayerName: setup.outOfLoopPlayer.name,
          hero: setup.hero,
          info: setup.heroInfo,
          allHeroesInStack: widget.heroes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final setup = _setup;
    if (setup == null) {
      // بينما ينتظر الـ post-frame pop.
      return const Scaffold(
        backgroundColor: AppTheme.creamBackground,
        body: SizedBox.shrink(),
      );
    }

    final Player currentPlayer = widget.players[currentPlayerIndex];

    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(
        title: Text(isDiscussionPhase ? 'وقت النقاش' : 'كشف الأدوار'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.historyGreen,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: isDiscussionPhase
            ? DiscussionView(
                orders: discussionOrders,
                onProceed: _goToVoting,
              )
            : RoleRevealView(
                currentPlayer: currentPlayer,
                isOutOfLoop: currentPlayer.id == setup.outOfLoopPlayer.id,
                selectedHero: setup.hero,
                showRole: showRole,
                isLastPlayer: currentPlayerIndex >= widget.players.length - 1,
                scaleAnimation: _scaleAnimation,
                fadeAnimation: _fadeAnimation,
                revealController: _revealController,
                onReveal: _revealRole,
                onNext: _nextPlayer,
                onStartDiscussion: () =>
                    setState(() => isDiscussionPhase = true),
              ),
      ),
    );
  }
}