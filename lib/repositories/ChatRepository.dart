import 'package:chatapp/models/ChatModel.dart';
import 'package:chatapp/repositories/BaseRepository.dart';
import 'package:chatapp/repositories/UserRepository.dart';

class ChatRepository extends BaseRepository {
  Future<List<ChatModel>> getActiveChats() async {
    var db = await getDatabase();
    var result = new List<ChatModel>();

    var me = await userRepository.getCurrentUser();

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
    test.lastMessage = "Outra mensagem teste 2";
    test.username = "user2";
    test.isSeen = true;
    test.lastSentDate = DateTime.now();
    test.isMine = false;

    result.add(test);

    return result;
  }

  ChatRepository._internal();
}

final chatRepository = ChatRepository._internal();