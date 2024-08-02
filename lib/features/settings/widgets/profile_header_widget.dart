import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 20),
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(
              'https://example.com/profile.jpg'), // Replace with actual image URL
        ),
        SizedBox(height: 10),
        Text(
          'Martha Hays',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
