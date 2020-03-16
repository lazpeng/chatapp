import 'package:chatapp/services/AccountService.dart';
import 'package:chatapp/views/RegisterPage.dart';
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
              Text("Logging in...", style: Theme.of(context).textTheme.headline6),
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
                  Text("Login", style: Theme.of(context).textTheme.headline3),
                  const SizedBox(height: 75),
                  TextFormField(
                    decoration: InputDecoration(icon: Icon(Icons.person), hintText: "Username"),
                    initialValue: _username,
                    onChanged: (text) {
                      _username = text.trim();
                      setState(() {});
                    }
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock), hintText: "Password"),
                    obscureText: true,
                    initialValue: _password,
                    onChanged: (text) {
                      _password = text;
                      setState(() {});
                    }
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      Checkbox(value: _appearOffline, activeColor: Theme.of(context).accentColor, onChanged: (value) {
                        _appearOffline = value;
                        setState(() {});
                      }),
                      Text("Appear offline", style: Theme.of(context).textTheme.bodyText2)
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

                                  accountService.performLogin(_username, _password, false).then((message) {
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
                                          title: Text("Login", style: Theme.of(context).textTheme.headline6),
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
