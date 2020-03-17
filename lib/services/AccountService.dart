import 'dart:convert';

import 'package:chatapp/SessionSettings.dart';
import 'package:chatapp/models/UserModel.dart';
import 'package:http/http.dart';

import 'BaseService.dart';

class AccountService extends BaseService {

  Future<dynamic> createAccount(UserModel user) async {
    var errorMessage = "";

    try {
      var url = apiUrl("user/register");

      var body = user.toJsonMap();

      var response = await post(url, body: jsonEncode(body), headers: getHeaders());

      if(response.statusCode == 200) {
        var responseMap = jsonDecode(response.body);

        if(responseMap['id'] == null) {
          errorMessage = response.body;
        } else {
          var user = UserModel.fromJsonMap(responseMap);

          return user;
        }
      } else {
        errorMessage = response.body;
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    return errorMessage;
  }

  Future<Map<String, dynamic>> performLogin(String username, String password, bool appearOffline) async {
    var errorMessage = "";

    try {
      var url = apiUrl("session/login");

      var body = {
        "username": username,
        "password": password,
        "appearOffline": appearOffline
      };

      var response = await post(url, body: jsonEncode(body), headers: getHeaders());

      if(response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        errorMessage = response.body;
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    return { "errorMessage": errorMessage };
  }

  Future<UserModel> getUser(String id) async {
    var session = await SessionSettings.load();
    var url = apiUrl("user/get/$id");

    var body = { "sourceId": session.userId, "token": session.sessionToken };

    var response = await post(url, headers: getHeaders(), body: jsonEncode(body));

    if(response.statusCode == 200) {
      var responseMap = jsonDecode(response.body);
      var user = UserModel.fromJsonMap(responseMap);

      return user;
    }

    return null;
  }

  AccountService._internal();
}

final accountService =  AccountService._internal();