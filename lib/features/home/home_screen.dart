import 'package:flutter/material.dart';

import '../../global/user_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserService();

    return Scaffold(
      body: Column(
        children: [
          if (user.userName != null) Text('Welcome, ${user.userName}'),
          Image.asset('assets/images/homeScreenLogo.png'),
        ],
      ),
    );
  }
}
