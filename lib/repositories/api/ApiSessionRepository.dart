
import 'dart:convert';

import 'package:chatapp/models/requests/CheckRequest.dart';
import 'package:chatapp/models/requests/LoginRequest.dart';
import 'package:chatapp/repositories/api/ApiBaseRepository.dart';
import 'package:http/http.dart';

class ApiSessionRepository extends ApiBaseRepository {
  Future<CheckRequest> login(LoginRequest login) async {
    Map<String, dynamic> body = login.toJsonMap();

    var response = await post(apiUrl("session/login"), headers: getHeaders(), body: jsonEncode(body));

    if(response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      if(!responseBody["success"]) {
        throw new Exception(responseBody['errorMessage']);
      }
      return new CheckRequest(responseBody["id"], responseBody["token"]);
    } else {
      throw new Exception(response.body);
    }
  }

  Future<bool> check(CheckRequest request) async {
    return false;
  }
}