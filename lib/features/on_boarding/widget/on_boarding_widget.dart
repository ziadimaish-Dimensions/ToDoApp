import 'package:flutter/material.dart';

class OnBoardingWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imagePath;
  final String buttonText; // New parameter for button text

  const OnBoardingWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    this.buttonText = 'NEXT', // Default value for button text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath,width: 215,),
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
