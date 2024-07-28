import 'package:flutter/material.dart';
import 'package:to_do_app/features/sign_up/view/sign_up_screen.dart';
import 'package:to_do_app/global/authentication/authentication_repository.dart';
import 'package:to_do_app/global/widgets/bottom_nav_bar_widget.dart';
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
  bool _isLoading = false;

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
    setState(() {
      _isLoading = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorMessage("Please enter both email and password");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final user = await _authRepository.signInWithEmailPassword(email, password);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavBarWidget(),
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

  void _handleSignInPressed() {
    onSignInPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DismissKeyboard(
          child: AuthenticationWidget(
            title: 'Login',
            firstTextField: 'Email',
            secondTextField: 'Password',
            actionText: 'Login',
            bottomText: "Don't have an account? Register",
            isSignUp: false,
            firstController: emailController,
            secondController: passwordController,
            onPressed: _isLoading ? () {} : _handleSignInPressed,
            onGooglePressed: onGoogleLoginPressed,
            onApplePressed: onAppleLoginPressed,
            onBottomTextPressed: onBottomTextPressed,
            firstHintText: 'Enter your Email',
            secondHintText: 'Enter your Password',
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
