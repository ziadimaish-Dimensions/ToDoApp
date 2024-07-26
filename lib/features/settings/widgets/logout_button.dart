import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Log out', style: TextStyle(color: Colors.red)),
      onTap: () {
        // Handle logout
      },
    );
  }
}
