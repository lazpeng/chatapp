import 'package:chatapp/SessionSettings.dart';
import 'package:chatapp/models/ChatModel.dart';
import 'package:chatapp/repositories/ChatRepository.dart';
import 'package:chatapp/views/ProfileWidget.dart';
import 'package:flutter/material.dart';

import 'LoginPage.dart';

class MainPage extends StatefulWidget {
  @override
  createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _currentNavIndex = 0;

  Widget _buildChatFragment() {
    return FutureBuilder<List<ChatModel>>(
      future: chatRepository.getActiveChats(),
      builder: (context, AsyncSnapshot<List<ChatModel>> data) {
        if(data.hasData) {
          var chats = data.data;

          if(chats.isEmpty) {
            return Center(child: Text("No active chats yet"));
          } else {
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, int index) {
                var current = chats[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(current.username[0].toUpperCase())),
                  title: Row(
                    children: [
                      Text(current.lastMessage)
                    ],
                  ),
                  subtitle: Text(current.username),
                );
              },
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  Widget _buildFriendsFragment() {
    return Center(child: Text("Friends"));
  }

  Widget _buildCurrentFragment(context) {
    switch(_currentNavIndex) {
      case 1:
        return _buildFriendsFragment();
        break;
      case 2:
        return ProfileWidget.build(context, () {
          setState(() {});
        });
        break;
      case 0:
      default:
        return _buildChatFragment();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SessionSettings>(
      future: SessionSettings.load(),
      builder: (context, AsyncSnapshot<SessionSettings> settings) {
        if(settings.hasData) {
          if(settings.data.sessionToken == "") {
            Future.microtask(() => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage())
            ));
            return Text("");
          } else {
            return Scaffold(
              bottomNavigationBar: BottomNavigationBar(items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  title: Text("Chats")
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  title: Text("Friends")
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  title: Text("Manage")
                )
              ], onTap: (index) {
                setState(() {
                  _currentNavIndex = index;
                });
              }, currentIndex: _currentNavIndex),
              body: _buildCurrentFragment(context),
            );
          }
        } else {
          return Scaffold(
            body: Center(
                child: CircularProgressIndicator()
            )
          );
        }
      },
    );
  }
}