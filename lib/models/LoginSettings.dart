import 'package:shared_preferences/shared_preferences.dart';

class LoginSettings {
  static const String KEY_USERNAME = "USERNAME";
  static const String KEY_PASSWORD = "PASSWORD";

  String savedUsername = "";
  String savedPassword = "";

  LoginSettings._internal();

  static Future<LoginSettings> load() async {
    var pref = await SharedPreferences.getInstance();

    var set = LoginSettings._internal();

    if(pref.containsKey(KEY_USERNAME)) {
      set.savedUsername = pref.get(KEY_USERNAME);
      set.savedPassword = pref.get(KEY_PASSWORD);
    }

    return set;
  }

  setLogin(String username, String password) {

  }
}