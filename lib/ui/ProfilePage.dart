
import 'package:flutter/material.dart';

import 'ProfileView.dart';

class ProfilePage extends StatelessWidget {
  final String _userId;

  ProfilePage(this._userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User profile")
      ),
      body: ProfileView(_userId, false)
    );
  }
}