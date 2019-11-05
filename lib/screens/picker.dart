import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as geoloc;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import '../scoped_model/main.dart';

class PickerPage extends StatefulWidget {
  final MainModel model;
  double centerLat;
  double centerLng;
  String type;
  PickerPage(this.model, this.centerLat, this.centerLng, this.type);
  @override
  State<StatefulWidget> createState() {
    return _PickerPageState();
  }
}

class _PickerPageState extends State<PickerPage> {
  Completer<GoogleMapController> _controllerMaps = Completer();
  var location = new geoloc.Location();
  Map<String, double> userLocation;
  double lato;
  double lngo;
  double targetLatitude;
  double targetLongitude;
  String token;
  String locationString = 'Porusz mapą aby otrzymać adres';
  bool _isLoading = false;
  String _mapStyle;

  Future<void> _updateLocation(double lat, double lng) async {
    final GoogleMapController controller = await _controllerMaps.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng),
      zoom: 17.6,
    )));
  }

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51, 14.34523),
    zoom: 17.6,
  );

  @override
  void initState() {
    rootBundle.loadString('lib/assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  Future<String> _getAddress(double lat, double lng) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng': '${lat.toString()},${lng.toString()}',
        'key': 'AIzaSyCSwG6hqe3Jf8B7GPVAoMR6ocCBwkEV5Ag'
      },
    );
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];

    return formattedAddress;
  }

  void _setAddress(double lati, double lngi) async {
    locationString = await _getAddress(lati, lngi);
    lato = lati;
    lngo = lngi;
    if (locationString == 'Mlýnská 187, 407 81 Lipová, Czechia') {
      return;
    } else if ((lati >= 50 && lati <= 52) && (lngi >= 14 && lngi <= 15)) {
      return;
    }
    print(locationString);
    setState(() {});
  }

  _showEmptyAddressDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Adres nie moźe być pusty. Spróbuj poruszyć mapą przed dodaniem punktu.",
            style: Theme.of(context).textTheme.display2,
          ),
          actions: <Widget>[
            new IconButton(
              splashColor: Colors.red,
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
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
      margin: EdgeInsets.only(top: 35.0),
      child: new Builder(
        builder: (context) {
          return new IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 36.0,
          );
        },
      ),
    );
  }

  static LatLng latLngCamera;

  void _getUserLocation() async {
    final location = geoloc.Location();
    final currentLocation = await location.getLocation();
    _updateLocation(currentLocation.latitude, currentLocation.longitude);
    latLngCamera =
        new LatLng(currentLocation.latitude, currentLocation.longitude);
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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 200.0,
          child: Center(
              child: Column(
            children: <Widget>[
              Text('Adres:'),
              _isLoading
                  ? Container()
                  : Text(
                      locationString,
                    ),
              RaisedButton(
                child: Text('Dodaj'),
                onPressed: () {
                  if ((lato >= 50 && lato <= 52) &&
                      (lngo >= 14 && lngo <= 15)) {
                    _showEmptyAddressDialog(context);
                  } else {
                    widget.model.addPoint(lato, lngo, widget.type);
                    Navigator.popAndPushNamed(context, '/');
                  }
                },
              )
            ],
          )),
        ),
      ),
      body: Stack(
        children: <Widget>[
          widget.model.isLoading && false
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controllerMaps.complete(controller);
                    _updateLocation(widget.centerLat, widget.centerLng);
                    controller.setMapStyle(_mapStyle);
                    setState(() {});
                    setState(() {}); // solution for Czech map error
                  },
                  onCameraMove: (object) => {
                    targetLatitude = object.target.latitude,
                    targetLongitude = object.target.longitude,
                  },
                  onCameraIdle: () {
                    _setAddress(targetLatitude, targetLongitude);
                  },
                  initialCameraPosition: _kGooglePlex,
                ),
          Center(
            child: Icon(Icons.location_searching),
          ),
          _buildUserLocationButton(),
          _buildMenuToggleButton(),
        ],
      ),
    );
  }
}
