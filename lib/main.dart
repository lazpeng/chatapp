import 'package:flutter/material.dart';

import 'ui/main/MainPage.dart';

void main() => runApp(Application());

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatApp',
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.deepPurpleAccent),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.deepPurpleAccent
      ),
      home: MainPage(),
    );
  }
}
