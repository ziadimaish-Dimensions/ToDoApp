import 'package:flutter/foundation.dart';

/// The `UserService` manages user-related data in the app, including the user ID, email, and name.
/// It follows the singleton pattern to ensure only one instance of the service is used throughout the app.

class UserService {
  static final UserService _instance = UserService._internal();

  /// Factory constructor to return the same instance of `UserService`.
  factory UserService() {
    return _instance;
  }

  /// Internal constructor used for singleton instantiation.
  UserService._internal();

  String? userId;
  String? userEmail;
  ValueNotifier<String?> userName = ValueNotifier<String?>(null);

  /// Sets the user's data, including the ID, email, and name.
  ///
  /// Parameters:
  /// - `id`: The user's unique identifier.
  /// - `email`: The user's email address.
  /// - `name`: The user's display name.
  void setUserData(String id, String email, String name) {
    userId = id;
    userEmail = email;
    userName.value = name;
  }

  /// Clears the user's data, typically used when the user logs out.
  void clearUserData() {
    userId = null;
    userEmail = null;
    userName.value = null;
  }
}
