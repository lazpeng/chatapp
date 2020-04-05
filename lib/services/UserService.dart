import 'package:chatapp/models/FriendRequestModel.dart';
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
    return await _localUserRepository.getFriends();
  }

  Future<List<FriendRequestModel>> getPendingFriendRequests() async {
    return await _localUserRepository.getRequests();
  }

  Future<List<UserModel>> getBlockedUsers() async {
    return await _localUserRepository.getBlockedUsers();
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
    await _localUserRepository.deletePersonalInfo();

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
    await _apiUserRepository.sendFriendRequest(userId);
  }

  Future answerFriendRequest(int id, bool answer) async {
    await _apiUserRepository.answerFriendRequest(id, answer);
  }

  Future<bool> isFriendsWith(String userId) async {
    return _localUserRepository.isFriendsWith(userId);
  }

  Future<bool> hasPendingRequestTo(String userId) async {
    return await _localUserRepository.hasPendingRequestTo(userId);
  }

  Future<bool> hasPendingRequestFrom(String userId) async {
    return await _localUserRepository.hasPendingRequestFrom(userId);
  }

  Future refreshFriendList() async {
    var friends = await _apiUserRepository.getFriends();

    await _localUserRepository.deleteFriends();

    for(var friend in friends) {
      await _localUserRepository.saveFriend(friend);
    }
  }

  Future refreshUsers() async {
    // TODO
  }

  Future refreshRequests() async {
    var requests = await _apiUserRepository.getRequests();

    await _localUserRepository.deleteRequests();
    var currentUser = await _sessionService.getSavedToken();

    for(var req in requests) {
      await _localUserRepository.saveRequest(req, currentUser.sourceId);
    }
  }

  Future refreshBlocked() async {
    var blocked = await _apiUserRepository.getBlocked();

    await _localUserRepository.deleteBlocked();
    for(var b in blocked) {
      await _localUserRepository.saveBlocked(b);
    }
  }

  Future refreshAll() async {
    await refreshFriendList();
    await refreshUsers();
    await refreshRequests();
    await refreshBlocked();
  }
}