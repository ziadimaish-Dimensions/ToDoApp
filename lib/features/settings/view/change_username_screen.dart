import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/global/services/user_service.dart';
import 'package:to_do_app/global/widgets/custom_elevated_button.dart';
import 'package:to_do_app/global/widgets/custom_text_field.dart';

/// The `ChangeUsernameScreen` allows users to update their username.
/// It interacts with Firebase Authentication and Firestore to update the username
/// both locally and in the Firestore database.

class ChangeUsernameScreen extends StatefulWidget {
  const ChangeUsernameScreen({super.key});

  @override
  State<ChangeUsernameScreen> createState() => _ChangeUsernameScreenState();
}

class _ChangeUsernameScreenState extends State<ChangeUsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userService = UserService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // If needed, you can initialize the text controller with an existing username
    _usernameController.text = userService.userName.value ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  /// Handles the process of changing the username.
  /// The new username is updated in Firestore and the local user service.
  Future<void> _changeUsername() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String newUsername = _usernameController.text.trim();

        // Ensure the text field is not empty before updating
        if (newUsername.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username cannot be empty')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        await _firestore.collection('users').doc(user.uid).update({
          'name': newUsername,
        });

        userService.userName.value = newUsername;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username updated successfully')),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update username: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Change Username',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              label: 'Username',
              hintText: 'Change your username',
              controller: _usernameController,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : CustomElevatedButton(
                    text: 'Update Username',
                    onPressed: _changeUsername,
                  ),
          ],
        ),
      ),
    );
  }
}
