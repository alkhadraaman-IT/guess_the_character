import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/safe_value.dart';
import 'game_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  static const Color historyGreen = Color(0xFF2D5A27);
  static const Color ancientBrown = Color(0xFF5D4037);
  static const Color creamBackground = Color(0xFFE9E0C9);
  static const Color cardLight = Color(0xFFFFF4D2);
  static const String defaultInfo = 'قدوة تاريخية';

  Map<String, dynamic> categories = {};
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _importExcel(String catName, Function refreshState) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true,
      );

      if (result == null) return;

      Uint8List? bytes = result.files.single.bytes;
      if (bytes == null && result.files.single.path != null) {
        bytes = File(result.files.single.path!).readAsBytesSync();
      }
      if (bytes == null) return;

      final Excel excel = Excel.decodeBytes(bytes);
      for (final table in excel.tables.keys) {
        final sheet = excel.tables[table]!;
        for (final row in sheet.rows.skip(1)) {
          if (row.isEmpty) continue;

          final String? name = safeRequiredString(row[0]?.value);
          if (name == null) continue;

          final dynamic rawInfo = row.length > 1 ? row[1]?.value : null;
          final String infoText = safeString(rawInfo);
          final String info = infoText == '-' ? defaultInfo : infoText;

          setState(() {
            categories[catName][name] = {'info': info, 'selected': true};
          });
        }
      }

      await _saveCategories();
      refreshState();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم استيراد البيانات بنجاح! ✨')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء القراءة.')),
      );
    }
  }

  Future<void> _exportExcel(String catName) async {
    try {
      final Map? data = categories[catName];
      if (data == null || data.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الحقبة فارغة، لا يوجد بيانات لتصديرها.')),
        );
        return;
      }

      final Excel excel = Excel.createExcel();
      final Sheet sheet = excel['Sheet1'];

      sheet.appendRow([
        TextCellValue('اسم الشخصية'),
        TextCellValue('النبذة'),
      ]);

      data.forEach((name, value) {
        sheet.appendRow([
          TextCellValue(safeString(name)),
          TextCellValue(safeString(value['info'])),
        ]);
      });

      final List<int>? fileBytes = excel.save();
      if (fileBytes == null) return;

      final Uint8List uint8ListBytes = Uint8List.fromList(fileBytes);

      if (kIsWeb) {
        final XFile xFile = XFile.fromData(
          uint8ListBytes,
          name: 'AlQudwa_$catName.xlsx',
          mimeType:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        );
        await xFile.saveTo('');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم بدء تنزيل الملف: $catName ✨')),
        );
      } else if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        final Directory directory = await getApplicationDocumentsDirectory();
        final String filePath = '${directory.path}/AlQudwa_$catName.xlsx';
        final File file = File(filePath);
        await file.writeAsBytes(uint8ListBytes);

        await Share.shareXFiles(
          [XFile(filePath)],
          text: 'إليك ملف شخصيات حقبة: $catName من تطبيق القدوة ✨',
        );
      } else {
        final String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'حفظ حقبة: $catName',
          fileName: 'AlQudwa_$catName.xlsx',
          type: FileType.custom,
          allowedExtensions: ['xlsx'],
        );
        if (outputFile != null) {
          final File file = File(outputFile);
          await file.writeAsBytes(uint8ListBytes);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم حفظ الملف بنجاح: $catName ✨')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء التصدير: $e')),
      );
    }
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_categories', json.encode(categories));
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('app_categories');
    if (data != null) {
      setState(() => categories = json.decode(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final List<String> players = args is List<String> ? args : [];
    final double width = MediaQuery.of(context).size.width;
    final int columnCount = width > 900 ? 4 : (width > 600 ? 3 : 2);

    return Scaffold(
      backgroundColor: creamBackground,
      appBar: AppBar(
        title: const Text(
          'حقب السالفة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: historyGreen,
        actions: [_buildSelectAllButton()],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(15),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.85,
                ),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return _buildAddCard();
                  final String name = categories.keys.elementAt(index - 1);
                  final bool isSelected = selectedCategories.contains(name);
                  return _buildCategoryCard(name, isSelected);
                },
              ),
            ),
            _buildStartButton(players),
          ],
        ),
      ),
    );
  }

  void _manageHeroesDialog(String catName) {
    final TextEditingController heroCtrl = TextEditingController();
    final TextEditingController infoCtrl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'إدارة: $catName',
              style: const TextStyle(
                fontSize: 16,
                color: historyGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildExcelButton(catName, setModalState),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: _buildExportButton(catName)),
                      ],
                    ),
                    const Divider(height: 30),
                    ...categories[catName].entries.map((entry) {
                      final String heroName = entry.key;
                      final bool isHeroSelected =
                          entry.value['selected'] ?? true;
                      return CheckboxListTile(
                        activeColor: historyGreen,
                        title: Text(
                          heroName,
                          style: TextStyle(
                            fontWeight: isHeroSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          safeString(entry.value['info']),
                          style: const TextStyle(fontSize: 11),
                        ),
                        value: isHeroSelected,
                        onChanged: (val) {
                          setState(
                            () =>
                                categories[catName][heroName]['selected'] = val,
                          );
                          _saveCategories();
                          setModalState(() {});
                        },
                        secondary: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(
                              () => categories[catName].remove(heroName),
                            );
                            _saveCategories();
                            setModalState(() {});
                          },
                        ),
                      );
                    }),
                    const Divider(),
                    TextField(
                      controller: heroCtrl,
                      decoration: const InputDecoration(
                        labelText: 'اسم الشخصية الجديدة',
                      ),
                    ),
                    TextField(
                      controller: infoCtrl,
                      decoration: const InputDecoration(labelText: 'النبذة'),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: historyGreen,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      onPressed: () {
                        final heroName = heroCtrl.text.trim();
                        if (heroName.isEmpty) return;
                        final infoText = safeString(infoCtrl.text);
                        setState(
                          () => categories[catName][heroName] = {
                            'info': infoText == '-' ? defaultInfo : infoText,
                            'selected': true,
                          },
                        );
                        _saveCategories();
                        heroCtrl.clear();
                        infoCtrl.clear();
                        setModalState(() {});
                      },
                      child: const Text(
                        'إضافة يدوية',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'تم',
                  style: TextStyle(
                    color: ancientBrown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExcelButton(String catName, Function setModalState) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D6F42), Color(0xFF2D5A27)],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          minimumSize: const Size(double.infinity, 45),
        ),
        onPressed: () => _importExcel(catName, () => setModalState(() {})),
        icon: const Icon(Icons.upload_file, color: Colors.white, size: 18),
        label: const Text(
          'استيراد',
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildExportButton(String catName) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: historyGreen, width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          minimumSize: const Size(double.infinity, 45),
        ),
        onPressed: () => _exportExcel(catName),
        icon: const Icon(Icons.download, color: historyGreen, size: 18),
        label: const Text(
          'تصدير',
          style: TextStyle(
            color: historyGreen,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String name, bool isSelected) {
    final int activeCount = (categories[name] as Map)
        .values
        .where((v) => v['selected'] == true)
        .length;

    return GestureDetector(
      onTap: () => setState(() {
        if (isSelected) {
          selectedCategories.remove(name);
        } else {
          selectedCategories.add(name);
        }
      }),
      child: Card(
        elevation: isSelected ? 10 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? historyGreen
                : ancientBrown.withValues(alpha: 0.5),
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [cardLight, Color(0xFFE2D1A4)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 5,
                left: 5,
                child: IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: historyGreen,
                    size: 22,
                  ),
                  onPressed: () => _doubleConfirmDelete(name),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_edu,
                      size: 40,
                      color: isSelected ? historyGreen : ancientBrown,
                    ),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: ancientBrown,
                      ),
                    ),
                    Text(
                      '$activeCount من ${categories[name].length} مختارة',
                      style: const TextStyle(
                        fontSize: 11,
                        color: historyGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings_suggest,
                        color: ancientBrown,
                      ),
                      onPressed: () => _manageHeroesDialog(name),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(List<String> players) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: historyGreen,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: selectedCategories.isEmpty
            ? null
            : () {
                final Map<String, String> finalHeroes = {};
                for (final cat in selectedCategories) {
                  categories[cat].forEach((key, value) {
                    if (value['selected'] == true) {
                      finalHeroes[key] = safeString(value['info']);
                    }
                  });
                }

                if (finalHeroes.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'يرجى اختيار شخصية واحدة على الأقل من الحقب المختارة!',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) =>
                        GameScreen(players: players, heroes: finalHeroes),
                  ),
                );
              },
        child: const Text(
          'ابدأ اللعب بالشخصيات المختارة',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectAllButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: historyGreen),
        ),
        onPressed: () => setState(() {
          if (selectedCategories.length == categories.length) {
            selectedCategories.clear();
          } else {
            selectedCategories = categories.keys.toList();
          }
        }),
        child: Text(
          selectedCategories.length == categories.length
              ? 'إلغاء الكل'
              : 'تحديد الكل',
          style: const TextStyle(color: historyGreen, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildAddCard() {
    return GestureDetector(
      onTap: _addNewCategoryDialog,
      child: Card(
        color: creamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: historyGreen, width: 2),
        ),
        child: const Center(
          child: Text(
            'إضافة حقبة',
            style: TextStyle(color: historyGreen, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _addNewCategoryDialog() {
    String name = '';
    showDialog<void>(
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
                setState(() => categories[trimmed] = {});
                _saveCategories();
                Navigator.pop(ctx);
              },
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  void _doubleConfirmDelete(String name) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          content: Text("حذف '$name'؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  categories.remove(name);
                  selectedCategories.remove(name);
                });
                _saveCategories();
                Navigator.pop(ctx);
              },
              child: const Text('حذف'),
            ),
          ],
        ),
      ),
    );
  }
}