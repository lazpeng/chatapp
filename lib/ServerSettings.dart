import 'package:shared_preferences/shared_preferences.dart';

class ServerSettings {
  static const String _KEY_HOST = "HOST";
  static const String _KEY_PORT = "PORT";

  String host = "192.168.0.31";
  int port = 5000;

  ServerSettings._internal();

  static Future<ServerSettings> load() async {
    var prefs = await SharedPreferences.getInstance();

    var settings = ServerSettings._internal();

    if(prefs.containsKey(_KEY_HOST)) {
      settings.host = prefs.getString(_KEY_HOST);
      settings.port = prefs.getInt(_KEY_PORT);
    }

    return settings;
  }
}