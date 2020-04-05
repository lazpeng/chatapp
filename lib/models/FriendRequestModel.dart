class FriendRequestModel {
  int id;
  String sourceId;
  String targetId;
  String userId;
  bool isMine;
  DateTime dateSent;

  static FriendRequestModel fromJsonMap(Map<String, dynamic> row) {
    var request = new FriendRequestModel();
    request.id = row['id'];
    request.sourceId = row['sourceId'];
    request.targetId = row['targetId'];
    request.dateSent = DateTime.tryParse(row['sentDate']);

    return request;
  }

  static FriendRequestModel fromDbCursor(Map<String, dynamic> row) {
    var request = new FriendRequestModel();
    request.id = row['Id'];
    request.userId = row['UserId'];
    request.isMine = row['Mine'] != 0;
    request.dateSent = DateTime.tryParse(row['SentDate']);

    return request;
  }
}