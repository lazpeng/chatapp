import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatApp - Login")
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Username"
              ),
            )
          ],
        ),
      )
    );
  }
}