import 'dart:convert';

import 'package:chatapp/SessionSettings.dart';
import 'package:chatapp/models/UserModel.dart';
import 'package:http/http.dart';

import 'BaseService.dart';

class AccountService extends BaseService {

  Future<String> createAccount(UserModel user) async {
    var errorMessage = "";

    try {
      var url = apiUrl("user/register");

      var body = user.toJsonMap();

      var response = await post(url, body: jsonEncode(body), headers: getHeaders());

      if(response.statusCode == 200) {
        var responseMap = jsonDecode(response.body);

        if(responseMap['id'] == null) {
          errorMessage = response.body;
        }
      } else {
        errorMessage = response.body;
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    return errorMessage;
  }

  Future<String> performLogin(String username, String password, bool appearOffline) async {
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
        var map = jsonDecode(response.body);

        if(map['success']) {
            var token = map['token'];
            var id = map['userId'];

            SessionSettings.login(id, token);
        } else {
          errorMessage = map['errorMessage'];
        }
      } else {
        errorMessage = response.body;
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    return errorMessage;
  }

  AccountService._internal();
}

final accountService =  AccountService._internal();