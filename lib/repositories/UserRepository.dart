import 'package:chatapp/SessionSettings.dart';
import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/repositories/BaseRepository.dart';

class UserRepository extends BaseRepository {
  Future<UserModel> getUser(String id) async {
    var db = await getDatabase();

    UserModel user;

    var query = "SELECT * FROM KnownUsers WHERE Id = ?";
    var rows = await db.rawQuery(query, [id]);

    if(rows.length > 0) {
      var row = rows[0];
      user = UserModel.fromDatabaseMap(row);
    }

    await db.close();
    return user;
  }

  Future saveUser(UserModel user) async {
    var db = await getDatabase();

    var query = "INSERT INTO KnownUsers (Id, Username, FullName, Email, Bio, AccountCreated, LastLogin," +
    " LastSeen, DateOfBirth, FindInSearch, OpenChat) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    var params = [user.id, user.username, user.fullName, user.email, user.bio, user.accountCreated.toIso8601String(), user.lastLogin.toIso8601String(),
      user.lastSeen.toIso8601String(), user.dateOfBirth.toIso8601String(), user.findInSearch, user.openChat];

    await db.rawInsert(query, params);

    await db.close();
  }

  Future<List<UserModel>> getFriends() async {
    var db = await getDatabase();

    var query = "SELECT * FROM Friends f INNER JOIN KnownUsers ON Id = UserId WHERE DateAccepted IS NOT NULL";

    var rows = await db.rawQuery(query);
    var results = new List<UserModel>();

    for(var row in rows) {
      results.add(UserModel.fromDatabaseMap(row));
    }

    return results;
  }

  UserRepository._internal();
}

final userRepository = UserRepository._internal();