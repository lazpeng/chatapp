import 'package:chatapp/blocs/ChatsBloc.dart';
import 'package:chatapp/models/ChatModel.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  final ChatsBloc _bloc = ChatsBloc();

  @override
  void initState() {
    super.initState();
    _bloc.load();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.chatsList,
      builder: (context, AsyncSnapshot<List<ChatModel>> snapshot) {
        if(snapshot.hasData) {
          var chats = snapshot.data;

          if(chats.isEmpty) {
            return Center(
              child: Text("No active chats"),
            );
          } else {
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                var chat = chats[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(5),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(chat.username.substring(0, 1).toUpperCase()),
                    ),
                    title: Text(chat.username),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(chat.lastMessage),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.check),
                            const SizedBox(width: 5),
                            Text("22:15")
                          ]
                        )
                      ]
                    )
                  )
                );
              },
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      }
    );
  }
}