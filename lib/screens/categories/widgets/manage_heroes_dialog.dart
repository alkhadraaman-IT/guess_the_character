import 'package:flutter/material.dart';

import '../../../app_theme.dart';
import '../../../utils/safe_value.dart';
import '../services/excel_service.dart';

class ManageHeroesDialog extends StatefulWidget {
  final String catName;
  final Map<dynamic, dynamic> heroes;
  final VoidCallback onChanged;

  const ManageHeroesDialog({
    super.key,
    required this.catName,
    required this.heroes,
    required this.onChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required String catName,
    required Map<dynamic, dynamic> heroes,
    required VoidCallback onChanged,
  }) =>
      showDialog(
        context: context,
        builder: (_) => ManageHeroesDialog(
          catName: catName,
          heroes: heroes,
          onChanged: onChanged,
        ),
      );

  @override
  State<ManageHeroesDialog> createState() => _ManageHeroesDialogState();
}

class _ManageHeroesDialogState extends State<ManageHeroesDialog> {
  final _heroCtrl = TextEditingController();
  final _infoCtrl = TextEditingController();
  bool _isImporting = false;
  bool _isExporting = false;

  @override
  void dispose() {
    _heroCtrl.dispose();
    _infoCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    setState(() {});
    widget.onChanged();
  }

  Future<void> _handleImport() async {
    setState(() => _isImporting = true);
    try {
      final added = await ExcelService.import(heroes: widget.heroes);
      if (!mounted) return;
      if (added > 0) {
        _notify();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم استيراد $added شخصية بنجاح! ✨')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء القراءة.')),
      );
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);
    try {
      final ok = await ExcelService.export(
        catName: widget.catName,
        heroes: widget.heroes,
      );
      if (!mounted || !ok) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تصدير حقبة: ${widget.catName} ✨')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'إدارة: ${widget.catName}',
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.historyGreen,
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
                      child: _ExcelButton(
                        label: _isImporting ? 'جاري...' : 'استيراد',
                        icon: Icons.upload_file,
                        isLoading: _isImporting,
                        gradient: true,
                        onPressed: _isImporting ? null : _handleImport,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ExcelButton(
                        label: _isExporting ? 'جاري...' : 'تصدير',
                        icon: Icons.download,
                        isLoading: _isExporting,
                        gradient: false,
                        onPressed: _isExporting ? null : _handleExport,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30),
                ...widget.heroes.entries.map((entry) {
                  final heroName = entry.key;
                  final isSelected = entry.value['selected'] ?? true;
                  return CheckboxListTile(
                    activeColor: AppTheme.historyGreen,
                    title: Text(
                      heroName,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      safeString(entry.value['info']),
                      style: const TextStyle(fontSize: 11),
                    ),
                    value: isSelected,
                    onChanged: (v) {
                      widget.heroes[heroName]['selected'] = v;
                      _notify();
                    },
                    secondary: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () {
                        widget.heroes.remove(heroName);
                        _notify();
                      },
                    ),
                  );
                }),
                const Divider(),
                TextField(
                  controller: _heroCtrl,
                  decoration: const InputDecoration(
                    labelText: 'اسم الشخصية الجديدة',
                  ),
                ),
                TextField(
                  controller: _infoCtrl,
                  decoration: const InputDecoration(labelText: 'النبذة'),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.historyGreen,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  onPressed: () {
                    final heroName = _heroCtrl.text.trim();
                    if (heroName.isEmpty) return;
                    final info = safeString(_infoCtrl.text);
                    widget.heroes[heroName] = <String, dynamic>{
                      'info': info == '-' ? 'قدوة تاريخية' : info,
                      'selected': true,
                    };
                    _heroCtrl.clear();
                    _infoCtrl.clear();
                    _notify();
                  },
                  child: const Text(
                    'إضافة يدوية',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.creamText),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'تم',
              style: TextStyle(
                color: AppTheme.ancientBrown,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExcelButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isLoading;
  final bool gradient;
  final VoidCallback? onPressed;

  const _ExcelButton({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient
            ? const LinearGradient(
                colors: [Color(0xFF1D6F42), AppTheme.historyGreen],
              )
            : null,
        border: gradient ? null : Border.all(color: AppTheme.historyGreen, width: 1.5),
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
        onPressed: onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(
                icon,
                color: gradient ? AppTheme.creamText : AppTheme.historyGreen,
                size: 18,
              ),
        label: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: gradient ? AppTheme.creamText : AppTheme.historyGreen,
            fontSize: 13,
            fontWeight: gradient ? FontWeight.normal : FontWeight.bold,
          ),
        ),
      ),
    );
  }
}