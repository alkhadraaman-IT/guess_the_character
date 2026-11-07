import 'dart:io';

import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../utils/safe_value.dart';

/// خدمة قراءة/كتابة ملفات Excel — لا تعتمد على BuildContext.
class ExcelService {
  static const String _defaultInfo = 'قدوة تاريخية';

  /// يستورد صفوف من Excel ويضيفها لـ [heroes].
  /// يرجع عدد الصفوف المضافة. يرمي Exception عند الخطأ.
  static Future<int> import({
    required Map<dynamic, dynamic> heroes,
  }) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: true,
    );
    if (result == null) return 0;

    Uint8List? bytes = result.files.single.bytes;
    if (bytes == null && result.files.single.path != null) {
      bytes = File(result.files.single.path!).readAsBytesSync();
    }
    if (bytes == null) return 0;

    final Excel excel = Excel.decodeBytes(bytes);
    int added = 0;

    for (final table in excel.tables.keys) {
      final sheet = excel.tables[table]!;
      for (final row in sheet.rows.skip(1)) {
        if (row.isEmpty) continue;

        final String? name = safeRequiredString(row[0]?.value);
        if (name == null) continue;

        final dynamic rawInfo = row.length > 1 ? row[1]?.value : null;
        final String infoText = safeString(rawInfo);
        final String info = infoText == '-' ? _defaultInfo : infoText;

        heroes[name] = <String, dynamic>{'info': info, 'selected': true};
        added++;
      }
    }
    return added;
  }

  /// يصدّر [heroes] لملف Excel.
  /// يرجع true إذا تم الحفظ فعلاً، false إذا أُلغى من المستخدم.
  /// يرمي Exception عند الخطأ.
  static Future<bool> export({
    required String catName,
    required Map<dynamic, dynamic> heroes,
  }) async {
    if (heroes.isEmpty) {
      throw Exception('الحقبة فارغة، لا يوجد بيانات لتصديرها.');
    }

    final Excel excel = Excel.createExcel();
    final Sheet sheet = excel['Sheet1'];
    sheet.appendRow([
      TextCellValue('اسم الشخصية'),
      TextCellValue('النبذة'),
    ]);

    heroes.forEach((name, value) {
      sheet.appendRow([
        TextCellValue(safeString(name)),
        TextCellValue(safeString(value['info'])),
      ]);
    });

    final List<int>? fileBytes = excel.save();
    if (fileBytes == null) return false;

    final Uint8List uint8ListBytes = Uint8List.fromList(fileBytes);

    if (kIsWeb) {
      final XFile xFile = XFile.fromData(
        uint8ListBytes,
        name: 'AlQudwa_$catName.xlsx',
        mimeType:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );
      await xFile.saveTo('');
      return true;
    }

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/AlQudwa_$catName.xlsx';
      final File file = File(filePath);
      await file.writeAsBytes(uint8ListBytes);
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'إليك ملف شخصيات حقبة: $catName من تطبيق القدوة ✨',
      );
      return true;
    }

    // Desktop: يفتح picker للحفظ. لو المستخدم ألغى، outputFile == null.
    final String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'حفظ حقبة: $catName',
      fileName: 'AlQudwa_$catName.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    if (outputFile == null) return false;
    await File(outputFile).writeAsBytes(uint8ListBytes);
    return true;
  }
}