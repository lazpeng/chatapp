class MessageModel {
  int id;
  String sourceId;
  String targetId;
  DateTime dateSent;
  DateTime dateSeen;
  int inReplyTo;
  String content;
  bool edited;
  bool deleted;

  static MessageModel fromJsonMap(Map<String, dynamic> row) {
    var message = new MessageModel();
    message.id = row['id'];
    message.content = row['content'];
    message.dateSeen = DateTime.tryParse(row['dateSeen']);
    message.dateSent = DateTime.tryParse(row['dateSent']);
    message.sourceId = row['fromId'];
    message.targetId = row['toId'];
    message.inReplyTo = row['inReplyTo'];
    message.edited = row['edited'];
    message.deleted = row['deleted'];

    return message;
  }

  static MessageModel fromDbCursor(Map<String, dynamic> row) {
    var message = new MessageModel();
    message.id = row['Id'];
    message.content = row['Content'];
    message.dateSeen = DateTime.tryParse(row['m.DateSeen']);
    message.dateSent = DateTime.tryParse(row['m.DateSent']);
    message.sourceId = row['FromId'];
    message.targetId = row['ToId'];
    message.inReplyTo = row['InReplyTo'];
    message.edited = row['Edited'];
    message.deleted = row['Deleted'];

    return message;
  }
}