import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/models/requests/LoginRequest.dart';
import 'package:chatapp/repositories/api/ApiUserRepository.dart';
import 'package:chatapp/repositories/local/LocalUserRepository.dart';
import 'package:chatapp/services/SessionService.dart';

class UserService {
  final SessionService _sessionService = SessionService();
  final LocalUserRepository _localUserRepository = LocalUserRepository();
  final ApiUserRepository _apiUserRepository = ApiUserRepository();

  Future<List<UserModel>> getFriends() async {
    return null;
  }

  Future<List<UserModel>> getPendingFriendRequests() async {
    return null;
  }

  Future<List<UserModel>> getBlockedUsers() async {
    return null;
  }

  Future<UserModel> getCurrentUser() async {
    var saved = await _sessionService.getSavedToken();

    return await getUser(saved.sourceId);
  }

  Future<UserModel> getUser(String id) async {
    var cached = await _localUserRepository.getUser(id);

    if(cached == null) {
      cached = await _apiUserRepository.getUser(id);

      if(cached != null) {
        _localUserRepository.saveUser(cached);
      }
    }

    return cached;
  }

  Future<String> performLogin(LoginRequest login) async {
    var result = await _sessionService.performLogin(login);
    if(result.isNotEmpty) {
      return result;
    }

    return result;
  }

  Future<List<UserModel>> search(String username) async {
    return await _apiUserRepository.search(username);
  }

  Future<String> register(UserModel user) async {
    return await _apiUserRepository.register(user);
  }

  Future sendFriendRequest(String userId) async {
  }

  Future<bool> isFriendsWith(String userId) async {

return false;
  }

  Future<bool> hasPendingRequestTo(String userId) async {

    return false;
  }
}