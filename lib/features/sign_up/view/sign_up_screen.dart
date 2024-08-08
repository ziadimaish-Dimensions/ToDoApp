import 'package:flutter/material.dart';
import 'package:to_do_app/features/sign_in/view/sign_in_screen.dart';
import 'package:to_do_app/global/authentication/authentication_repository.dart';
import 'package:to_do_app/global/authentication/widgets/authentication_widget.dart';
import 'package:to_do_app/global/services/user_service.dart';
import 'package:to_do_app/global/widgets/bottom_nav_bar_widget.dart';
import 'package:to_do_app/global/widgets/dismiss_keyboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  final AuthenticationRepository _authRepository = AuthenticationRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> onSignUpPressed() async {
    setState(() {
      _isLoading = true;
    });

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorMessage("Please fill in all fields.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (password.length < 6) {
      _showErrorMessage('Password should be more than 6 characters');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      _showErrorMessage("Passwords do not match.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final user =
        await _authRepository.signUpWithEmailPassword(email, password, name);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        UserService().setUserData(user.uid, user.email!, name);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavBarWidget(),
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DismissKeyboard(
          child: AuthenticationWidget(
            title: 'Register',
            firstTextField: 'Name',
            secondTextField: 'Email',
            thirdTextField: 'Password',
            fourthTextField: 'Confirm Password',
            actionText: 'Register',
            bottomText: "Already have an account? Login",
            isSignUp: true,
            firstController: nameController,
            secondController: emailController,
            thirdController: passwordController,
            fourthController: confirmPasswordController,
            onPressed: _isLoading ? () {} : onSignUpPressed,
            onGooglePressed: onGoogleLoginPressed,
            onApplePressed: onAppleLoginPressed,
            onBottomTextPressed: onBottomTextPressed,
            firstHintText: 'Enter your Name',
            secondHintText: 'Enter your Email',
            thirdHintText: 'Enter your Password',
            fourthHintText: 'Confirm your Password',
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
}
