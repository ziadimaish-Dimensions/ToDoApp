class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  String? userId;
  String? userEmail;
  String? userName;

  void setUserData(String id, String email, String name) {
    userId = id;
    userEmail = email;
    userName = name;
  }

  void clearUserData() {
    userId = null;
    userEmail = null;
    userName = null;
  }
}
