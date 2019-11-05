import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import '../widgets/drawer.dart';
import '../widgets/drawer_logout.dart';

class DetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DetailsPageState();
  }
}

class _DetailsPageState extends State<DetailsPage> {
  String token;

  void _isUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  @override
  void initState() {
    _isUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: token == null ? sideDrawer(context) : sideDrawerLogout(context),
        appBar: AppBar(
          leading: new Builder(
            builder: (context) {
              return new IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu),
                iconSize: 32.0,
                color: Colors.white,
              );
            },
          ),
          title: Text('Podręcznik recyklingu'),
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 32.0,
          ),
        ),
        body: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(0.0),
              sliver: SliverGrid.count(
                crossAxisSpacing: 0.0,
                crossAxisCount: 2,
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('lib/assets/plasticbottles.jpg'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 200,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.indigo, Colors.cyan],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Plastik PET',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('lib/assets/alucans.jpg'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 200,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.indigo, Colors.cyan],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Aluminium',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('lib/assets/cardboard.jpg'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 200,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.indigo, Colors.cyan],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Karton',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('lib/assets/glass.jpg'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 200,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.indigo, Colors.cyan],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Szkło',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('lib/assets/batteries.jpg'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 200,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.indigo, Colors.cyan],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Baterie',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Center(
                      child: const Text('Papier'),
                    ),
                  ),
                  Card(
                    child: Center(
                      child: const Text('Papier'),
                    ),
                  ),
                  Card(
                    child: Center(
                      child: const Text('Papier'),
                    ),
                  ),
                  Card(
                    child: Center(
                      child: const Text('Papier'),
                    ),
                  ),
                  Card(
                    child: Center(
                      child: const Text('Papier'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
