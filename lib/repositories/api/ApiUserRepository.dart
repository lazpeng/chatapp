
import 'dart:convert';
import 'dart:io';

import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/repositories/api/ApiBaseRepository.dart';
import 'package:chatapp/services/SessionService.dart';
import 'package:http/http.dart';

class ApiUserRepository extends ApiBaseRepository {
  final SessionService _sessionService = SessionService();

  Future<List<UserModel>> getFriends() async {
    await _sessionService.ensureSession();

    var session = await _sessionService.getSavedToken();

    var url = apiUrl("friend/?User=${session.sourceId}&Token=${session.token}");

    var response = await get(url, headers: getHeaders());

    if(response.statusCode == 200) {
      // TODO: Parse this
    } else {
      throw new Exception(response.body);
    }

    return [];
  }

  Future<UserModel> getUser(String id) async {
    await _sessionService.ensureSession();
    var url = apiUrl("user/$id");

    var session = await _sessionService.getSavedToken();
    var body = { "sourceId": session.sourceId, "token": session.token };

    var response = await post(url, headers: getHeaders(), body: jsonEncode(body));

    if(response.statusCode == 200) {
      var responseMap = jsonDecode(response.body);
      return UserModel.fromJsonMap(responseMap);
    } else {
      return null;
    }
  }

  Future<String> register(UserModel user) async {
    var errorMessage = "";

    try {
      var url = apiUrl("user");

      var body = user.toJsonMap();

      var response = await post(url, body: jsonEncode(body), headers: getHeaders());

      if(response.statusCode == HttpStatus.created) {
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

  Future<List<UserModel>> search(String username) async {
    var url = apiUrl("user/search/$username");

    var response = await get(url, headers: getHeaders());

    if(response.statusCode == 200) {
      List<UserModel> results = [];

      for(var map in jsonDecode(response.body)) {
        results.add(UserModel.fromJsonMap(map));
      }

      return results;
    } else {
      print(response.body);
      return [];
    }
  }
}