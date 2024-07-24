import 'package:flutter/material.dart';
import 'package:to_do_app/features/home/home_screen.dart';
import 'package:to_do_app/global/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
       home: SplashScreen(),
    );
  }
}
