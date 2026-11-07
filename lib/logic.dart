import 'dart:math';

import 'models/player.dart';

/// نتيجة جولة جديدة — كائن ثابت يحوي كل بيانات الجولة.
/// بديل عن الـ static mutable القديم.
class GameSetup {
  final String hero;
  final String heroInfo;
  final Player outOfLoopPlayer;

  const GameSetup({
    required this.hero,
    required this.heroInfo,
    required this.outOfLoopPlayer,
  });
}

class GameLogic {
  /// ترجع null إذا المدخلات فاضية (لا لاعبين أو لا شخصيات).
  /// caller لازم يتحقق من الـ null قبل الاستخدام.
  static GameSetup? setupGame(
    List<Player> players,
    Map<String, String> heroes,
  ) {
    if (players.isEmpty || heroes.isEmpty) return null;

    final Random random = Random();
    final String heroKey = heroes.keys.elementAt(random.nextInt(heroes.length));
    final Player outPlayer = players[random.nextInt(players.length)];

    return GameSetup(
      hero: heroKey,
      heroInfo: heroes[heroKey] ?? '',
      outOfLoopPlayer: outPlayer,
    );
  }
}