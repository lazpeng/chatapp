
import 'package:chatapp/models/requests/CheckRequest.dart';
import 'package:chatapp/models/requests/LoginRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LocalBaseRepository.dart';

class LocalSessionRepository extends LocalBaseRepository {
  static const String _KEY_USERNAME = "CHATAPP_USERNAME";
  static const String _KEY_PASSWORD = "CHATAPP_PASSWORD";
  static const String _KEY_OFFLINE  = "CHATAPP_OFFLINE";
  static const String _KEY_TOKEN    = "CHATAPP_TOKEN";
  static const String _KEY_USER_ID  = "CHATAPP_USERID";

  Future<LoginRequest> getSavedLogin() async {
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

  saveLogin(LoginRequest request) async {
    var pref = await SharedPreferences.getInstance();

    pref.setString(_KEY_USERNAME, request?.username);
    pref.setString(_KEY_PASSWORD, request?.password);
    pref.setBool(_KEY_OFFLINE, request?.appearOffline);
  }

  Future<CheckRequest> getSavedToken() async {
    var pref = await SharedPreferences.getInstance();

    if(!pref.containsKey(_KEY_TOKEN)) {
      return null;
    }

    return new CheckRequest(pref.getString(_KEY_USER_ID), pref.getString(_KEY_TOKEN));
  }

  saveToken(CheckRequest session) async {
    var pref = await SharedPreferences.getInstance();

    pref.setString(_KEY_USER_ID, session?.sourceId);
    pref.setString(_KEY_TOKEN, session?.token);
  }
}