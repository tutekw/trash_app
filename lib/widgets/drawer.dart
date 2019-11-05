import 'package:flutter/material.dart';

import '../screens/auth.dart';

Widget sideDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: <Widget>[
        AppBar(
          titleSpacing: 20.0,
          automaticallyImplyLeading: false,
          title: Text(
            'reAppka',
            style: Theme.of(context).textTheme.title,
          ),
          leading: Icon(
            Icons.pin_drop,
            size: 70.0,
          ),
        ),
        Container(
          height: 160.0,
        ),
        ListTile(
          contentPadding: EdgeInsets.all(10.0),
          leading: Icon(Icons.map),
          title: Text(
            'Mapa',
            style: Theme.of(context).textTheme.display1,
          ),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(10.0),
          leading: Icon(Icons.lightbulb_outline),
          title: Text(
            'Manifesto',
            style: Theme.of(context).textTheme.display1,
          ),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/why');
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(10.0),
          leading: Icon(Icons.library_books),
          title: Text(
            'Podręcznik recykilngu',
            style: Theme.of(context).textTheme.display1,
          ),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/details');
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(10.0),
          leading: Icon(Icons.supervised_user_circle),
          title: Text(
            'Zaloguj',
            style: Theme.of(context).textTheme.display1,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AuthPage()),
            );
          },
        ),
      ],
    ),
  );
}
