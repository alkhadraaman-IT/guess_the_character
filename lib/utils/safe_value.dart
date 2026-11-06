/// يُرجع "-" بدل null / نص فاضي / "null" حرفياً.
/// يُستخدم لعرض قيم اختيارية من Excel أو الإدخال اليدوي.
String safeString(dynamic value) {
  if (value == null) return '-';
  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return '-';
  return text;
}

/// للحقول الأساسية (اسم الشخصية / اسم اللاعب):
/// يُرجع null إذا القيمة فاضية، حتى يتم تخطي الصف بالكامل.
String? safeRequiredString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return null;
  return text;
}