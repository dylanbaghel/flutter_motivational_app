import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

import './quotes_list.dart';

class QuotesApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _QuotesAppState();
  }
}

class _QuotesAppState extends State<QuotesApp> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  List _quotes = [];

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {});
      }
    });
  }

  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<Null> _refreshQuotes() async {
    List quotes = await getQuotes();
    setState(() {
      _quotes = quotes;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print(_connectionStatus);
    return new Scaffold(
        body: new RefreshIndicator(
            onRefresh: _refreshQuotes,
            child: new SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: new FutureBuilder(
              future: getQuotes(),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  List quoteList = _quotes.isEmpty ? snapshot.data : _quotes;
                  return new Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                            image: new AssetImage('assets/images/motbg.png'),
                            fit: BoxFit.cover)),
                    child: new QuotesList(
                      quotes: quoteList,
                    ),
                  );
                } else {
                  return new Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment(0.0, 0.0),
                    child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new CircularProgressIndicator(),
                          new Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: new Text(
                                _connectionStatus ==
                                        ConnectivityResult.none.toString()
                                    ? 'No Internet'
                                    : 'Fetching Quotes',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ))
                        ]),
                  );
                }
              },
            ),
            )));
  }

  Future<List> getQuotes() async {
    String apiUrl =
        "https://raw.githubusercontent.com/dylanbaghel/json_files/master/quotes.json";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }
}
