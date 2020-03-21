import 'dart:convert';
import 'dart:io';

import 'package:chatapp/SessionSettings.dart';
import 'package:http/http.dart';

import '../LoginSettings.dart';

abstract class BaseService {
  String _host = "onakan-chatserver.herokuapp.com";

  String apiUrl(String endpoint) {
    return "https://$_host/api/$endpoint";
  }

  void ensureSession() async {
    var session = await SessionSettings.load();
    var url = apiUrl("session/check");

    var body = {
      "userId": session.userId,
      "token": session.sessionToken
    };

    var response = await post(url, headers: getHeaders(), body: jsonEncode(body));

    if(response.statusCode == 200) {
      return;
    } else if(response.statusCode == HttpStatus.unauthorized) {
      var login = await LoginSettings.load();

      Map<String, dynamic> body = {
        "username": login.savedUsername,
        "password": login.savedPassword,
        "appearOffline": login.appearOffline
      };

      response = await post(apiUrl("session/login"), headers: getHeaders(), body: jsonEncode(body));

      if(response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var success = responseBody["success"];
        if(!success) {
          throw new Exception(responseBody["errorMessage"]);
        }
        var id = responseBody["id"];
        var token = responseBody["token"];
        await SessionSettings.login(id, token);
      }
    }
  }

  Map<String, String> getHeaders() {
    return { "Accept": "application/json", "Content-type": "application/json" };
  }
}