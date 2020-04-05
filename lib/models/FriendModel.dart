class FriendModel {
  String userId;
  DateTime dateSent;

  static FriendModel fromDbCursor(Map<String, dynamic> row) {
    var friend = new FriendModel();
    friend.userId = row['SourceId'];
    friend.dateSent = DateTime.tryParse(row['RequestSent']);

    return friend;
  }
}