import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/services/SessionService.dart';
import 'package:chatapp/services/UserService.dart';
import 'package:chatapp/ui/LoginPage.dart';
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
  bool _isFriend = false;
  bool _hasPendingRequest = false;
  bool _hasSentRequest = false;
  bool _loading = true;
  UserModel _target;

  final UserService _userService = UserService();
  final SessionService _sessionService = SessionService();

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
        _hasPendingRequest = await _userService.hasPendingRequestFrom(_userId);
        _hasSentRequest = await _userService.hasPendingRequestTo(_userId);
        _isFriend = await _userService.isFriendsWith(_userId);
      }

      setState(() {
        _loading = false;
      });
    });
  }

  Widget _getButtons() {
    List<Widget> buttons = [];

    if(_isCurrentUser) {
      buttons.add(SizedBox(
        width: 200,
        height: 45,
        child: RaisedButton(
          child: Text("Edit"),
          onPressed: () {

          },
          padding: EdgeInsets.all(10)
        )
      ));

      buttons.add(const SizedBox(height: 15));

      if(_fromSettings) {
        buttons.add(SizedBox(
          width: 200,
          height: 45,
          child: RaisedButton(
            child: Text("Logout"),
            onPressed: () {
              Future.microtask(() async {
                await _sessionService.logout();
                
                await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              });
            },
            padding: EdgeInsets.all(10)
          ),
        ));

        buttons.add(const SizedBox(height: 15));
      }
    } else {
      if(_isFriend) {
        buttons.add(SizedBox(
          width: 200,
          height: 45,
          child: RaisedButton(
            child: Text("Remove friend"), onPressed: () {

            })
          )
        );
        
        buttons.add(const SizedBox(height: 15));
      } else if(_hasSentRequest) {
        buttons.add(SizedBox(
          width: 200,
          height: 45,
          child: RaisedButton(
            child: Text("Cancel friend request"), onPressed: () {

            })
          )
        );
        
        buttons.add(const SizedBox(height: 15));
      } else if(_hasPendingRequest) {
        buttons.add(Text("Pending friend request"));
        
        buttons.add(const SizedBox(height: 15));

        buttons.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 45,
              child: RaisedButton(
                child: Text("Accept"),
                color: Colors.green,
                onPressed: () {
                  Future.microtask(() async {
                    var requests = await _userService.getPendingFriendRequests();

                    var request = requests.firstWhere((e) {
                      return e.userId == _userId;
                    });

                    if(request != null) {
                      await _userService.answerFriendRequest(request.id, true);
                      await _userService.refreshFriendList();
                      await _userService.refreshRequests();
                    }
                  }).whenComplete(() {
                    setState(() {});
                  });
                },
              )
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: 100,
              height: 45,
              child: RaisedButton(
                child: Text("Reject"),
                color: Colors.red,
                onPressed: () {
                  Future.microtask(() async {
                    var requests = await _userService.getPendingFriendRequests();

                    var request = requests.firstWhere((e) {
                      return e.userId == _userId;
                    });

                    if(request != null) {
                      await _userService.answerFriendRequest(request.id, false);
                      await _userService.refreshFriendList();
                      await _userService.refreshRequests();
                    }
                  }).whenComplete(() {
                    setState(() {});
                  });
                },
              )
            )
          ]
        ));
        
        buttons.add(const SizedBox(height: 15));
      } else {
        buttons.add(SizedBox(
          width: 200,
          height: 45,
          child: RaisedButton(
            child: Text("Send friend request"),
            onPressed: () {
              Future.microtask(() async {
                await _userService.sendFriendRequest(_userId);
                await _userService.refreshRequests();
              }).whenComplete(() {
                setState(() {});
              });
            },
          )
        ));
        
        buttons.add(const SizedBox(height: 15));
      }

      buttons.add(SizedBox(
          width: 200,
          height: 45,
          child: RaisedButton(
            child: Text("Send a message"),
            onPressed: () {

            },
          )
      ));

      buttons.add(const SizedBox(height: 15));
    }

    return Column(
      children: buttons
    );
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
            _userInfo("Join date", _target.accountCreated != null ? _target.accountCreated.toIso8601String(): ""),

            const SizedBox(height: 50),
            _getButtons()
          ]
        )
      );
    }
  }
}