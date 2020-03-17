import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/repositories/UserRepository.dart';
import 'package:chatapp/services/AccountService.dart';

import '../SessionSettings.dart';
import '../LoginSettings.dart';

class AccountDomain {

  Future<String> performLogin(String username, String password, bool appearOffline) async {
    var res = await accountService.performLogin(username, password, appearOffline);

    if(res['errorMessage'] != '' && res['errorMessage'] != null) {
      return res['errorMessage'];
    }

    var id = res['id'];
    var token = res['token'];
    SessionSettings.login(id, token);
    LoginSettings.save(username, password, appearOffline);

    if(userRepository.getUser(id) == null) {
      var user = await accountService.getUser(id);
      if(user != null) {
        await userRepository.saveUser(user);
      }
    }

    return '';
  }

  Future<UserModel> getUser(String id) async {
    var local = await userRepository.getUser(id);

    if(local == null) {
      local = await accountService.getUser(id);
      await userRepository.saveUser(local);
      local = await userRepository.getUser(id);
    }

    return local;
  }

  Future<List<UserModel>> getFriendList() async {
    return await userRepository.getFriends();
  }

  Future<UserModel> getCurrentUser() async {
    var session = await SessionSettings.load();

    return getUser(session.userId);
  }

  Future<String> registerAccount(UserModel model) async {
    var res = await accountService.createAccount(model);

    if(res is UserModel) {
      await userRepository.saveUser(res);

      return performLogin(model.username, model.password, false);
    }

    return res;
  }

  AccountDomain._internal();
}

final accountDomain = AccountDomain._internal();