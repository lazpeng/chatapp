class UserModel {
  String id;
  String username;
  String fullName;
  String email;
  String password;
  String profilePicUrl;
  DateTime dateOfBirth;
  String bio;
  bool findInSearch;
  bool openChat;

  Map<String, dynamic> toJsonMap() {
    return {
      "username": username,
      "fullName": fullName,
      "email": email,
      "password": password,
      "dateOfBirth": dateOfBirth.toIso8601String(),
      "bio": bio,
      "findInSearch": findInSearch,
      "openChat": openChat,
    };
  }
}