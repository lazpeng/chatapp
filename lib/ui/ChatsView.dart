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
                return Card(
                  elevation: 4,
                  child: Row(
                    children: [
                      Text("Test"),
                      Text("Test")
                    ],
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