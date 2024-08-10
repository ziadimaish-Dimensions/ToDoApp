import 'package:flutter/material.dart';
import 'package:to_do_app/global/services/user_service.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserService();

    return Column(
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage('https://example.com/profile.jpg'),
        ),
        const SizedBox(height: 10),
        ValueListenableBuilder<String?>(
          valueListenable:
              userService.userName, // Listen to changes in the user's name.
          builder: (context, userName, child) {
            return Text(
              userName ?? 'Guest',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ],
    );
  }
}
