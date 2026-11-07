import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorialHelper {
  static const String _prefsKey = 'has_seen_tutorial_v1';

  /// ✏️ ضع رابط الفيديو هنا عندما يجهز (يوتيوب / Drive / أي رابط عام).
  /// اتركه فارغاً لعرض تعليمات نصية فقط.
  static String videoUrl = '';

  /// يعرض حوار التعليمات مرة واحدة فقط عند أول فتح للتطبيق.
  static Future<void> maybeShow(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool(_prefsKey) ?? false;
    if (seen || !context.mounted) return;

    await _showInstructionsDialog(context);
    await prefs.setBool(_prefsKey, true);
  }

  /// يفتح حوار التعليمات يدوياً من زر "كيف ألعب؟" في الصفحة الرئيسية.
  static Future<void> openManually(BuildContext context) async {
    await _showInstructionsDialog(context);
  }

  static Future<void> _showInstructionsDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('كيف تلعب؟ 👋'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    '🎯 الهدف: اكتشفوا مين "برا السالفة" قبل ما يكتشف الشخصية التاريخية!'),
                SizedBox(height: 10),
                Text('👥 العدد: 3 لاعبين على الأقل.'),
                SizedBox(height: 10),
                Text(
                    '1️⃣ كل لاعب يفتح دوره على جهازه — الجميع يعرفون الشخصية إلا واحد.'),
                SizedBox(height: 10),
                Text(
                    '2️⃣ اللي "برا السالفة" ما يعرف الشخصية، وعليه يندمج بالأسئلة.'),
                SizedBox(height: 10),
                Text('3️⃣ تبادلوا الأسئلة بالترتيب.'),
                SizedBox(height: 10),
                Text('4️⃣ صوّتوا: مين برا السالفة؟'),
                SizedBox(height: 10),
                Text('5️⃣ التحدي الأخير: خمّنوا الشخصية التاريخية!'),
              ],
            ),
          ),
          actions: [
            if (videoUrl.isNotEmpty)
              TextButton.icon(
                onPressed: () => _openVideo(),
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('شاهد الفيديو'),
              ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('تمام'),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _openVideo() async {
    if (videoUrl.isEmpty) return;
    final uri = Uri.parse(videoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}