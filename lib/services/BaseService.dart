abstract class BaseService {
  String _host = "onakan-chatserver.herokuapp.com";

  String apiUrl(String endpoint) {
    return "https://$_host/api/$endpoint";
  }

  Map<String, String> getHeaders() {
    return { "Accept": "application/json", "Content-type": "application/json" };
  }
}