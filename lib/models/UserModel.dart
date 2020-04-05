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
  String dataHash;

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
      "dataHash": dataHash
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
    if(responseMap['accountCreated'] != null) {
      user.accountCreated = DateTime.tryParse(responseMap['accountCreated']);
    }
    if(responseMap['lastLogin'] != null) {
    user.lastLogin = DateTime.tryParse(responseMap['lastLogin']);
    }
    if(responseMap['lastSeen'] != null) {
    user.lastSeen = DateTime.tryParse(responseMap['lastSeen']);
    }
    user.bio = responseMap['bio'];
    user.dataHash = responseMap['dataHash'];

    return user;
  }

  static UserModel fromDbCursor(Map<String, dynamic> responseMap) {
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
    user.bio = responseMap['Bio'];
    user.dataHash = responseMap['DataHash'];

    return user;
  }
}