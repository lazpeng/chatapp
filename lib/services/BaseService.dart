import 'package:chatapp/models/ServerSettings.dart';

abstract class BaseService {
  ServerSettings _settings;
  bool _useHttps = false;

  Future<String> apiUrl(String endpoint) async {
    if(_settings == null) {
      _settings = await ServerSettings.load();
    }

    return (_useHttps ? "https" : "http") + "://${_settings.host}:${_settings.port}/api/$endpoint";
  }

  Map<String, String> getHeaders() {
    return { "Accept": "application/json", "Content-type": "application/json" };
  }
}