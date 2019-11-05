import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as geoloc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:trash_safari/screens/picker.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../scoped_model/main.dart';
import '../widgets/drawer.dart';
import '../widgets/drawer_logout.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.model}) : super(key: key);
  final String title;
  final MainModel model;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controllerMaps = Completer();
  int _angle = 90;
  bool _isRotated = true;
  double centerLati;
  double centerLngi;
  String _mapStyle;
  

  AnimationController _controller;
  Animation<double> _animation;
  Animation<double> _animation2;
  Animation<double> _animation3;

  void _rotate() {
    setState(() {
      if (_isRotated) {
        _angle = 45;
        _isRotated = false;
        _controller.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _controller.reverse();
      }
    });
  }

  void _onAddMarkerpressed(BuildContext context, String typeof) {
    _updateLocation(centerLati, centerLngi);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PickerPage(widget.model, centerLati, centerLngi, typeof)),
    );
  }

  @override
  void initState() {
    widget.model.autoAuthenticate();
    token = null;
    _isUser();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _animation = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );

    _animation2 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.5, 1.0, curve: Curves.linear),
    );

    _animation3 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.8, 1.0, curve: Curves.linear),
    );
    _controller.reverse();

    _getUserLocation();
    rootBundle.loadString('lib/assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  var location = new geoloc.Location();
  Map<String, double> userLocation;
  static LatLng latLngCamera;
  String latlng = '';
  String token;
  bool _isLoading = false;

  void _getUserLocation() async {
    final location = geoloc.Location();
    final currentLocation = await location.getLocation();
    _updateLocation(currentLocation.latitude, currentLocation.longitude);
    latLngCamera =
        new LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  Future<void> _updateLocation(double lat, double lng) async {
    _isLoading = true;
    final GoogleMapController controller = await _controllerMaps.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng),
      zoom: 14,
    )));
    _isLoading = false;
  }

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51, 14),
    zoom: 14.4746,
  );

  void _isUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  void _condShow() {
    if (token != null) {
      _rotate();
    } else {
      return _showDialog(context);
    }
  }

  _getCenterPoint(double lati, double lngi) {
    centerLati = lati;
    centerLngi = lngi;
  }

  _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Zaloguj się aby dodawać punkty",
            style: Theme.of(context).textTheme.display2,
          ),
          actions: <Widget>[
            new IconButton(
              splashColor: Colors.red,
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuToggleButton() {
    return Container(
      margin: EdgeInsets.only(top: 45.0, left: 10.0),
      child: new Builder(
        builder: (context) {
          return new IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
            iconSize: 36.0,
            color: Colors.black,
          );
        },
      ),
    );
  }

  Widget _buildUserLocationButton() {
    return Container(
      margin: EdgeInsets.only(top: 85.0),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: _getUserLocation,
          icon: Icon(Icons.my_location),
          iconSize: 36.0,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: token == null ? sideDrawer(context) : sideDrawerLogout(context),
      body: Stack(
        children: <Widget>[
          ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
              return widget.model.isLoading && false
                  ? Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      myLocationButtonEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        _controllerMaps.complete(controller);
                        controller.setMapStyle(_mapStyle);
                        _getUserLocation();
                        model.fetchPoints(context);
                        setState(() {});
                      },
                      onCameraMove: (object) => _getCenterPoint(
                            object.target.latitude,
                            object.target.longitude,
                          ),
                      initialCameraPosition: _kGooglePlex,
                      markers: model.renderedMarkers,
                    );
            },
          ),
          _buildUserLocationButton(),
          _buildMenuToggleButton(),
          new Positioned(
            bottom: 200.0,
            right: 24.0,
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new ScaleTransition(
                    scale: _animation3,
                    alignment: FractionalOffset.center,
                    child: new Container(
                      margin: new EdgeInsets.only(right: 16.0),
                      child: new Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: new BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: new Text(
                          'Prywatne śmieci',
                          style: Theme.of(context).textTheme.display2,
                        ),
                      ),
                    ),
                  ),
                  new ScaleTransition(
                    scale: _animation3,
                    alignment: FractionalOffset.center,
                    child: new GestureDetector(
                      child: new Material(
                        type: MaterialType.circle,
                        elevation: 4.0,
                        color: Theme.of(context).secondaryHeaderColor,
                        child: new InkWell(
                          customBorder: CircleBorder(
                            side: BorderSide(color: Colors.white10),
                          ),
                          splashColor: Colors.red,
                          onTap: () {
                            if (_angle == 45.0) {
                              _onAddMarkerpressed(context, 'koszubrania');
                            }
                          },
                          child: new Center(
                            child: new Icon(
                              Icons.golf_course,
                              size: 45.0,
                              color: new Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Positioned(
            bottom: 144.0,
            right: 24.0,
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new ScaleTransition(
                    scale: _animation2,
                    alignment: FractionalOffset.center,
                    child: new Container(
                      margin: new EdgeInsets.only(right: 16.0),
                      child: new Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: new BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: new Text(
                          'Automat na butelki',
                          style: Theme.of(context).textTheme.display2,
                        ),
                      ),
                    ),
                  ),
                  new ScaleTransition(
                    scale: _animation2,
                    alignment: FractionalOffset.center,
                    child: new GestureDetector(
                      child: new Material(
                        type: MaterialType.circle,
                        elevation: 4.0,
                        color: Theme.of(context).secondaryHeaderColor,
                        child: new InkWell(
                          customBorder: CircleBorder(
                            side: BorderSide(color: Colors.white10),
                          ),
                          splashColor: Colors.red,
                          onTap: () {
                            if (_angle == 45.0) {
                              _onAddMarkerpressed(context, 'automatbutelki');
                            }
                          },
                          child: new Center(
                            child: new Icon(
                              Icons.face,
                              size: 45.0,
                              color: new Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Positioned(
            bottom: 88.0,
            right: 24.0,
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new ScaleTransition(
                    scale: _animation,
                    alignment: FractionalOffset.center,
                    child: new Container(
                      margin: new EdgeInsets.only(right: 16.0),
                      child: new Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: new BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Pojemniki na recykling',
                          style: Theme.of(context).textTheme.display2,
                        ),
                      ),
                    ),
                  ),
                  new ScaleTransition(
                    scale: _animation,
                    alignment: FractionalOffset.center,
                    child: new GestureDetector(
                      child: new Material(
                        type: MaterialType.circle,
                        elevation: 4.0,
                        color: Theme.of(context).secondaryHeaderColor,
                        child: new InkWell(
                          customBorder: CircleBorder(
                            side: BorderSide(color: Colors.white10),
                          ),
                          splashColor: Colors.red,
                          onTap: () {
                            _onAddMarkerpressed(context, 'koszrecykling');
                          },
                          child: new Center(
                            child: new Icon(
                              Icons.dashboard,
                              size: 45.0,
                              color: new Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Positioned(
            bottom: 16.0,
            right: 16.0,
            child: new Material(
              color: Colors.indigo,
              type: MaterialType.circle,
              elevation: 6.0,
              child: new GestureDetector(
                child: Container(
                  height: 60.0,
                  width: 60.0,
                  child: new InkWell(
                    radius: 45.0,
                    customBorder: CircleBorder(
                      side: BorderSide(
                        color: Colors.white10,
                      ),
                    ),
                    onTap: _condShow,
                    child: new Center(
                      child: new RotationTransition(
                        turns: new AlwaysStoppedAnimation(_angle / 360),
                        child: new Icon(
                          Icons.add,
                          color: new Color(0xFFFFFFFF),
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
