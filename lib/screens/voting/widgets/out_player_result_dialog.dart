import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class OutPlayerResultDialog {
  OutPlayerResultDialog._();

  static Future<void> show(
    BuildContext context, {
    required bool correct,
    required String selectedName,
    required String actualOutName,
  }) =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: AppTheme.cardLight,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Icon(correct ? Icons.celebration : Icons.person_off_rounded,
                size: 70,
                color: correct ? AppTheme.historyGreen : AppTheme.softRed),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(correct ? 'كفووو! كشفتوه' : 'أوووه! ظلمتوه',
                    style: TextStyle(
                        color:
                            correct ? AppTheme.historyGreen : AppTheme.softRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 24)),
                const SizedBox(height: 15),
                Text(
                  correct
                      ? 'فعلاً $selectedName هو اللي كان برا السالفة!'
                      : 'للأسف $selectedName داخل السالفة.. اللي كان برا هو $actualOutName!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, color: AppTheme.ancientBrown),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.historyGreen,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('تحدي كشف الشخصية',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.creamText, fontSize: 18)),
              ),
            ],
          ),
        ),
      );
}