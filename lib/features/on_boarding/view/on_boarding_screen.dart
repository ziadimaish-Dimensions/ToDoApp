import 'package:flutter/material.dart';
import 'package:to_do_app/features/authentication/view/authentication_screen.dart';
import 'package:to_do_app/features/authentication/view/decision_screen.dart';
import 'package:to_do_app/features/on_boarding/widget/on_boarding_widget.dart';
import 'package:to_do_app/global/widgets/custom_elevated_button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}


class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const DecisionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: const [
              OnBoardingWidget(
                title: "Manage your tasks",
                subTitle: "You can easily manage all of your daily tasks in DoMe for free",
                imagePath: 'assets/images/onBoarding1.png',
              ),
              OnBoardingWidget(
                title: "Create daily routine",
                subTitle: "In Uptodo you can create your personalized routine to stay productive",
                imagePath: 'assets/images/onBoarding2.png',
              ),
              OnBoardingWidget(
                title: "Organize your tasks",
                subTitle: "You can organize your daily tasks by adding your tasks into separate categories",
                imagePath: 'assets/images/onBoarding3.png',
                buttonText: 'Get Started',
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.grey,
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomElevatedButton(
                    text: 'BACK',
                    onPressed: () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                  ),
                  CustomElevatedButton(
                    onPressed: _nextPage,
                    text: _currentPage == 2 ? 'Get Started' : 'NEXT',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
