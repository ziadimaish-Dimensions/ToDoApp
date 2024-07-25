import 'package:flutter/material.dart';
import 'package:to_do_app/features/home/home_screen.dart';
import 'package:to_do_app/features/sign_up/view/sign_up_screen.dart';
import 'package:to_do_app/global/authentication/authentication_repository.dart';
import 'package:to_do_app/global/widgets/dismiss_keyboard.dart';
import '../../../global/authentication/widgets/authentication_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final AuthenticationRepository _authRepository = AuthenticationRepository();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> onSignInPressed() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorMessage("Please enter both email and password");
      return;
    }

    final user = await _authRepository.signInWithEmailPassword(email, password);

    if (mounted) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        _showErrorMessage(
            "Sign-in failed. Please check your credentials and try again.");
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void onGoogleLoginPressed() {
    print("Google Login Pressed");
  }

  void onAppleLoginPressed() {
    print("Apple Login Pressed");
  }

  void onBottomTextPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: AuthenticationWidget(
        title: 'Login',
        firstTextField: 'Email',
        secondTextField: 'Password',
        actionText: 'Login',
        bottomText: "Don't have an account? Register",
        isSignUp: false,
        firstController: emailController,
        secondController: passwordController,
        onPressed: onSignInPressed,
        onGooglePressed: onGoogleLoginPressed,
        onApplePressed: onAppleLoginPressed,
        onBottomTextPressed: onBottomTextPressed,
        firstHintText: 'Enter your Email',
        secondHintText: 'Enter your Password',
      ),
    );
  }
}
