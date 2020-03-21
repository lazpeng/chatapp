import 'package:chatapp/SessionSettings.dart';
import 'package:chatapp/domain/AccountDomain.dart';
import 'package:chatapp/models/ChatModel.dart';
import 'package:chatapp/models/UserModel.dart';
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
  ProfileWidget _profileWidget;

  String _formatSentDate(DateTime t) {
    return "${t.hour}:${t.minute}";
  }

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
                      Text(current.username)
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      current.isMine
                      ? Text(current.lastMessage, overflow: TextOverflow.clip)
                      : Row(
                        children: [
                          Icon(Icons.check),
                          const SizedBox(width: 5),
                          Text(current.lastMessage, overflow: TextOverflow.clip),
                        ],
                      ),
                      Text(_formatSentDate(current.lastSentDate))
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
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

  Widget _buildFriendListFragment() {
    return FutureBuilder(
      future: accountDomain.getFriendList(),
      builder: (context, AsyncSnapshot<List<UserModel>> bundle) {
        if(bundle.hasData) {
          var friends = bundle.data;

          if(friends.length == 0) {
            return Center(
              child: Column(
                children: [
                  Text("No friends yet"),
                  const SizedBox(height: 10),
                  RaisedButton(child: Text("Send a friend request"), onPressed: () {},)
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )
            );
          } else {
            return null;
          }
        } else {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      }
    );
  }

  Widget _buildFriendsFragment() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: "Friend list"),
              Tab(text: "Pending"),
              Tab(text: "Block list")
            ]
          )
        ),
        body: TabBarView(
          children: [
            _buildFriendListFragment(),
            Text("No pending requests"),
            Text("No blocked users")
          ]
        )
      ),
    );
  }

  Widget _buildCurrentFragment(context) {
    switch(_currentNavIndex) {
      case 1:
        return _buildFriendsFragment();
        break;
      case 2:
        if(_profileWidget == null) {
          _profileWidget = new ProfileWidget(null);
        }
        return _profileWidget.build(context, () {
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