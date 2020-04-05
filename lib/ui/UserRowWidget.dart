import 'package:chatapp/models/UserModel.dart';
import 'package:flutter/material.dart';

import 'ProfilePage.dart';

class UserRowWidget extends StatelessWidget {
  final UserModel _user;

  UserRowWidget(this._user);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(_user.username.substring(0, 1).toUpperCase()),
        ),
        title: Text(_user.username),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ProfilePage(_user.id),
            )
          );
        },
      )
    );
  }
}