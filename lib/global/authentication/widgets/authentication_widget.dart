import 'package:flutter/material.dart';
import 'package:to_do_app/global/widgets/custom_text_field.dart';

class AuthenticationWidget extends StatelessWidget {
  final String title;
  final String firstTextField;
  final String secondTextField;
  final String? thirdTextField;
  final String? fourthTextField;
  final String firstHintText;
  final String secondHintText;
  final String? thirdHintText;
  final String? fourthHintText;
  final String actionText;
  final String bottomText;
  final bool isSignUp;
  final TextEditingController firstController;
  final TextEditingController secondController;
  final TextEditingController? thirdController;
  final TextEditingController? fourthController;
  final VoidCallback onPressed;
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;
  final VoidCallback onBottomTextPressed;

  const AuthenticationWidget({
    super.key,
    required this.title,
    required this.firstTextField,
    required this.secondTextField,
    this.thirdTextField,
    this.fourthTextField,
    required this.firstHintText,
    required this.secondHintText,
    this.thirdHintText,
    this.fourthHintText,
    required this.actionText,
    required this.bottomText,
    this.isSignUp = false,
    required this.firstController,
    required this.secondController,
    this.thirdController,
    this.fourthController,
    required this.onPressed,
    required this.onGooglePressed,
    required this.onApplePressed,
    required this.onBottomTextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: firstTextField,
              hintText: firstHintText,
              controller: firstController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: secondTextField,
              hintText: secondHintText,
              controller: secondController,
              obscureText:
                  isSignUp ? false : true, // Email is not obscured for sign-up
            ),
            if (isSignUp && thirdTextField != null) ...[
              const SizedBox(height: 20),
              CustomTextField(
                label: thirdTextField!,
                hintText: thirdHintText!,
                controller: thirdController!,
                obscureText: true,
              ),
            ],
            if (isSignUp && fourthTextField != null) ...[
              const SizedBox(height: 20),
              CustomTextField(
                label: fourthTextField!,
                hintText: fourthHintText!,
                controller: fourthController!,
                obscureText: true,
              ),
            ],
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8875FF),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                actionText,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.white)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'or',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(child: Divider(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onGooglePressed,
              icon: Image.asset('assets/images/googleLogo.png', width: 20),
              label: Text('$actionText with Google',
                  style: const TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: BorderSide(color: Colors.grey[700]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onApplePressed,
              icon: Image.asset('assets/images/appleLogo.png', width: 20),
              label: Text('$actionText with Apple',
                  style: const TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: BorderSide(color: Colors.grey[700]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: onBottomTextPressed,
                child: Text(
                  bottomText,
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
