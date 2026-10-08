import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // جعلنا الخلفية كريمي لضمان تناسقها مع الصورة المفرغة
      backgroundColor: const Color(0xFFE9E0C9),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView( // الحل الذي اقترحتِه لمنع الخطأ البرمجي
          child: ConstrainedBox(
            // لضمان أن العناصر تأخذ طول الشاشة على الأقل
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/logo.jpg', height: 250),
                  // 1. الشعار (الدرع الملكي)
                 /* Card(
                    child:
                    /*//elevation: 8,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Image.asset('assets/logo.jpg', height: 250),
                    ),*/
                  ),*/

                  const SizedBox(height: 20),
                  Text('القدوة', style: Theme.of(context).textTheme.displayLarge),

                  const Spacer(), // يدفع الأزرار والصورة للأسفل

                  // 2. الزر الموحد (مستطيل بحواف دائرية)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/setup'),
                      child: const Text('ابدأ المغامرة'),
                    ),
                  ),

                  // 3. صورة الفرسان (عرض الشاشة الكامل)
                  // قمت بإزالة أي Padding لكي تلتصق بحواف التطبيق تماماً
                  Image.asset(
                    'assets/knights.jpg',
                    width: screenWidth, // عرض عرض الشاشة
                    fit: BoxFit.cover, // لتغطية العرض بالكامل دون ترك فراغات بيضاء
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}