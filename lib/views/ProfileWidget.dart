import 'package:chatapp/SessionSettings.dart';
import 'package:chatapp/domain/AccountDomain.dart';
import 'package:chatapp/models/UserModel.dart';
import 'package:flutter/material.dart';

class _ProfileInfo {
  UserModel target;
  bool isCurrentUser;

  static Future<_ProfileInfo> load(String id) async {
    var current = await accountDomain.getCurrentUser();

    var target;
    if(id == null) {
      target = current;
    } else {
      target = await accountDomain.getUser(id);
    }

    var info = new _ProfileInfo();
    info.isCurrentUser = current.id == target.id;
    info.target = target;

    return info;
  }
}

class ProfileWidget {
  String _targetId;

  ProfileWidget(String id) {
    _targetId = id;
  }

  Widget build(BuildContext context, Function callback) {
    return FutureBuilder(
      future: _ProfileInfo.load(_targetId),
      builder: (context, AsyncSnapshot<_ProfileInfo> bundle) {
        if(bundle.hasData) {
          var info = bundle.data;
          return Material(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Column(
              children: [
                const SizedBox(height: 50),
                Text(info.target.fullName, style: Theme.of(context).textTheme.headline6),
                info.isCurrentUser ? Column(
                  children: [
                    RaisedButton(child: Text("Edit profile"), onPressed: () {
                      SessionSettings.logout().then((_) {
                        callback();
                      });
                    }),
                    RaisedButton(child: Text("Logout"), onPressed: () {
                      SessionSettings.logout().then((_) {
                        callback();
                      });
                    }),
                  ]
                ) : SizedBox.shrink()
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            )
          ])
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}