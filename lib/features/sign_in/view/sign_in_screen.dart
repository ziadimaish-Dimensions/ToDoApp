import 'package:flutter/material.dart';
import '../../../global/authentication/widgets/authentication_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onSignInPressed() {
    // Handle sign-in logic
    print("Sign In Pressed");
  }

  void onGoogleLoginPressed() {
    // Handle Google login logic
    print("Google Login Pressed");
  }

  void onAppleLoginPressed() {
    // Handle Apple login logic
    print("Apple Login Pressed");
  }

  void onBottomTextPressed() {
    // Navigate to the sign-up screen or other actions
    Navigator.pushNamed(context, '/signup'); // Replace with actual route name
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationWidget(
      title: 'Login',
      firstTextField: 'Username',
      secondTextField: 'Password',
      actionText: 'Login',
      bottomText: "Don't have an account? Register",
      isSignUp: false,
      firstController: usernameController,
      secondController: passwordController,
      onPressed: onSignInPressed,
      onGooglePressed: onGoogleLoginPressed,
      onApplePressed: onAppleLoginPressed,
      onBottomTextPressed: onBottomTextPressed,
    );
  }
}
