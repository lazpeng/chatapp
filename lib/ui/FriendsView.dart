import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/services/UserService.dart';
import 'package:flutter/material.dart';

import 'ProfilePage.dart';

class FriendsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  final UserService _userService = UserService();
  bool _searchEnabled = false;
  String _searchUsername = "";
  bool _loading = false;
  List<UserModel> _searchResults;

  @override
  void initState() {
    super.initState();
  }

    Widget _buildFriendListFragment() {
    return Center(
      child: Text("No friends yet")
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

                return Card(
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(user.username.substring(0, 1).toUpperCase()),
                    ),
                    title: Text(user.username),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProfilePage(user.id),
                        )
                      );
                    },
                  )
                );
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