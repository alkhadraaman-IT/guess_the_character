import 'package:flutter/material.dart';

class VotingScreen extends StatefulWidget {
  final List<String> players;
  final String outPlayer;
  final String hero;
  final String info;
  final Map<String, String> allHeroesInStack;

  const VotingScreen({
    super.key,
    required this.players,
    required this.outPlayer,
    required this.hero,
    required this.info,
    required this.allHeroesInStack
  });

  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  bool isOutPlayerIdentified = false;

  static const Color historyGreen = Color(0xFF2D5A27);
  static const Color ancientBrown = Color(0xFF5D4037);
  static const Color creamBackground = Color(0xFFE9E0C9);
  static const Color cardLight = Color(0xFFFFF4D2);
  static const Color softRed = Color(0xFFE57373);

  // 1. رسالة كشف الشخص الذي خرج من السالفة
  void _revealOutPlayer(String selectedName) {
    bool correct = (selectedName == widget.outPlayer);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: cardLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Icon(correct ? Icons.celebration : Icons.person_off_rounded,
              size: 70, color: correct ? historyGreen : softRed),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(correct ? "كفووو! كشفتوه" : "أوووه! ظلمتوه",
                  style: TextStyle(color: correct ? historyGreen : softRed, fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(height: 15),
              Text(
                correct
                    ? "فعلاً $selectedName هو اللي كان برا السالفة!"
                    : "للأسف $selectedName  داخل السالفة.. اللي كان برا هو ${widget.outPlayer}!",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: ancientBrown),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: historyGreen,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => isOutPlayerIdentified = true);
              },
              child: const Text("تحدي كشف الشخصية", style: TextStyle(color: Colors.white, fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  // 2. رسالة النتيجة النهائية (احتفال أو إخفاق)
  void _showFinalHeroResult(String selectedHero) {
    bool isHeroCorrect = (selectedHero == widget.hero);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: cardLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          // أيقونات تفاعلية حسب النتيجة
          title: Icon(
            isHeroCorrect ? Icons.celebration_rounded : Icons.hourglass_empty_rounded,
            size: 80,
            color: isHeroCorrect ? historyGreen : ancientBrown,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isHeroCorrect ? "ذكاء أسطوري! حزرتها" : "حظ أوفر.. خذلتك الذاكرة",
                textAlign: TextAlign.center,
                style: TextStyle(color: isHeroCorrect ? historyGreen : softRed, fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 15),
              const Text("الشخصية التاريخية كانت:", style: TextStyle(color: ancientBrown, fontSize: 14)),
              Text(widget.hero, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: historyGreen)),
              const SizedBox(height: 10),
              Text(widget.info, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, color: ancientBrown, fontStyle: FontStyle.italic)),
            ],
          ),
          actions: [
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: historyGreen, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("لعبة جديدة بنفس الأبطال", style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
                  child: const Text("العودة للقائمة الرئيسية", style: TextStyle(color: ancientBrown)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> heroNames = widget.allHeroesInStack.keys.toList();
    double width = MediaQuery.of(context).size.width;
    int crossAxisCount = width > 800 ? 4 : (width > 500 ? 3 : 2);

    return Scaffold(
      backgroundColor: creamBackground,
      appBar: AppBar(
        title: Text(isOutPlayerIdentified ? "تحدي الأبطال" : "كشف المستور"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: historyGreen,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Positioned(
              bottom: -20,
              left: -20,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset('assets/knights.jpg', height: 300),
              ),
            ),

            Column(
              children: [
                const SizedBox(height: 20),
                // تبديل بين أيقونة البحث وشعار التطبيق حسب المرحلة
                Center(
                  child: isOutPlayerIdentified
                      ? Image.asset('assets/logo.jpg', height: 200, errorBuilder: (c,e,s) => const Icon(Icons.shield, size: 100, color: historyGreen))
                      : Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(color: historyGreen, shape: BoxShape.circle),
                    child: const Icon(Icons.person_search_rounded, size: 70, color: Color(0xFFFFF4D2)),
                  ),
                ),
                const SizedBox(height: 30),

                if (!isOutPlayerIdentified) ...[
                  const Text("صوّتوا الآن.. مين اللي برا السالفة؟", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ancientBrown)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 2.2,
                      ),
                      itemCount: widget.players.length,
                      itemBuilder: (context, i) => _buildItemCard(widget.players[i], () => _revealOutPlayer(widget.players[i])),
                    ),
                  )
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("يا ${widget.outPlayer}.. \n لو عرفت الشخصية بتكون بطل!",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ancientBrown)),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 2.2
                      ),
                      itemCount: heroNames.length,
                      itemBuilder: (c, i) => _buildItemCard(heroNames[i], () => _showFinalHeroResult(heroNames[i]), isHero: true),
                    ),
                  )
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(String label, VoidCallback onTap, {bool isHero = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isHero ? historyGreen : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isHero ? Color(0xFFF5F1E3) : ancientBrown
          ),
        ),
      ),
    );
  }
}