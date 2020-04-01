import 'package:chatapp/models/ChatModel.dart';
import 'package:chatapp/repositories/api/ApiChatRepository.dart';
import 'package:chatapp/repositories/local/LocalChatRepository.dart';
import 'package:chatapp/services/SessionService.dart';

class ChatService {
  final LocalChatRepository _localChatRepository = LocalChatRepository();
  final ApiChatRepository _apiChatRepository = ApiChatRepository();
  final SessionService _sessionService = SessionService();

  Future<List<ChatModel>> getChats() async {
    var info = await _sessionService.getSavedToken();
    return await _localChatRepository.getActiveChats(info.sourceId);
  }
}