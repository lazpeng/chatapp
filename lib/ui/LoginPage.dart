import 'package:chatapp/models/requests/LoginRequest.dart';
import 'package:chatapp/services/UserService.dart';
import 'package:chatapp/ui/RegisterPage.dart';
import 'package:flutter/material.dart';

import 'MainPage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = "";
  String _password = "";
  bool _appearOffline = false;
  final UserService _userService = new UserService();

  var duringLogin = false;

  bool isLoginEnabled() {
    return _username.trim().length != 0 && _password.trim().length != 0;
  }

  @override
  Widget build(BuildContext context) {
    if (duringLogin) {
      return Material(
        child: Padding(
          padding: EdgeInsets.only(top: 200),
          child: Column(
            children: [
              Text("Logging in...", style: Theme.of(context).textTheme.subtitle),
              const SizedBox(height: 30),
              CircularProgressIndicator()
            ],
          )
        )
      );
    } else {
      return Material(
          child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Text("Login", style: Theme.of(context).textTheme.headline),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 75),
                    child: TextFormField(
                        decoration: InputDecoration(icon: Icon(Icons.person), hintText: "Username"),
                        initialValue: _username,
                        onChanged: (text) {
                          _username = text.trim();
                          setState(() {});
                        }
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 15),
                    child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock), hintText: "Password"),
                        obscureText: true,
                        initialValue: _password,
                        onChanged: (text) {
                          _password = text;
                          setState(() {});
                        }
                    )
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      Checkbox(value: _appearOffline, activeColor: Theme.of(context).accentColor, onChanged: (value) {
                        _appearOffline = value;
                        setState(() {});
                      }),
                      Text("Appear offline", style: Theme.of(context).textTheme.body2)
                    ],
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                      width: 350,
                      height: 45,
                      child: RaisedButton(
                        child: Text("Login"),
                        padding: const EdgeInsets.all(10),
                        onPressed: isLoginEnabled()
                            ? () {
                                setState(() {
                                  duringLogin = true;

                                  var loginRequest = new LoginRequest();
                                  loginRequest.username = _username;
                                  loginRequest.password = _password;
                                  loginRequest.appearOffline = _appearOffline;

                                  _userService.performLogin(loginRequest).then((message) {
                                    if(message.isEmpty) {
                                      // Login was a success
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));

                                      return null;
                                    } else {
                                      setState(() {
                                          duringLogin = false;
                                        });

                                      return showDialog(context: context, builder: (_) {
                                        return AlertDialog(
                                          title: Text("Login", style: Theme.of(context).textTheme.subtitle),
                                          content: Text("An error ocurred during login: $message")
                                        );
                                      });
                                    }
                                  });
                                });
                              }
                            : null,
                      )),
                  const SizedBox(height: 15),
                  SizedBox(
                      width: 350,
                      height: 45,
                      child: RaisedButton(
                        child: Text("Register an account"),
                        padding: const EdgeInsets.all(10),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                        },
                      )),
                ],
          )));
    }
  }
}
