
import 'dart:convert';
import 'dart:io';

import 'package:chatapp/models/FriendModel.dart';
import 'package:chatapp/models/FriendRequestModel.dart';
import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/repositories/api/ApiBaseRepository.dart';
import 'package:chatapp/services/SessionService.dart';
import 'package:http/http.dart';

class ApiUserRepository extends ApiBaseRepository {
  final SessionService _sessionService = SessionService();

  Future<List<FriendModel>> getFriends() async {
    await _sessionService.ensureSession();

    var session = await _sessionService.getSavedToken();

    var url = apiUrl("friend/?User=${session.sourceId}&Token=${session.token}");

    var response = await get(url, headers: getHeaders());

    List<FriendModel> results = [];

    if(response.statusCode == 200) {
      var map = jsonDecode(response.body);

      for(var row in map) {
        var friend = new FriendModel();
        friend.userId = row['sourceId'] == session.sourceId ? row['targetId'] : row['sourceId'];
        friend.dateSent = DateTime.tryParse(row['requestSent']);

        results.add(friend);
      }
    } else {
      throw new Exception(response.body);
    }

    return results;
  }

  Future sendFriendRequest(String userId) async {
    await _sessionService.ensureSession();
    var session = await _sessionService.getSavedToken();

    var body = {
      'sourceId': session.sourceId,
      'token': session.token
    };

    var url = apiUrl("friend/request/$userId");
    var response = await post(url, headers: getHeaders(), body: jsonEncode(body));

    if(response.statusCode != 200) {
      print(response.body);
    }
  }

  Future answerFriendRequest(int id, bool answer) async {
    await _sessionService.ensureSession();
    var session = await _sessionService.getSavedToken();

    var body = {
      'sourceId': session.sourceId,
      'token': session.token,
      'accepted': answer
    };

    var url = apiUrl("friend/request/$id");
    var response = await put(url, headers: getHeaders(), body: jsonEncode(body));

    if(response.statusCode != 200) {
      print(response.body);
    }
  }

  Future<List<String>> getBlocked() async {
   await _sessionService.ensureSession();

    var session = await _sessionService.getSavedToken();

    var url = apiUrl("block/?SourceId=${session.sourceId}&Token=${session.token}");

    var response = await get(url, headers: getHeaders());

    List<String> results = [];

    if(response.statusCode == 200) {
      var map = jsonDecode(response.body);

      for(var row in map) {
        results.add(row['blockedUser']);
      }
    } else {
      throw new Exception(response.body);
    }

    return results;
  }

  Future<List<FriendRequestModel>> getRequests() async {
    await _sessionService.ensureSession();

    var session = await _sessionService.getSavedToken();

    var url = apiUrl("friend/request?User=${session.sourceId}&Token=${session.token}");

    var response = await get(url, headers: getHeaders());

    List<FriendRequestModel> results = [];

    if(response.statusCode == 200) {
      var map = jsonDecode(response.body);

      for(var row in map) {
        results.add(FriendRequestModel.fromJsonMap(row));
      }
    } else {
      throw new Exception(response.body);
    }

    return results;
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