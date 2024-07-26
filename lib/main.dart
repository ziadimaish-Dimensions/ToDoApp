import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/features/sign_up/view/sign_up_screen.dart';
import 'package:to_do_app/global/splash_screen.dart';
import 'package:to_do_app/global/widgets/bottom_nav_bar_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavBarWidget(),
    );
  }
}
