import 'package:chatapp/models/FriendRequestModel.dart';
import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/services/SessionService.dart';
import 'package:chatapp/services/UserService.dart';
import 'package:flutter/material.dart';

import 'ProfilePage.dart';
import 'UserRowWidget.dart';

class _PendingRequest {
  UserModel user;
  FriendRequestModel request;
}

class _FriendRequestResult {
  String currentUser;
  List<UserModel> sentRequests = [];
  List<_PendingRequest> pendingRequests = [];
}

class FriendsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  final UserService _userService = UserService();
  final SessionService _sessionService = SessionService();
  bool _searchEnabled = false;
  String _searchUsername = "";
  bool _loading = false;
  List<UserModel> _searchResults;

  @override
  void initState() {
    super.initState();
  }

  Future<_FriendRequestResult> getFriendRequests() async {
    var requests = await _userService.getPendingFriendRequests();
    var current = await _sessionService.getSavedToken();

    var result = new _FriendRequestResult();
    result.currentUser = current.sourceId;

    for(var request in requests) {
      var associated = await _userService.getUser(request.userId);

      if(request.isMine) {
        result.sentRequests.add(associated);
      } else {
        var req = new _PendingRequest();
        req.request = request;
        req.user = associated;

        result.pendingRequests.add(req);
      }
    }

    return result;
  }

  Widget _buildFriendListFragment() {
    return FutureBuilder(
      future: _userService.getFriends(),
      builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
        if(snapshot.hasData) {
          var users = snapshot.data;

          if(users.isEmpty) {
            return Center(
                child: Text("No friends yet")
            );
          } else {
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];

                return UserRowWidget(user);
              },
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  Widget _buildSentRequests(_FriendRequestResult result) {
    if(result.sentRequests.isEmpty) {
      return Center(child: Text("No sent requests"));
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: result.sentRequests.length,
          itemBuilder: (context, index) {
            var item = result.sentRequests[index];

            return UserRowWidget(item);
          },
        )
      );
    }
  }

  void answerFriendRequest(int id, bool answer) {
    Future.microtask(() async {
      await _userService.answerFriendRequest(id, answer);

      await _userService.refreshFriendList();
      await _userService.refreshFriendList();
    }).whenComplete(() {
      setState(() {});
    });
  }

  Widget _buildReceivedRequests(_FriendRequestResult result) {
    if(result.pendingRequests.isEmpty) {
      return Center(child: Text("No pending requests"));
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: result.pendingRequests.length,
          itemBuilder: (context, index) {
            var item = result.pendingRequests[index];

            return UserRowWidget(item.user);
          },
        )
      );
    }
  }

  Widget _buildFriendRequestListFragment() {
    return FutureBuilder(
      future: getFriendRequests(),
      builder: (context, AsyncSnapshot<_FriendRequestResult> snapshot) {
        if(snapshot.hasData) {
          var requests = snapshot.data;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(child: Text("Pending requests", style: Theme.of(context).textTheme.headline)),
              const SizedBox(height: 15),
              _buildReceivedRequests(requests),

              const SizedBox(height: 30),
              
              Center(child: Text("Sent requests", style: Theme.of(context).textTheme.headline)),
              const SizedBox(height: 15),
              _buildSentRequests(requests),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  Widget _buildBlockListFragment() {
    return Center(
        child: Text("No blocked users")
    );
  }

  Widget _buildSearchFragment() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 350,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "username"
                  ),
                  onChanged: (text) {
                    setState(() {
                      _searchEnabled = text.length > 0;
                      _searchUsername = text;
                    });
                  },
                )
              )
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _searchEnabled ? () {
                setState(() {
                  _loading = true;

                  _userService.search(_searchUsername).then((val) {
                    setState(() {
                      _loading = false;
                      _searchResults = val;
                    });
                  });
                });
              } : null,
            )
          ]
        ),
        _loading ? Center(child: CircularProgressIndicator()) :
        _searchResults == null ? const SizedBox() : (
          _searchResults.isEmpty ? Center(child: Text("No users found")) :
          Expanded (
            child: ListView.builder(
              itemCount: _searchResults.length,
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
                var user = _searchResults[index];

                return UserRowWidget(user);
              },
            )
          )
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: "Friends"),
              Tab(text: "Requests"),
              Tab(text: "Blocked"),
              Tab(text: "Search")
            ]
          )
        ),
        body: TabBarView(
          children: [
            _buildFriendListFragment(),
            _buildFriendRequestListFragment(),
            _buildBlockListFragment(),
            _buildSearchFragment()
          ]
        )
      ),
    );
  }
}