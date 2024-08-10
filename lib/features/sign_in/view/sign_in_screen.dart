import 'package:flutter/material.dart';
import 'package:to_do_app/features/sign_up/view/sign_up_screen.dart';
import 'package:to_do_app/global/authentication/authentication_repository.dart';
import 'package:to_do_app/global/authentication/widgets/authentication_widget.dart';
import 'package:to_do_app/global/services/user_service.dart';
import 'package:to_do_app/global/widgets/bottom_nav_bar_widget.dart';
import 'package:to_do_app/global/widgets/dismiss_keyboard.dart';

/// The `SignInScreen` allows users to sign in with their email and password.
/// It also provides options for Google and Apple sign-in and a link to the sign-up screen.
/// The screen handles user authentication, error messaging, and navigation to the main app interface upon successful sign-in.

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

  /// Handles the sign-in process with email and password.
  /// It checks if the inputs are valid, attempts to sign in via the `AuthenticationRepository`,
  /// and navigates to the main screen if successful.
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

    final user = await _authRepository.signInWithEmailPassword(
        email, password); // Attempt to sign in with provided credentials.

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        final userData = await _authRepository.getUserData(user.uid);
        if (userData != null) {
          UserService().setUserData(user.uid, user.email!, userData['name']);
        }

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

  /// Displays an error message in a `SnackBar`.
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Placeholder for Google Login button press action.
  void onGoogleLoginPressed() {
    print("Google Login Pressed");
  }

  /// Placeholder for Apple Login button press action.
  void onAppleLoginPressed() {
    print("Apple Login Pressed");
  }

  /// Navigates to the `SignUpScreen` when the user taps on the "Don't have an account? Register" text.
  void onBottomTextPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  /// Handles the action when the sign-in button is pressed.
  void _handleSignInPressed() {
    onSignInPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Wraps the main content with a `DismissKeyboard` widget to allow dismissing the keyboard when tapping outside.
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

        /// Displays a loading indicator when the sign-in process is ongoing.
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
