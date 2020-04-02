import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/services/UserService.dart';
import 'package:chatapp/ui/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _username = "";
  String _password = "";
  String _email = "";
  String _fullName = "";
  bool _findInSearch = true;
  bool _allowMessagesFromEveryone = true;
  DateTime _dateOfBirth = DateTime.now();

  final UserService _userService = new UserService();

  bool _loading = false;

  String formatDob() {
    return new DateFormat.yMMMd().format(_dateOfBirth);
  }

  bool empty(List<String> values) {
    bool empty = false;
    for(var c in values) {
      if(c.trim().length == 0) {
        empty = true;
        break;
      }
    }
    return empty;
  }

  bool allRequiredInfoOk() {
    return !empty([_username, _email, _password]);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Material(
        child: Padding(
          padding: EdgeInsets.only(top: 200),
          child: Column(
            children: [
              Text("Creating account...", style: Theme.of(context).textTheme.display1),
              const SizedBox(height: 30),
              CircularProgressIndicator()
            ],
          )
        )
      );
    }

    return Material(
      child: SingleChildScrollView(
        child: Center(
            child: SizedBox(
                width: 350,
                child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Text("Register", style: Theme.of(context).textTheme.headline),
                      const SizedBox(height: 40),
                      TextFormField(decoration: InputDecoration(labelText: "Username"), initialValue: _username, onChanged: (text) {
                        _username = text.trim();

                        setState(() {});
                      }),
                      TextFormField(decoration: InputDecoration(labelText: "Full name (optional)"), initialValue: _fullName, onChanged: (text) {
                        _fullName = text.trim();
                      }),
                      TextFormField(decoration: InputDecoration(labelText: "Email"), initialValue: _email, onChanged: (text) {
                        _email = text.trim();

                        setState(() {});
                      }),
                      TextFormField(decoration: InputDecoration(labelText: "Password"), initialValue: _password, obscureText: true, onChanged: (text) {
                        _password = text;

                        setState(() {});
                      }),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text("Find in search"),
                          Checkbox(value: _findInSearch, activeColor: Theme.of(context).accentColor, onChanged: (value) {
                            _findInSearch = value;
                            setState(() {});
                          })
                        ]
                      ),
                      Row(
                        children: [
                          Text("Allow messages from everyone"),
                          Checkbox(value: _allowMessagesFromEveryone, activeColor: Theme.of(context).accentColor, onChanged: (value) {
                            _allowMessagesFromEveryone = value;
                            setState(() {});
                          })
                        ]
                      ),
                      Row(
                        children: [
                          Text("Date of birth"),
                          const SizedBox(width: 20),
                          SizedBox(width: 175, child: RaisedButton(child: Text("${formatDob()}"), onPressed: () {
                            showDatePicker(context: context, initialDate: _dateOfBirth, 
                                            firstDate: DateTime.fromMillisecondsSinceEpoch(0), 
                                            lastDate: DateTime.now()).then((selected) {
                              setState(() {
                                _dateOfBirth = selected;
                              });
                            });
                          }))
                        ]
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: 350,
                        child: RaisedButton(
                          child: Text("Create"),
                          onPressed: allRequiredInfoOk() ? () {
                            setState(() {
                              var user = new UserModel();
                              user.username = _username;
                              user.password = _password;
                              user.fullName = _fullName;
                              user.dateOfBirth = _dateOfBirth;
                              user.email = _email;
                              user.findInSearch = _findInSearch;
                              user.openChat = _allowMessagesFromEveryone;

                              _loading = true;

                              _userService.register(user).then((message) {
                                setState(() { _loading = false; });

                                if(message == "") {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
                                  return null;
                                } else {
                                  return showDialog(context: context, builder: (_) {
                                    return AlertDialog(
                                      title: Text("Login", style: Theme.of(context).textTheme.headline),
                                      content: Text("An error ocurred during account creation: $message")
                                    );
                                  });
                                }
                              });
                            });
                          } : null,
                        )
                      )
                    ]
                )
            )
        )
      )
    );
  }
}