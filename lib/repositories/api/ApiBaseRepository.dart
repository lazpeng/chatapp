import 'package:chatapp/models/ServerModel.dart';
import 'package:chatapp/models/requests/ServerRequest.dart';

abstract class ApiBaseRepository {
  final ServerRequest _server = ServerRequest(host: "onakan-chatserver.herokuapp.com", port: 443, https: true);

  Future<ServerModel> getServerInfo() async {
    return null;
  }

  String apiUrl(String endpoint) {
    var prefix = "http";
    if(_server.https) {
      prefix += "s";
    }
    return "$prefix://${_server.host}:${_server.port}/api/$endpoint";
  }

  Map<String, String> getHeaders() {
    return { "Accept": "application/json", "Content-type": "application/json" };
  }
}