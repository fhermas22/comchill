import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();

  @override
  void dispose(){
    controller.dispose();

    super.dispose();
  }
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 100),
        child: PageView(
          controller = controller,
          children: [
            Container(
              color: Colors.red,
              child: const Center(
                child: Text(
                  'Page 1',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            Container(
              color: Colors.green,
              child: const Center(
                child: Text(
                  'Page 2',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            Container(
              color: Colors.blue,
              child: const Center(
                child: Text(
                  'Page 3',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInset.symmetric(horizontal: 30),
      )
    );
  }
}