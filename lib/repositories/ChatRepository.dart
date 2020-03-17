import 'package:chatapp/domain/AccountDomain.dart';
import 'package:chatapp/models/ChatModel.dart';
import 'package:chatapp/models/MessageModel.dart';
import 'package:chatapp/repositories/BaseRepository.dart';
import 'package:chatapp/repositories/UserRepository.dart';

class ChatRepository extends BaseRepository {
  Future<List<MessageModel>> getMessagesForChat(String userId) async {
    var db = await getDatabase();
    var messages = new List<MessageModel>();

    var me = await accountDomain.getCurrentUser();

    var query = "SELECT * FROM Messages WHERE (SourceId = ? AND TargetId=?) OR (TargetId=? AND SourceId=?)";

    var cursor = await db.rawQuery(query, [me.id, userId, me.id, userId]);

    for(var row in cursor) {
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

      messages.add(message);
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

  Future saveNewMessage(MessageModel model) async {
    var db = await getDatabase();

    var query = "INSERT INTO Messages (Id, Content, FromId, ToId, Edited, Deleted, DateSent, DateSeen, InReplyTo)" +
      " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    var params = [model.id, model.content, model.sourceId, model.targetId, false, false, model.dateSent, null, model.inReplyTo];

    await db.rawInsert(query, params);

    await db.close();

    var me = await accountDomain.getCurrentUser();

    var userId;
    if(model.sourceId == me.id) {
      userId = model.targetId;
    } else {
      userId = model.sourceId;
    }

    await updateChat(userId, model.id);
  }

  Future<List<ChatModel>> getActiveChats() async {
    var result = new List<ChatModel>();

    var me = await accountDomain.getCurrentUser();

    var db = await getDatabase();

    var cursor = await db.rawQuery("SELECT u.Username, m.Content, m.DateSeen, m.FromId, m.DateSent FROM Chats" +
      " c INNER JOIN KnownUsers u on u.Id = c.UserId INNER JOIN Messages m on c.LastMessageId = m.Id");
    
    for(var row in cursor) {
      var current = new ChatModel();
      current.username = row['u.Username'];
      current.lastMessage = row['m.Content'];
      current.isSeen = row['m.DateSeen'] != null;
      current.lastSentDate = DateTime.tryParse(row['m.DateSent']);
      current.isMine = row['m.FromId'] == me.username;

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

  ChatRepository._internal();
}

final chatRepository = ChatRepository._internal();