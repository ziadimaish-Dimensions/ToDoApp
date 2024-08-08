import 'package:flutter/material.dart';
import 'package:to_do_app/features/sign_in/view/sign_in_screen.dart';
import 'package:to_do_app/global/authentication/authentication_repository.dart';
import 'package:to_do_app/global/services/user_service.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _handleLogout(BuildContext context) async {
    final AuthenticationRepository authRepository = AuthenticationRepository();
    await authRepository.signOut();

    UserService().clearUserData();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Log out', style: TextStyle(color: Colors.red)),
      onTap: () {
        _handleLogout(context);
      },
    );
  }
}
