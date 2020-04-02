import 'package:chatapp/models/requests/CheckRequest.dart';
import 'package:chatapp/services/SessionService.dart';
import 'package:chatapp/ui/ChatsView.dart';
import 'package:flutter/material.dart';

import 'LoginPage.dart';

class MainPage extends StatefulWidget {
  @override
  createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentNavIndex = 0;
  SessionService _sessionService = new SessionService();

  Widget _buildFriendListFragment() {
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
  }

  Widget _buildFriendRequestListFragment() {
    return Center(
        child: Text("No pending requests")
    );
  }

  Widget _buildBlockListFragment() {
    return Center(
        child: Text("No blocked users")
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
            _buildFriendRequestListFragment(),
            _buildBlockListFragment()
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
        return Center(
          child: Text("<User Profile>")
        );
        break;
      case 0:
      default:
        return new ChatsView();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CheckRequest>(
      future: _sessionService.getSavedToken(),
      builder: (context, AsyncSnapshot<CheckRequest> settings) {
        if(settings.hasData) {
          if(settings.data.token == "" || settings.data.token == null) {
            Future.microtask(() => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage())
            ));
            return Text("");
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("Active chats"),
                actions: [
                  IconButton(icon: Icon(Icons.refresh), onPressed: () {
                    
                  })
                ]
              ),
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