import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import './pages/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './routes/routers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  String firstPagePath = "/";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyIndex(0),
      // initialRoute: '/settings',
      initialRoute: this.firstPagePath,
      onGenerateRoute: onGenerateRoute(),
      navigatorObservers: [routeObserver],
    ));
  }
}
