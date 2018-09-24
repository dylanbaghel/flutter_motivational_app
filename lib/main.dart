import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './ui/quotes_app.dart';
import './ui/splash_screen.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
        runApp(
          new MaterialApp(
            title: "Quotes",
            home: new SplashScreen(),
            routes: <String, WidgetBuilder> {
              '/QuotesApp': (BuildContext context) => new QuotesApp()
            },
          )
        );
    });
}
