class UserModel {
  String id;
  String username;
  String fullName;
  String email;
  String password;
  DateTime dateOfBirth;
  DateTime accountCreated;
  DateTime lastLogin;
  DateTime lastSeen;
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

  static UserModel fromJsonMap(Map<String, dynamic> responseMap) {
    var user = new UserModel();

    user.id = responseMap['id'];
    user.username = responseMap['username'];
    user.fullName = responseMap['fullName'];
    user.email = responseMap['email'];
    user.findInSearch = responseMap['findInSearch'] == 1;
    user.openChat = responseMap['openChat'] == 1;
    user.dateOfBirth = DateTime.tryParse(responseMap['dateOfBirth']);
    user.accountCreated = DateTime.tryParse(responseMap['accountCreated']);
    user.lastLogin = DateTime.tryParse(responseMap['lastLogin']);
    user.lastSeen = DateTime.tryParse(responseMap['lastSeen']);
    user.bio = responseMap['bio'];

    return user;
  }

  static UserModel fromDatabaseMap(Map<String, dynamic> responseMap) {
    var user = new UserModel();

    user.id = responseMap['Id'];
    user.username = responseMap['Username'];
    user.fullName = responseMap['FullName'];
    user.email = responseMap['Email'];
    user.findInSearch = responseMap['FindInSearch'] == 1;
    user.openChat = responseMap['OpenChat'] == 1;
    user.dateOfBirth = DateTime.tryParse(responseMap['DateOfBirth']);
    user.accountCreated = DateTime.tryParse(responseMap['AccountCreated']);
    user.lastLogin = DateTime.tryParse(responseMap['LastLogin']);
    user.lastSeen = DateTime.tryParse(responseMap['LastSeen']);
    user.bio = responseMap['bio'];

    return user;
  }
}