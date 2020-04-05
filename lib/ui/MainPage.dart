import 'package:chatapp/models/requests/CheckRequest.dart';
import 'package:chatapp/services/SessionService.dart';
import 'package:chatapp/services/UserService.dart';
import 'package:chatapp/ui/ChatsView.dart';
import 'package:chatapp/ui/FriendsView.dart';
import 'package:flutter/material.dart';

import 'LoginPage.dart';
import 'ProfileView.dart';

class MainPage extends StatefulWidget {
  @override
  createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentNavIndex = 0;
  SessionService _sessionService = new SessionService();
  UserService _userService = new UserService();

  Widget _buildCurrentFragment(context) {
    return [ChatsView(), FriendsView(), ProfileView(null, true)][_currentNavIndex];
  }

  String _getCurrentAppTitle() {
    return ["Active chats", "Social", "Profile"][_currentNavIndex];
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
                title: Text(_getCurrentAppTitle()),
                actions: [
                  IconButton(icon: Icon(Icons.refresh), onPressed: () {
                    _userService.refreshAll().catchError((err) {
                      print(err);
                    });
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
                  title: Text("Social")
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