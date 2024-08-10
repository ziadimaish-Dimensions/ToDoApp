import 'package:flutter/material.dart';

/// A widget representing a single onboarding page.
/// It displays an image, a title, a subtitle, and a button text that can be customized.
class OnBoardingWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imagePath;
  final String buttonText;

  const OnBoardingWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    this.buttonText = 'NEXT',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 215,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subTitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
