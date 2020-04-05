import 'package:chatapp/models/FriendModel.dart';
import 'package:chatapp/models/FriendRequestModel.dart';
import 'package:chatapp/models/UserModel.dart';
import 'LocalBaseRepository.dart';

class LocalUserRepository extends LocalBaseRepository {
  Future<UserModel> getUser(String id) async {
    var db = await getDatabase();

    UserModel user;

    var query = "SELECT * FROM KnownUsers WHERE Id = ?";
    var rows = await db.rawQuery(query, [id]);

    if(rows.length > 0) {
      var row = rows[0];
      user = UserModel.fromDbCursor(row);
    }

    return user;
  }

  Future deleteFriends() async {
    var db = await getDatabase();

    await db.rawDelete("DELETE FROM Friends");
  }

  Future deleteBlocked() async {
    var db = await getDatabase();

    await db.rawDelete("DELETE FROM Blocked");
  }

  Future deleteRequests() async {
    var db = await getDatabase();

    await db.rawDelete("DELETE FROM Requests");
  }

  Future deletePersonalInfo() async {
    await deleteFriends();
    await deleteBlocked();
    await deleteRequests();

    var tables =
    [
      "Messages", "Chats", "Logs", "EditHistory", "DeleteHistory"
    ];

    var db = await getDatabase();

    for(var table in tables) {
      await db.rawDelete("DELETE FROM $table");
    }
  }

  Future saveUser(UserModel user) async {
    var db = await getDatabase();

    var query = "INSERT INTO KnownUsers (Id, Username, FullName, Email, Bio, AccountCreated, LastLogin," +
    " LastSeen, DateOfBirth, FindInSearch, OpenChat, DataHash) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    var lastSeen = user.lastSeen == null ? '' : user.lastSeen.toIso8601String();
    var dob = user.dateOfBirth == null ? '' :  user.dateOfBirth.toIso8601String();
    var accountCreated = user.accountCreated == null ? '' : user.accountCreated.toIso8601String();
    var lastLogin = user.lastLogin == null ? '' :  user.lastLogin.toIso8601String();

    var params = [user.id, user.username, user.fullName, user.email, user.bio, accountCreated, lastLogin,
      lastSeen, dob, user.findInSearch, user.openChat, user.dataHash];

    await db.rawInsert(query, params);
  }

  Future saveFriend(FriendModel friend) async {
    var db = await getDatabase();

    await db.rawInsert("INSERT INTO Friends (UserId, DateSent) VALUES (?, ?)", [friend.userId, friend.dateSent.toIso8601String()]);    
  }

  Future saveRequest(FriendRequestModel request, String currentUser) async {
    var db = await getDatabase();

    var isMine = request.sourceId == currentUser;
    var userId = isMine ? request.targetId : request.sourceId;

    await db.rawInsert("INSERT INTO Requests (Id, UserId, Mine, SentDate) VALUES (?, ?, ?, ?)", [request.id, userId, isMine, request.dateSent.toIso8601String()]);    
  }

  Future saveBlocked(String userId) async {
    var db = await getDatabase();

    await db.rawInsert("INSERT INTO Blocked (UserId, DateBlocked) VALUES (?, CURRENT_DATE)", [ userId ]);    
  }

  Future hasPendingRequestTo(String userId) async {
    var db = await getDatabase();

    var cursor = await db.rawQuery("SELECT * FROM Requests WHERE UserId = ? AND Mine = 1", [userId]);

    return cursor.length != 0;
  }

  Future hasPendingRequestFrom(String userId) async {
    var db = await getDatabase();

    var cursor = await db.rawQuery("SELECT * FROM Requests WHERE UserId = ? AND Mine = 0", [userId]);

    return cursor.length != 0;
  }

  Future<List<UserModel>> getFriends() async {
    var db = await getDatabase();
    var query = "SELECT * FROM Friends INNER JOIN KnownUsers ON Id = UserId";

    var rows = await db.rawQuery(query);
    List<UserModel> results = [];

    for(var row in rows) {
      results.add(UserModel.fromDbCursor(row));
    }

    return results;
  }

  Future<List<FriendRequestModel>> getRequests() async {
    var db = await getDatabase();

    List<FriendRequestModel> results = [];

    var cursor = await db.rawQuery("SELECT * FROM Requests");

    for(var row in cursor) {
      results.add(FriendRequestModel.fromDbCursor(row));
    }

    return results;
  }

  Future<List<UserModel>> getBlockedUsers() async {
    var db = await getDatabase();

    var query = "SELECT * FROM Blocked INNER JOIN KnownUsers ON Id = UserId";

    var rows = await db.rawQuery(query);
    var results = new List<UserModel>();

    for(var row in rows) {
      results.add(UserModel.fromDbCursor(row));
    }

    return results;
  }

  Future<bool> isFriendsWith(String id) async {
    var db = await getDatabase();

    var cursor = await db.rawQuery("SELECT * FROM Friends WHERE UserId = ?", [id]);
  
    return cursor.length != 0;
  }
}
