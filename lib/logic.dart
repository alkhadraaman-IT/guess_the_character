import 'dart:math';

class GameLogic {
  static String? selectedHero;
  static String? heroInfo;
  static String? outOfLoopPlayer;

  static void setupGame(List<String> players, Map<String, String> heroes) {
    if (players.isEmpty || heroes.isEmpty) return;
    Random random = Random();
    int heroIndex = random.nextInt(heroes.length);
    selectedHero = heroes.keys.elementAt(heroIndex);
    heroInfo = heroes[selectedHero];
    outOfLoopPlayer = players[random.nextInt(players.length)];
  }
}