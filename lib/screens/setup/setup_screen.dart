import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/player.dart';
import 'widgets/empty_players_view.dart';
import 'widgets/player_input_field.dart';
import 'widgets/player_list_tile.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});
  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Player> _players = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addPlayer() {
    final trimmed = _controller.text.trim();
    if (trimmed.isEmpty) {
      return _snack('اكتب اسم اللاعب أولاً');
    }
    if (trimmed.length < 3) {
      return _snack('اسم اللاعب قصير جداً (3 أحرف على الأقل)');
    }
    final lower = trimmed.toLowerCase();
    if (_players.any((p) => p.name.toLowerCase() == lower)) {
      return _snack('هذا الاسم موجود بالفعل، اختر اسماً آخر');
    }
    setState(() => _players.add(Player(name: trimmed)));
    _controller.clear();
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('أبطال اللعبة',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.historyGreen,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset('assets/books.png',
                      height: 300, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 20 + keyboardHeight),
              child: Column(
                children: [
                  PlayerInputField(
                    controller: _controller,
                    onAdd: _addPlayer,
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: _players.isEmpty
                        ? const EmptyPlayersView()
                        : ListView.builder(
                            itemCount: _players.length,
                            itemBuilder: (_, i) => PlayerListTile(
                              index: i,
                              player: _players[i],
                              onDelete: () =>
                                  setState(() => _players.removeAt(i)),
                            ),
                          ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: _players.length >= 3
                        ? () => Navigator.pushNamed(context, '/categories',
                            arguments: _players)
                        : null,
                    child: const Text('اختر الحقبة التاريخية',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}