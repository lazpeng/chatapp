
import 'package:shared_preferences/shared_preferences.dart';

class SessionInfo {
  String token;
  String sourceId;

  SessionInfo({this.token, this.sourceId});

  Map<String, dynamic> toJsonMap() {
    return {
      'token': token,
      'sourceId': sourceId
    };
  }
}

class LoginInfo {
  String username;
  String password;
  bool appearOffline;

  LoginInfo({this.username, this.password, this.appearOffline});

  Map<String, dynamic> toJsonMap() {
    return {
      'username': username,
      'password': password,
      'appearOffline': appearOffline
    };
  }
}

class SessionRepository {
  static const String _KEY_TOKEN = "CHATAPP_TOKEN";
  static const String _KEY_ID = "CHATAPP_ID";
  static const String _KEY_USERNAME = "CHATAPP_USERNAME";
  static const String _KEY_PASSWORD = "CHATAPP_PASSWORD";
  static const String _KEY_OFFLINE = "CHATAPP_OFFLINE";

  Future<LoginInfo> loadLoginInfo() async {
    var prefs = await SharedPreferences.getInstance();

    var info = LoginInfo();

    if(prefs.containsKey(_KEY_USERNAME)) {
      info.appearOffline = prefs.getInt(_KEY_OFFLINE) != 0;
      info.username = prefs.getString(_KEY_USERNAME);
      info.password = prefs.getString(_KEY_PASSWORD);
    }

    return info;
  }

  Future saveLoginInfo(LoginInfo login) async {
    var prefs = await SharedPreferences.getInstance();

    if(login == null) {
      login = LoginInfo();
    }

    prefs.setInt(_KEY_OFFLINE, login.appearOffline ? 1 : 0);
    prefs.setString(_KEY_USERNAME, login.username);
    prefs.setString(_KEY_PASSWORD, login.password);
  }

  Future<SessionInfo> loadSessionInfo() async {
    var prefs = await SharedPreferences.getInstance();

    var info = SessionInfo();

    if(prefs.containsKey(_KEY_TOKEN)) {
      info.token = prefs.getString(_KEY_TOKEN);
      info.sourceId = prefs.getString(_KEY_ID);
    }

    return info;
  }

  Future saveSessionInfo(SessionInfo info) async {
    var prefs = await SharedPreferences.getInstance();

    if(info == null) {
      info = SessionInfo();
    }

    prefs.setString(_KEY_TOKEN, info.token);
    prefs.setString(_KEY_ID, info.sourceId);
  }
}