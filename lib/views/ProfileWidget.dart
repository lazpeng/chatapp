import 'package:chatapp/SessionSettings.dart';
import 'package:flutter/material.dart';

class ProfileWidget {
  static Widget build(BuildContext context, Function callback) {
    return Material(
      child: Center(child: RaisedButton(child: Text("Logout"), onPressed: () {
        SessionSettings.logout().then((_) {
          callback();
        });
      })),
    );
  }
}