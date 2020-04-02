import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/services/UserService.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  final String _userId;
  final bool _fromSettings;

  ProfileView(this._userId, this._fromSettings);

  @override
  State<StatefulWidget> createState() => _ProfileViewState(_userId, _fromSettings);
}

class _ProfileViewState extends State<ProfileView> {
  String _userId;
  bool _fromSettings = false;
  bool _isCurrentUser = false;
  bool _loading = true;
  UserModel _target;

  final UserService _userService = UserService();

  _ProfileViewState(this._userId, this._fromSettings);

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      var currentUser = await _userService.getCurrentUser();

      if(currentUser.id == _userId || _userId == null) {
        _isCurrentUser = true;
        _target = currentUser;
      } else {
        _target = await _userService.getUser(_userId);
      }

      setState(() {

        _loading = false;
      });
    });
  }

  Widget _userInfo(String desc, String value) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text("$desc: ", style: Theme.of(context).textTheme.subtitle),
          Text(value)
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_loading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            CircleAvatar(
              child: Text(_target.username.substring(0, 1), style: Theme.of(context).textTheme.display2),
              radius: 50,
            ),
            
            const SizedBox(height: 15),
            Text(_target.username, style: Theme.of(context).textTheme.headline),
            const SizedBox(height: 25),
            
            _userInfo("Name", _target.fullName),
            _userInfo("Email", _target.email),
            _userInfo("Join date", _target.accountCreated.toIso8601String()),

            _isCurrentUser ? Column(
              children: [
                const SizedBox(height: 75),
                SizedBox(
                  width: 200,
                  height: 45,
                  child: RaisedButton(
                    child: Text("Edit"),
                    onPressed: () {

                    },
                    padding: EdgeInsets.all(10)
                  )
                ),
                const SizedBox(height: 15),
                _fromSettings ?
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: RaisedButton(
                      child: Text("Logout"),
                      onPressed: () {

                      },
                      padding: EdgeInsets.all(10)
                    ),
                  )
                : const SizedBox()
              ]
            ) : SizedBox(
              width: 200,
              height: 45,
              child: RaisedButton(
                child: Text("Send friend request"),
                onPressed: () {

                },
              )
            )
          ]
        )
      );
    }
  }
}