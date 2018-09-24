import 'package:flutter/material.dart';
import 'dart:async';


class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState() { 
    super.initState();
    startTimer();
  }

   startTimer() async {
    Duration duration = new Duration(seconds: 3);
    return new Timer(duration, () {
      Navigator.of(context).pushReplacementNamed('/QuotesApp');
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      type: MaterialType.transparency,
        child: new Container(
        decoration: new BoxDecoration(
          color: Colors.deepOrange.shade600
        ),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(top: 100.0, bottom: 20.0),
              child: new Image.asset(
                "assets/images/app_icon.png",
                width: 150.0,
                height: 150.0
              )
            ),
            new Text(
              "Quote App",
              style: new TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22.0
              )
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 120.0),
              child: new Text(
                "Read New Motivational Quotes Everyday",
                style: new TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
                )
              )
            ),
            new CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 2.0,
            ),
          ],
        ),
      )
    );
  }
}