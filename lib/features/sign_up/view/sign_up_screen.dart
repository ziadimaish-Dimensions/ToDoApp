import 'package:flutter/material.dart';
import 'package:to_do_app/features/sign_in/view/sign_in_screen.dart';
import 'package:to_do_app/global/authentication/authentication_repository.dart';
import 'package:to_do_app/global/authentication/widgets/authentication_widget.dart';
import 'package:to_do_app/global/services/user_service.dart';
import 'package:to_do_app/global/widgets/bottom_nav_bar_widget.dart';
import 'package:to_do_app/global/widgets/dismiss_keyboard.dart';

/// The `SignUpScreen` allows users to register a new account by providing their name, email, password, and confirmation of the password.
/// It handles user registration, error messaging, and navigation to the main app interface upon successful sign-up.

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

  /// Handles the sign-up process with the provided name, email, password, and confirmation password.
  /// It checks if all fields are filled, validates the password length, and ensures that the passwords match.
  /// Upon successful registration, it navigates the user to the main application screen.
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

    final user = await _authRepository.signUpWithEmailPassword(
        email, password, name); // Attempt to sign up with provided credentials.

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

  /// Displays an error message in a `SnackBar`.
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
        /// Wraps the main content with a `DismissKeyboard` widget to allow dismissing the keyboard when tapping outside.
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

        /// Displays a loading indicator when the sign-up process is ongoing.
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

  /// Placeholder for Google Login button press action.
  void onGoogleLoginPressed() {
    print("Google Login Pressed");
  }

  /// Placeholder for Apple Login button press action.
  void onAppleLoginPressed() {
    print("Apple Login Pressed");
  }

  /// Navigates to the `SignInScreen` when the user taps on the "Already have an account? Login" text.
  void onBottomTextPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
    );
  }
}
