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
}