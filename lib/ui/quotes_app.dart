import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
      } else if (result == ConnectivityResult.none) {
        _readData();
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

  Future<String> _localPath() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } catch (e) {
      _refreshQuotes();
    }
  }

  Future<File> _localFile() async {
    try {
      final String path = await _localPath();
      return new File("$path/qt.txt");
    } catch(e) {
      _refreshQuotes();
    }
  }

  Future<void> _writeData(List data) async {
    try {
      final File file = await _localFile();
      file.writeAsString(json.encode(data));
    } catch(e) {
      _refreshQuotes();
    }
  }

  Future<void> _readData() async {
    try {
      final File file = await _localFile();
      String data = await file.readAsString();
      setState(() {
        if (data != null && data != "") {
          _quotes = json.decode(data);
        } else {
          _refreshQuotes();
        }
      });
    } catch (e) {
      _refreshQuotes();
    }
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
                  _writeData(snapshot.data);
                  List quoteList = _quotes.isEmpty ? snapshot.data : _quotes;
                  return getQuoteContainer(quoteList);
                }  else {
                    if (_quotes.isNotEmpty) {
                      return getQuoteContainer(_quotes);
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
                }
              },
            ),
            )));
  }

  Widget getQuoteContainer(List quotes) {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage('assets/images/road.png'),
              fit: BoxFit.cover)),
      child: new QuotesList(
        quotes: quotes,
      ),
    );
  }

  Future<List> getQuotes() async {
    String apiUrl =
        "https://raw.githubusercontent.com/dylanbaghel/json_files/master/quotes.json";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }
}
