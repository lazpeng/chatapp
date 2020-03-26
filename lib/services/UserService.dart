import 'dart:convert';

import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/repositories/UserRepository.dart';
import 'package:chatapp/services/BaseService.dart';
import 'package:chatapp/services/SessionService.dart';
import 'package:http/http.dart';

class UserService extends BaseService {
  SessionService _sessionService = new SessionService();

  Future<UserModel> getUser(String id) async {
    var cached = await userRepository.getUser(id);

    if(cached == null) {
      var session = await _sessionService.getSessionInformation();
      var url = apiUrl("user/$id");

      var body = { "sourceId": session.userId, "token": session.token };

      var response = await post(url, headers: getHeaders(), body: jsonEncode(body));

      if(response.statusCode == 200) {
        var responseMap = jsonDecode(response.body);
        var user = UserModel.fromJsonMap(responseMap);

        userRepository.saveUser(user);
        cached = user;
      } else {
        cached = null;
      }
    }

    return cached;
  }

  Future<String> register(UserModel user) async {
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
}