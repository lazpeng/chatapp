import 'dart:convert';
import 'dart:io';

import 'package:chatapp/models/ServerModel.dart';
import 'package:chatapp/models/requests/ServerRequest.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseService {
  String _host = "onakan-chatserver.herokuapp.com";

  Future<ServerModel> getServerInfo() async {
    return null;
  }

  Future<ServerRequest> getServer() async {
    return null;
  }

  saveServer(ServerRequest server) async {
    var pref = await SharedPreferences.getInstance();
    // TODO
  }

  String apiUrl(String endpoint) {
    return "https://$_host/api/$endpoint";
  }

  Map<String, String> getHeaders() {
    return { "Accept": "application/json", "Content-type": "application/json" };
  }
}