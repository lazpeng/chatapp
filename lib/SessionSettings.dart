import 'package:shared_preferences/shared_preferences.dart';

class SessionSettings {
  static const String _KEY_TOKEN = "TOKEN";
  static const String _KEY_ID = "ID";

  String sessionToken = "";
  String userId = "";

  static Future<SessionSettings> load() async {
    var pref = await SharedPreferences.getInstance();

    var settings = SessionSettings();

    if(pref.containsKey(_KEY_TOKEN)) {
      settings.sessionToken = pref.get(_KEY_TOKEN);
      settings.userId = pref.get(_KEY_ID);
    }

    return settings;
  }

  static Future login(String id, String token) async {
    var pref = await SharedPreferences.getInstance();

    pref.setString(_KEY_TOKEN, token);
    pref.setString(_KEY_ID, id);
  }

  static Future logout() async {
    var pref = await SharedPreferences.getInstance();

    pref.remove(_KEY_TOKEN);
  }
}