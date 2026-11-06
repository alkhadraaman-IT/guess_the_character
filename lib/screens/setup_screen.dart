import 'package:flutter/material.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _players = [];

  static const Color creamBackground = Color(0xFFE9E0C9);
  static const Color historyGreen = Color(0xFF2D5A27);
  static const Color ancientBrown = Color(0xFF5D4037);
  static const Color creamText = Color(0xFFF5F1E3);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addPlayer() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() => _players.add(name));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: creamBackground,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'أبطال اللعبة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: historyGreen,
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
                  child: Image.asset(
                    'assets/books.png',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 20 + keyboardHeight,
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: ancientBrown, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: ancientBrown.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        color: ancientBrown,
                        fontWeight: FontWeight.bold,
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _addPlayer(),
                      decoration: InputDecoration(
                        hintText: 'اكتب اسم لاعب هنا...',
                        hintStyle: TextStyle(
                          color: ancientBrown.withValues(alpha: 0.5),
                        ),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            size: 40,
                            color: historyGreen,
                          ),
                          onPressed: _addPlayer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: _players.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            itemCount: _players.length,
                            itemBuilder: (context, i) => _buildPlayerCard(i),
                          ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: _players.length >= 3
                        ? () => Navigator.pushNamed(
                              context,
                              '/categories',
                              arguments: _players,
                            )
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: historyGreen,
                      foregroundColor: creamText,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'اختر الحقبة التاريخية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_edu_sharp,
            size: 100,
            color: ancientBrown.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 15),
          const Text(
            'مكتب التاريخ فارغ..\nأضف 3 أبطال على الأقل للبدء',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: ancientBrown,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(int i) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shadowColor: ancientBrown.withValues(alpha: 0.2),
      color: Colors.white.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: historyGreen,
            shape: BoxShape.circle,
            border: Border.all(color: creamText, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            '${i + 1}',
            style: const TextStyle(
              color: creamText,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        title: Text(
          _players[i],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ancientBrown,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_sweep,
            color: Colors.redAccent,
            size: 28,
          ),
          onPressed: () => setState(() => _players.removeAt(i)),
        ),
      ),
    );
  }
}