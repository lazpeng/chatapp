import 'dart:convert';
import 'dart:io';

import 'package:chatapp/models/requests/LoginRequest.dart';
import 'package:chatapp/models/requests/SessionRequest.dart';
import 'package:chatapp/services/BaseService.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService extends BaseService {

  static const String _KEY_USERNAME = "CHATAPP_USERNAME";
  static const String _KEY_PASSWORD = "CHATAPP_PASSWORD";
  static const String _KEY_OFFLINE  = "CHATAPP_OFFLINE";
  static const String _KEY_TOKEN    = "CHATAPP_TOKEN";
  static const String _KEY_USER_ID  = "CHATAPP_USERID";

  Future<LoginRequest> getLoginInformation() async {
    var pref = await SharedPreferences.getInstance();

    if(!pref.containsKey(_KEY_USERNAME)) {
      return null;
    }

    var login = new LoginRequest();
    login.username = pref.getString(_KEY_USERNAME);
    login.password = pref.getString(_KEY_PASSWORD);
    login.appearOffline = pref.getBool(_KEY_OFFLINE);

    return login;
  }

  saveLoginInformation(LoginRequest request) async {
    var pref = await SharedPreferences.getInstance();

    pref.setString(_KEY_USERNAME, request?.username);
    pref.setString(_KEY_PASSWORD, request?.password);
    pref.setBool(_KEY_OFFLINE, request?.appearOffline);
  }

  Future<SessionRequest> getSessionInformation() async {
    var pref = await SharedPreferences.getInstance();

    var session = new SessionRequest();

    if(!pref.containsKey(_KEY_TOKEN)) {
      return session;
    }

    session.userId = pref.getString(_KEY_USER_ID);
    session.token = pref.getString(_KEY_TOKEN);

    return session;
  }

  saveSessionInformation(SessionRequest session) async {
    var pref = await SharedPreferences.getInstance();

    pref.setString(_KEY_USER_ID, session?.userId);
    pref.setString(_KEY_TOKEN, session?.token);
  }

  Future<String> performLogin(LoginRequest login) async {
    var message = "";

    Map<String, dynamic> body = {
      "username": login.username,
      "password": login.password,
      "appearOffline": login.appearOffline
    };

    var response = await post(apiUrl("session/login"), headers: getHeaders(), body: jsonEncode(body));

    if(response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      if(!responseBody["success"]) {
        message = responseBody["errorMessage"];
      }
      var session = new SessionRequest();
      session.token = responseBody["token"];
      session.userId = responseBody["id"];
      await saveSessionInformation(session);
    } else {
      message = response.body;
    }

    return message;
  }

  void ensureSession() async {
    var session = await getSessionInformation();
    var url = apiUrl("session/check");

    var body = {
      "userId": session.userId,
      "token": session.token
    };

    var response = await post(url, headers: getHeaders(), body: jsonEncode(body));

    if(response.statusCode == 200) {
      return;
    } else if(response.statusCode == HttpStatus.unauthorized) {
      var login = await getLoginInformation();

      var message = await performLogin(login);
      if(message != "") {
        throw new Exception(message);
      }
    }
  }
}