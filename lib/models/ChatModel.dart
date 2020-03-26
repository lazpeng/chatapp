class ChatModel {
  String username;
  String lastMessage;
  bool isMine;
  bool isSeen;
  DateTime lastSentDate;

  static ChatModel fromJsonMap(Map<String, dynamic> map) {

  }

  static ChatModel fromDbCursor(Map<String, dynamic> row) {
    var current = new ChatModel();
    current.username = row['u.Username'];
    current.lastMessage = row['m.Content'];
    current.isSeen = row['m.DateSeen'] != null;
    current.lastSentDate = DateTime.tryParse(row['m.DateSent']);
    current.isMine = row['isMine'] == 1;

    return current;
  }

  Map<String, dynamic> toJsonMap() {

  }
}