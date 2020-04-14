import 'dart:convert';

import 'package:chatapp/exceptions/UnauthorizedException.dart';
import 'package:chatapp/repositories/ServerRepository.dart';
import 'package:chatapp/repositories/SessionRepository.dart';
import 'package:http/http.dart';

class LoginResponse {
  String token;
  String id;
  bool success;
  String errorMessage;

  LoginResponse({this.token, this.id, this.success, this.errorMessage});

  LoginResponse.fromJson(Map<String, dynamic> map) {
    LoginResponse(
      token: map['token'],
      id: map['id'],
      success: map['success'],
      errorMessage: map['errorMessage']
    );
  }
}

class BaseService {
  final ServerRepository _serverRepository = ServerRepository();
  final SessionRepository _sessionRepository = SessionRepository();

  Future<ServerConfiguration> getServerConfiguration() async {
    return await _serverRepository.load();
  }

  Future<String> getApiUrl(String endpoint) async {
    var config = await getServerConfiguration();

    String prefix;

    if(config.useHttps) {
      prefix = "https";
    } else {
      prefix = "http";
    }

    return '$prefix://${config.host}:${config.port}/api/$endpoint';
  }

  Map<String, String> getHeaders() {
    return { "Accept": "application/json", "Content-type": "application/json" };
  }

  Future _ensureAuthenticated() async {
    var savedSession = await _sessionRepository.loadSessionInfo();

    if(savedSession.token != null && savedSession.token.isNotEmpty) {
      var checkResponse = await postRequest("session/check", savedSession.toJsonMap(), ignoreAuth: true);

      if(checkResponse.statusCode == 200) {
        return;
      }
    }

    // It reaches here if we don't have a session stored in the shared preferences or
    // if the saved session is now expired, so we try to log in again

    var savedLogin = await _sessionRepository.loadLoginInfo();

    if(savedLogin.username != null && savedLogin.username.isNotEmpty) {
      var loginResponse = await postRequest("session/login", savedLogin.toJsonMap(), ignoreAuth: true);

      if(loginResponse.statusCode == 200) {
        var response = LoginResponse.fromJson(jsonDecode(loginResponse.body));

        if(response.success) {
          var session = SessionInfo(token: response.token, sourceId: response.id);
          await _sessionRepository.saveSessionInfo(session);
          return;
        } else {
          print("An error occurred when logging in: ${response.errorMessage}");
        }
      }
    }

    // We couldn't ensure the current user is authenticated
    throw UnauthorizedException();
  }

  Future<LoginResponse> performLogin(String username, String password, bool appearOffline) async {
    var request = LoginInfo(username: username, password: password, appearOffline: appearOffline);

    var loginResponse = await postRequest("session/login", request.toJsonMap(), ignoreAuth: true);

    LoginResponse response;

    if(loginResponse.statusCode == 200) {
      response = LoginResponse.fromJson(jsonDecode(loginResponse.body));

      if(response.success) {
        var session = SessionInfo(token: response.token, sourceId: response.id);
        await _sessionRepository.saveSessionInfo(session);
      } else {
        print("An error occurred when logging in: ${response.errorMessage}");
        response = LoginResponse(success: false, errorMessage: loginResponse.body);
      }
    } else {
      response = LoginResponse(success: false, errorMessage: loginResponse.body);
    }

    return response;
  }

  Future<Response> postRequest(String endpoint, Map<String, dynamic> body, {bool ignoreAuth}) async {
    try {
      if(ignoreAuth != null && ignoreAuth) {
        _ensureAuthenticated();
      }

      return await post(getApiUrl(endpoint), headers: getHeaders(), body: jsonEncode(body));
    } catch (err) {
      print("An error occurred when performing a post request. Endpoint: $endpoint. Body: ${jsonEncode(body)}");
      print(err);
      rethrow;
    }
  }

  Future<Response> getRequest(String endpoint, {bool ignoreAuth}) async {
    try {
      if(ignoreAuth != null && ignoreAuth) {
        _ensureAuthenticated();
      }

      return await get(getApiUrl(endpoint), headers: getHeaders());
    } catch (err) {
      print("An error occurred when performing a post request. Endpoint: $endpoint.");
      print(err);
      rethrow;
    }
  }

  Future<Response> putRequest(String endpoint, Map<String, dynamic> body, {bool ignoreAuth}) async {
    try {
      if(ignoreAuth != null && ignoreAuth) {
        _ensureAuthenticated();
      }

      return await put(getApiUrl(endpoint), headers: getHeaders(), body: jsonEncode(body));
    } catch (err) {
      print("An error occurred when performing a post request. Endpoint: $endpoint. Body: ${jsonEncode(body)}");
      print(err);
      rethrow;
    }
  }

  Future<Response> deleteRequest(String endpoint, {bool ignoreAuth}) async {
    try {
      if(ignoreAuth != null && ignoreAuth) {
        _ensureAuthenticated();
      }

      return await delete(getApiUrl(endpoint), headers: getHeaders());
    } catch (err) {
      print("An error occurred when performing a post request. Endpoint: $endpoint.");
      print(err);
      rethrow;
    }
  }
}