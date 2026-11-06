import 'package:flutter/material.dart';
import '../utils/tutorial_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _historyGreen = Color(0xFF2D5A27);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) TutorialHelper.maybeShow(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE9E0C9),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/logo.jpg', height: 250),
                  const SizedBox(height: 20),
                  Text(
                    'القدوة',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 20,
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/setup'),
                      child: const Text('ابدأ المغامرة'),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => TutorialHelper.openManually(context),
                    icon: const Icon(Icons.help_outline, color: _historyGreen),
                    label: const Text(
                      'كيف ألعب؟',
                      style: TextStyle(
                        color: _historyGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/knights.jpg',
                    width: screenWidth,
                    fit: BoxFit.cover,
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