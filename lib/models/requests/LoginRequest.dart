class LoginRequest {
  String username;
  String password;
  bool appearOffline;

  Map<String, dynamic> toJsonMap() {
    return {
      "username": username,
      "password": password,
      "appearOffline": appearOffline
    };
  }
}