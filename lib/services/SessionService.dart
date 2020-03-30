
import 'package:chatapp/models/requests/CheckRequest.dart';
import 'package:chatapp/models/requests/LoginRequest.dart';
import 'package:chatapp/repositories/api/ApiSessionRepository.dart';
import 'package:chatapp/repositories/local/LocalSessionRepository.dart';

class SessionService {
  final LocalSessionRepository _localSessionRepository = LocalSessionRepository();
  final ApiSessionRepository _apiSessionRepository = ApiSessionRepository();

  Future<String> performLogin(LoginRequest login) async {
    try {
      var response = await _apiSessionRepository.login(login);
      
      await _localSessionRepository.saveLogin(login);
      await _localSessionRepository.saveToken(response);
    } catch (e, stack) {
      print(stack);
      return e.toString();
    }

    return "";
  }

  Future<CheckRequest> getSavedToken() async {
    return await _localSessionRepository.getSavedToken();
  }

  Future ensureSession() async {
    var session = await _localSessionRepository.getSavedToken();
    
    if(! await _apiSessionRepository.check(session)) {
      var login = await _localSessionRepository.getSavedLogin();
      await performLogin(login);
    }
  }
}