
//google maps api key: AIzaSyCSwG6hqe3Jf8B7GPVAoMR6ocCBwkEV5Ag

import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:trash_safari/screens/auth.dart';
import 'package:trash_safari/screens/closest.dart';
import 'package:trash_safari/screens/picker.dart';

import './screens/why.dart';
import './screens/home.dart';
import './screens/details.dart';

import './scoped_model/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          routes: {
            '/auth': (BuildContext context) => AuthPage(),
            '/': (BuildContext context) => HomePage(
                  title: 'Mapa',
                  model: _model,
                ),
            '/details': (BuildContext context) => DetailsPage(),
            '/why': (BuildContext context) => WhyPage(),
            '/picker': (BuildContext context) => PickerPage(_model, 0, 0, null),
            '/closest': (BuildContext context) => ClosestPage(),
          },
          title: 'uber clone',
          theme: ThemeData(
            secondaryHeaderColor: Colors.white10,
            primarySwatch: Colors.blue,
            accentColor: Colors.red,
        
            textTheme: TextTheme(
              headline: TextStyle(
                color: Colors.black,
                fontFamily: 'Signika',
                fontSize: 24.0,
              ),
              title: TextStyle(
                  fontSize: 45.0, fontFamily: 'Signika', color: Colors.white),
              display1: TextStyle(
                fontFamily: 'Signika',
                color: Colors.black87,
                fontSize: 20.0,
              ),
              display2: TextStyle(
                fontFamily: 'Signika',
                color: Colors.black,
                fontSize: 18.0,
              ),
              display3: TextStyle(
                fontFamily: 'Signika',
                color: Colors.black,
                fontSize: 50.0,
              ),
            ),
          ),
          onGenerateRoute: (RouteSettings settings) {
            if (!_isAuthenticated) {
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => AuthPage(),
              );
            }
          },
        ));
  }
}
