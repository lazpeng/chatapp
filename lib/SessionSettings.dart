import 'package:shared_preferences/shared_preferences.dart';

class SessionSettings {
  static const String _KEY_TOKEN = "TOKEN";

  String sessionToken = "";

  static Future<SessionSettings> load() async {
    var pref = await SharedPreferences.getInstance();

    var settings = SessionSettings();

    if(pref.containsKey(_KEY_TOKEN)) {
      settings.sessionToken = pref.get(_KEY_TOKEN);
    }

    return settings;
  }

  static void logout() async {
    var pref = await SharedPreferences.getInstance();

    pref.remove(_KEY_TOKEN);
  }
}