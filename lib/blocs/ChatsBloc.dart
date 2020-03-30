import 'package:chatapp/models/ChatModel.dart';
import 'package:rxdart/rxdart.dart';

class ChatsBloc {
  final BehaviorSubject<List<ChatModel>> _chatsList = BehaviorSubject<List<ChatModel>>();
  ValueStream<List<ChatModel>> get chatsList => _chatsList.stream;

  Future load() async {
    
  }

  dispose() {
    _chatsList.close();
  }
}