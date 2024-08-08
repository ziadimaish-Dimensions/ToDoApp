import 'package:flutter/foundation.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  String? userId;
  String? userEmail;
  ValueNotifier<String?> userName = ValueNotifier<String?>(null);

  void setUserData(String id, String email, String name) {
    userId = id;
    userEmail = email;
    userName.value = name;
  }

  void clearUserData() {
    userId = null;
    userEmail = null;
    userName.value = null;
  }
}
