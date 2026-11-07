import 'package:flutter/material.dart';

class CategoryDialogs {
  static void showAdd(BuildContext context, void Function(String) onAdd) {
    String name = '';
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('حقبة جديدة'),
          content: TextField(onChanged: (v) => name = v),
          actions: [
            ElevatedButton(
              onPressed: () {
                final trimmed = name.trim();
                if (trimmed.isEmpty) return;
                onAdd(trimmed);
                Navigator.pop(ctx);
              },
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  static void showDelete(BuildContext context, String name, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          content: Text("حذف '$name'؟"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () { onConfirm(); Navigator.pop(ctx); },
              child: const Text('حذف'),
            ),
          ],
        ),
      ),
    );
  }
}