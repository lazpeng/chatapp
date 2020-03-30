class ChatModel {
  String username;
  String lastMessage;
  bool isMine;
  bool isSeen;
  DateTime lastSentDate;

  static ChatModel fromJsonMap(Map<String, dynamic> row) {
    var current = new ChatModel();
    current.username = row['username'];
    current.lastMessage = row['content'];
    current.isSeen = row['dateSeen'] != null;
    current.lastSentDate = DateTime.tryParse(row['dateSent']);
    current.isMine = row['isMine'] == 1;

    return current;
  }

  static ChatModel fromDbCursor(Map<String, dynamic> row) {
    var current = new ChatModel();
    current.username = row['u.Username'];
    current.lastMessage = row['m.Content'];
    current.isSeen = row['m.DateSeen'] != null;
    current.lastSentDate = DateTime.tryParse(row['m.DateSent']);
    current.isMine = row['IsMine'] == 1;

    return current;
  }
}