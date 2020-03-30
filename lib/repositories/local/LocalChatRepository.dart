import 'package:chatapp/models/ChatModel.dart';
import 'package:chatapp/models/MessageModel.dart';

import 'LocalBaseRepository.dart';

class LocalChatRepository extends LocalBaseRepository {
  Future<List<MessageModel>> getMessagesForChat(String currentUser, String userId) async {
    var db = await getDatabase();
    var messages = new List<MessageModel>();

    var query = "SELECT * FROM Messages WHERE (SourceId = ? AND TargetId=?) OR (TargetId=? AND SourceId=?)";

    var cursor = await db.rawQuery(query, [currentUser, userId, currentUser, userId]);

    for(var row in cursor) {
      messages.add(MessageModel.fromDbCursor(row));
    }

    await db.close();
    return messages;
  }

  Future saveDeletedMessage(int id) async {
    var db = await getDatabase();

    var query = "UPDATE Messages SET Deleted=TRUE WHERE Id=?";

    await db.rawUpdate(query, [id]);
    await db.close();
  }

  Future saveEditedMessage(int id, String content) async {
    var db = await getDatabase();

    var query = "UPDATE Messages SET Content=?, Edited=TRUE WHERE Id=?";

    await db.rawUpdate(query, [content, id]);
    await db.close();
  }

  Future updateChat(String userId, int messageId) async {
    var db = await getDatabase();

    var query = "UPDATE Chats SET LastMessageId = ? WHERE UserId=?";

    var affected = await db.rawUpdate(query, [messageId, userId]);

    if(affected == 0) {
      await db.rawInsert("INSERT INTO Chats (UserId, LastMessageId) VALUES (?, ?)", [userId, messageId]);
    }

    await db.close();
  }

  Future saveNewMessage(String currentUser, MessageModel model) async {
    var db = await getDatabase();

    var query = "INSERT INTO Messages (Id, Content, FromId, ToId, Edited, Deleted, DateSent, DateSeen, InReplyTo)" +
      " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    var params = [model.id, model.content, model.sourceId, model.targetId, false, false, model.dateSent, null, model.inReplyTo];

    await db.rawInsert(query, params);

    await db.close();

    var userId;
    if(model.sourceId == currentUser) {
      userId = model.targetId;
    } else {
      userId = model.sourceId;
    }

    await updateChat(userId, model.id);
  }

  Future<List<ChatModel>> getActiveChats(String currentUser) async {
    var result = new List<ChatModel>();

    var db = await getDatabase();

    var cursor = await db.rawQuery("SELECT u.Username, m.Content, m.DateSeen, m.FromId, m.DateSent,"+
        "(CASE WHEN m.FromId = @CurrentUser THEN 1 ELSE 0 END) AS isMine FROM Chats" +
        " c INNER JOIN KnownUsers u on u.Id = c.UserId INNER JOIN Messages m on c.LastMessageId = m.Id");
    
    for(var row in cursor) {
      var current = ChatModel.fromDbCursor(row);
      result.add(current);
    }

    var test = new ChatModel();
    test.lastMessage = "Mensagem teste";
    test.username = "testuser1";
    test.isSeen = true;
    test.lastSentDate = DateTime.now();
    test.isMine = false;

    result.add(test);

    test = new ChatModel();
    test.lastMessage = "Outra mensagem teste";
    test.username = "user2";
    test.isSeen = true;
    test.lastSentDate = DateTime.now();
    test.isMine = true;

    result.add(test);

    await db.close();
    return result;
  }
}
