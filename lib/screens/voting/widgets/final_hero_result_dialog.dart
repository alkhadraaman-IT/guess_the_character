import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class FinalHeroResultDialog {
  FinalHeroResultDialog._();

  /// ترجع true إذا اختار "لعبة جديدة"، false إذا اختار "الرئيسية".
  static Future<bool> show(BuildContext context, {
    required bool correct, required String hero, required String info,
  }) async {
    final result = await showDialog<bool>(
      context: context, barrierDismissible: false,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppTheme.cardLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Icon(
            correct ? Icons.celebration_rounded : Icons.hourglass_empty_rounded,
            size: 80, color: correct ? AppTheme.historyGreen : AppTheme.ancientBrown,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(correct ? 'ذكاء أسطوري! حزرتها' : 'حظ أوفر.. خذلتك الذاكرة',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: correct ? AppTheme.historyGreen : AppTheme.softRed,
                      fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 15),
              const Text('الشخصية التاريخية كانت:',
                  style: TextStyle(color: AppTheme.ancientBrown, fontSize: 14)),
              Text(hero, style: const TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 28, color: AppTheme.historyGreen)),
              const SizedBox(height: 10),
              Text(info, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: AppTheme.ancientBrown,
                      fontStyle: FontStyle.italic)),
            ],
          ),
          actions: [
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.historyGreen,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('لعبة جديدة بنفس الأبطال',
                      style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('العودة للقائمة الرئيسية',
                      style: TextStyle(color: AppTheme.ancientBrown)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return result ?? false;
  }
}