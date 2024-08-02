import 'package:flutter/material.dart';
import 'package:to_do_app/features/on_boarding/view/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _loaded();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loaded() {
    _controller.forward().then((value) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const OnBoardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/appLogo.png",
              width: MediaQuery.of(context).size.width * 0.5,
              opacity: _controller.drive(
                Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ),
              ),
            ),
          ),
          Opacity(
            opacity: _controller.isCompleted ? 1.0 : 0.0,
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
