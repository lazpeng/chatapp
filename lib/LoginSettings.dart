import 'package:shared_preferences/shared_preferences.dart';

class LoginSettings {
  static const String _KEY_USERNAME = "USERNAME";
  static const String _KEY_PASSWORD = "PASSWORD";
  static const String _KEY_OFFLINE = "OFFLINE";

  String savedUsername;
  String savedPassword;
  bool appearOffline;

  LoginSettings._internal();

  static Future<LoginSettings> load() async {
    var pref = await SharedPreferences.getInstance();

    var set = LoginSettings._internal();

    if(pref.containsKey(_KEY_USERNAME)) {
      set.savedUsername = pref.getString(_KEY_USERNAME);
      set.savedPassword = pref.getString(_KEY_PASSWORD);
      set.appearOffline = pref.getBool(_KEY_OFFLINE);
    }

    return set;
  }

  static Future save(String username, String password, bool offline) async {
    var pref = await SharedPreferences.getInstance();

    pref.setString(_KEY_USERNAME, username);
    pref.setString(_KEY_PASSWORD, password);
    pref.setBool(_KEY_OFFLINE, offline);
  }
}