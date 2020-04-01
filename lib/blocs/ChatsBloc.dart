import 'package:chatapp/models/ChatModel.dart';
import 'package:chatapp/services/ChatService.dart';
import 'package:rxdart/rxdart.dart';

class ChatsBloc {
  final BehaviorSubject<List<ChatModel>> _chatsList = BehaviorSubject<List<ChatModel>>();
  ValueStream<List<ChatModel>> get chatsList => _chatsList.stream;

  final ChatService _chatService = ChatService();

  Future load() async {
    var chats = await _chatService.getChats();
    _chatsList.sink.add(chats);
  }

  dispose() {
    _chatsList.close();
  }
}