import 'package:flutter/material.dart';
import 'package:to_do_app/features/home/home_screen.dart';
import 'package:to_do_app/features/sign_in/view/sign_in_screen.dart';
import 'package:to_do_app/global/authentication/authentication_repository.dart';
import 'package:to_do_app/global/authentication/widgets/authentication_widget.dart';
import 'package:to_do_app/global/widgets/dismiss_keyboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController confirmPasswordController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final AuthenticationRepository _authRepository = AuthenticationRepository();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> onSignUpPressed() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorMessage("Please fill in all fields.");
      return;
    }

    if (password != confirmPassword) {
      _showErrorMessage("Passwords do not match.");
      return;
    }

    final user = await _authRepository.signUpWithEmailPassword(email, password);

    if (mounted) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        _showErrorMessage("Sign-up failed. Please try again.");
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: AuthenticationWidget(
        title: 'Register',
        firstTextField: 'Email',
        secondTextField: 'Password',
        thirdTextField: 'Confirm Password',
        actionText: 'Register',
        bottomText: "Already have an account? Login",
        isSignUp: true,
        firstController: emailController,
        secondController: passwordController,
        thirdController: confirmPasswordController,
        onPressed: onSignUpPressed,
        onGooglePressed: onGoogleLoginPressed,
        onApplePressed: onAppleLoginPressed,
        onBottomTextPressed: onBottomTextPressed,
        firstHintText: 'Enter your Email',
        secondHintText: 'Enter your Password',
        thirdHintText: 'Confirm your Password',
      ),
    );
  }
}
