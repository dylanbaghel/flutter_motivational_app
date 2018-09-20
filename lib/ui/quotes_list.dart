import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class QuotesList extends StatelessWidget {
  List quotes;
  MediaQueryData mediaQueryData;

  QuotesList({ Key key, this.quotes }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    print(mediaQueryData.devicePixelRatio);
    return new PageView.builder(
      controller: PageController(
        initialPage: 0,
      ),
      itemCount: quotes.length,
      itemBuilder: (BuildContext context, int position) {
        return new Center(
            child: new Container(
              width: mediaQueryData.size.width / 1.1,
              height: mediaQueryData.size.height / 1.5,
              child: new InkWell(
                splashColor: Colors.white,
                child: new Card(
                  color: getRandomColor(),
                  elevation: 15.0,
                  child: new Padding(
                    padding: EdgeInsets.all(10.0),
                    child: new Center(
                      child: new Wrap(
                        spacing: 4.0,
                        runSpacing: 1.0,
                        children: <Widget>[
                          new Text(
                            quotes[position]['quote'],
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontFamily: 'PermanentMarker',                                
                            ),
                            textAlign: TextAlign.center,
                          ),
                          new Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(top: 5.0),
                            child: new Chip(
                              label: new Text(
                              "- ${quotes[position]['name']}",
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontFamily: 'IndieFlower',
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                onLongPress: () => this.showQuoteAlert(context, quotes[position]['quote'], quotes[position]['name']),
                onTap: () {
                  Scaffold.of(context).showSnackBar(
                    new SnackBar(
                      content: new Text(
                        "Tap Copy To Copy Quote"
                        ),
                        duration: new Duration(milliseconds: 5000),
                        action: new SnackBarAction(
                          label: 'Copy',
                          onPressed: () {
                            Clipboard.setData(new ClipboardData(text: quotes[position]['quote']));
                          }
                        ),
                      ),
                  );
                },
              )
            )
        );
      },
    );
  }

  void showQuoteAlert(BuildContext context, String quote, String name) {
    AlertDialog alertDialog = new AlertDialog(
      title: new Text(
        name
      ),
      content: new ListTile(
        title: new Text(
          quote,
          style: new TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          ),
        ),
        subtitle: new Container(
          child: new Text(
            "- $name",
            style: new TextStyle(
              color: Colors.blueGrey,
              fontSize: 15.0,
              fontStyle: FontStyle.italic
            ),

          ),
        ),
      ),
      actions: <Widget>[
        new RaisedButton(
          child: new Text("Ok"),
          color: Colors.deepPurple,
          textColor: Colors.white,
          elevation: 5.0,
          highlightElevation: 15.0,
          onPressed: () {
                  Navigator.pop(context);
                },
        )
      ],
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }

  static Color getRandomColor() {
    List<String> hex = ['0', '1', '2', '3', '4', '5', '6', '7', '8' '9', 'A', 'B', 'C', 'D', 'E', 'F'];
     String color = "0xaf";

     for (int i = 1; i <= 6; i++) {
       color += hex[Random().nextInt(hex.length)];
     }

     return Color(int.parse(color));
  }

}