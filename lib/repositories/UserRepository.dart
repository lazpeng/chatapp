import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/repositories/BaseRepository.dart';

class UserRepository extends BaseRepository {
  Future<UserModel> getCurrentUser() async {
    return null;
  }

  UserRepository._internal() {

  }
}

final userRepository = UserRepository._internal();