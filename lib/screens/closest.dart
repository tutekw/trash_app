import 'package:flutter/material.dart';
import 'dart:math';

import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:location/location.dart' as geoloc;

import '../widgets/drawer.dart';
import '../widgets/drawer_logout.dart';

class ClosestPage extends StatefulWidget {
  final userLocation;

  ClosestPage({this.userLocation});

  @override
  State<StatefulWidget> createState() {
    return _ClosestPageState();
  }
}

class _ClosestPageState extends State<ClosestPage> {
  String token;
  dynamic currentLocation;

  @override
  void initState() {
    _getUserLocation();
    super.initState();
  }

  void _getUserLocation() async {
    final location = geoloc.Location();
    currentLocation = await location.getLocation();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: token == null ? sideDrawer(context) : sideDrawerLogout(context),
      appBar: GradientAppBar(
        backgroundColorStart: Colors.indigo,
        backgroundColorEnd: Colors.cyanAccent,
        title: Text('Najblizej mnie'),
      ),
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10.0,
              crossAxisCount: 1,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(7.5),
                      ),
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
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(7.5),
                              bottomRight: Radius.circular(7.5)),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
