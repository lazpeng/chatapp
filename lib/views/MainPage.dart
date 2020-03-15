import 'package:chatapp/SessionSettings.dart';
import 'package:flutter/material.dart';

import 'LoginPage.dart';

class MainPage extends StatefulWidget {
  @override
  createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SessionSettings>(
      future: SessionSettings.load(),
      builder: (context, AsyncSnapshot<SessionSettings> settings) {
        if(settings.hasData) {
          if(settings.data.sessionToken == "") {
            Future.microtask(() => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage())
            ));
            return Text("");
          } else {
            return Scaffold(

            );
          }
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
                child: CircularProgressIndicator()
            )
          );
        }
      },
    );
  }
}