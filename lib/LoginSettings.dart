import 'package:shared_preferences/shared_preferences.dart';

class LoginSettings {
  static const String KEY_USERNAME = "USERNAME";
  static const String KEY_PASSWORD = "PASSWORD";
  static const String KEY_REMEMBER = "REMEMBER_PASSWORD";

  String savedUsername = "";
  String savedPassword = "";
  bool rememberPassword = false;

  static Future<LoginSettings> load() async {
    var pref = await SharedPreferences.getInstance();

    var set = new LoginSettings();

    if(pref.containsKey(KEY_USERNAME)) {
      set.savedUsername = pref.get(KEY_USERNAME);
      set.rememberPassword = pref.getBool(KEY_REMEMBER);
      if(set.rememberPassword) {
        set.savedPassword = pref.get(KEY_PASSWORD);
      }
    }

    return set;
  }
}