import 'package:shared_preferences/shared_preferences.dart';

class ServerConfiguration {
  String host = "";
  int port = 443;
  bool useHttps = true;
}

class ServerRepository {
  static const String _KEY_HOST = "CHATAPP_HOST";
  static const String _KEY_PORT = "CHATAPP_PORT";
  static const String _KEY_HTTPS = "CHATAPP_HTTPS";

  Future<ServerConfiguration> load() async {
    var prefs = await SharedPreferences.getInstance();

    var config = ServerConfiguration();

    if(prefs.containsKey(_KEY_HOST)) {
      config.host = prefs.getString(_KEY_HOST);
      config.port = prefs.getInt(_KEY_PORT);
      config.useHttps = prefs.getInt(_KEY_HTTPS) != 0;
    }

    return config;
  }

  Future save(ServerConfiguration configuration) async {
    var prefs = await SharedPreferences.getInstance();

    if(configuration == null) {
      configuration = ServerConfiguration();
    }

    prefs.setString(_KEY_HOST, configuration.host);
    prefs.setInt(_KEY_PORT, configuration.port);
    prefs.setInt(_KEY_HTTPS, configuration.useHttps ? 1 : 0);
  }
}