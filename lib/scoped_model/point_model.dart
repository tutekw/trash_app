import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/point.dart';
import './user_model.dart';
import './main.dart';
import '../widgets/carousel_slider.dart';

mixin PointsModel on ConnectedProductsModel {
  bool _isLoading = false;
  Set<Marker> markers = Set();

  bool get isLoading {
    return _isLoading;
  }

  Future<bool> addPoint(double lat, double lng, String typeof) async {
    if ((lat >= 50 && lat <= 52) && (lng >= 14 && lng <= 15)) {
      return false;
    }
    final Map<String, dynamic> pointData = {
      'latitude': lat,
      'longitude': lng,
      'type': typeof,
      'upVoteList': ['initState'],
      'downVoteList': ['initState'],
    };
    try {
      final http.Response response = await http.post(
        'https://uberclone-f1030.firebaseio.com/points.json',
        body: json.encode(pointData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
    } catch (error) {
      return false;
    }
    return true;
  }

  Future<bool> deletePoint(Point point) {
    _isLoading = true;
    final deletedPointId = point.id;
    markers
        .removeWhere((marker) => marker.markerId == MarkerId(deletedPointId));
    print(deletedPointId);
    print(markers);
    notifyListeners();
    return http
        .delete(
      'https://uberclone-f1030.firebaseio.com/points/${deletedPointId}.json?}',
    )
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Set<Marker> get renderedMarkers {
    return markers;
  }

  void toggleLikeStatus(Point point, bool vote) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('userId');
    Point updatedPoint = point;

    if (point.upVoteList == null || point.downVoteList == null) {
      if (vote == false) {
        List<dynamic> updatedUpList = point.upVoteList;
        updatedUpList.add(userId);
        updatedPoint = Point(
          id: point.id,
          latitude: point.latitude,
          longitude: point.longitude,
          type: point.type,
          upVoteList: updatedUpList,
          downVoteList: point.downVoteList,
        );
      } else if (vote == true) {
        List<dynamic> updatedDownList = point.downVoteList;
        updatedDownList.add(userId);
        updatedPoint = Point(
          id: point.id,
          latitude: point.latitude,
          longitude: point.longitude,
          type: point.type,
          upVoteList: point.upVoteList,
          downVoteList: updatedDownList,
        );
      }
    } else if (point.upVoteList.contains(userId)) {
      if (vote == false) {
        List<dynamic> updatedUpList = point.upVoteList;
        updatedUpList.remove(userId);
        updatedPoint = Point(
          id: point.id,
          latitude: point.latitude,
          longitude: point.longitude,
          type: point.type,
          upVoteList: updatedUpList,
          downVoteList: point.downVoteList,
        );
      } else if (vote == true) {
        List<dynamic> updatedUpList = point.upVoteList;
        updatedUpList.remove(userId);
        List<dynamic> updatedDownList = point.downVoteList;
        updatedDownList.add(userId);
        updatedPoint = Point(
          id: point.id,
          latitude: point.latitude,
          longitude: point.longitude,
          type: point.type,
          upVoteList: updatedUpList,
          downVoteList: updatedDownList,
        );
      }
    } else if (point.downVoteList.contains(userId)) {
      if (vote == false) {
        List<dynamic> updatedDownList = point.downVoteList;
        updatedDownList.remove(userId);
        List<dynamic> updatedUpList = point.upVoteList;
        updatedUpList.add(userId);
        updatedPoint = Point(
          id: point.id,
          latitude: point.latitude,
          longitude: point.longitude,
          type: point.type,
          upVoteList: updatedUpList,
          downVoteList: updatedDownList,
        );
      } else if (vote == true) {
        List<dynamic> updatedDownList = point.downVoteList;
        updatedDownList.remove(userId);
        updatedPoint = Point(
          id: point.id,
          latitude: point.latitude,
          longitude: point.longitude,
          type: point.type,
          upVoteList: point.upVoteList,
          downVoteList: updatedDownList,
        );
      }
    } else if (!point.upVoteList.contains(userId) ||
        !point.downVoteList.contains(userId)) {
      if (vote == false) {
        List<dynamic> updatedUpList = point.upVoteList;
        updatedUpList.add(userId);
        print(updatedUpList);
        updatedPoint = Point(
          id: point.id,
          latitude: point.latitude,
          longitude: point.longitude,
          type: point.type,
          upVoteList: updatedUpList,
          downVoteList: point.downVoteList,
        );
      } else if (vote == true) {
        List<dynamic> updatedDownList = point.downVoteList;
        updatedDownList.add(userId);
        updatedPoint = Point(
          id: point.id,
          latitude: point.latitude,
          longitude: point.longitude,
          type: point.type,
          upVoteList: point.upVoteList,
          downVoteList: updatedDownList,
        );
      }
    }
    http.Response response = await http.put(
        'https://uberclone-f1030.firebaseio.com/points/${point.id}/upVoteList.json',
        body: json.encode(updatedPoint.upVoteList));
    http.Response response1 = await http.put(
        'https://uberclone-f1030.firebaseio.com/points/${point.id}/downVoteList.json',
        body: json.encode(updatedPoint.downVoteList));
    notifyListeners();
    if (point.downVoteList.length >= 2) {
      deletePoint(updatedPoint);
      notifyListeners();
    }
  }

  _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Zaloguj się aby móc oceniać punkty",
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

  void _settingModalBottomSheet(BuildContext context, Point point) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('userId');
    String _typeOfTrash;
    if (point.type == 'koszrecykling') {
      _typeOfTrash = 'Kosz do recyklingu';
    } else if (point.type == 'automatbutelki') {
      _typeOfTrash = 'Automat do odbioru butelek PET';
    } else if (point.type == 'koszubrania') {
      _typeOfTrash = 'Prywatne śmieci';
    }

    List items = <Widget>[
      Container(
        height: MediaQuery.of(context).size.height * 0.17,
        child: Text("Witaj"),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/cardboard.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.17,
        child: Text("Witaj"),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/cardboard.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.17,
        child: Text("Witaj"),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/cardboard.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.17,
        child: Text("Witaj"),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/cardboard.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.17,
        child: Text("Witaj"),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/cardboard.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ];

    CarouselSlider(
      items: items,
      viewportFraction: 0.6,
      initialPage: 0,
      aspectRatio: 16 / 9,
      height: MediaQuery.of(context).size.height * 0.1,
      reverse: false,
      autoPlay: false,
      enableInfiniteScroll: false,
      autoPlayCurve: Curves.fastOutSlowIn,
    );

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: _typeOfTrash == "Prywatne śmieci"
                ? MediaQuery.of(context).size.height * 0.4
                : MediaQuery.of(context).size.height * 0.2,
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    _typeOfTrash,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 20.0,
                  ),
                  Center(
                    child: ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                IconButton(
                                  splashColor: Colors.greenAccent,
                                  color: point.upVoteList == null
                                      ? Colors.black
                                      : point.upVoteList.contains(userId)
                                          ? Colors.green
                                          : Colors.black,
                                  icon: Icon(Icons.thumb_up),
                                  onPressed: () {
                                    if (model.user == null) {
                                      _showDialog(context);
                                    } else {
                                      toggleLikeStatus(point, false);
                                      notifyListeners();
                                    }
                                  },
                                ),
                                Text(point.upVoteList != null
                                    ? (point.upVoteList.length - 1).toString()
                                    : '0'),
                              ],
                            ),
                            Container(
                              width: 25.0,
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  splashColor: Colors.redAccent,
                                  color: point.downVoteList != null
                                      ? point.downVoteList.contains(userId)
                                          ? Colors.red
                                          : Colors.black
                                      : Colors.black,
                                  icon: Icon(Icons.thumb_down),
                                  onPressed: () {
                                    if (model.user == null) {
                                      _showDialog(context);
                                    } else {
                                      if (point.downVoteList.length >= 1) {
                                        Navigator.of(context).pop();
                                      }
                                      toggleLikeStatus(point, true);
                                      notifyListeners();
                                    }
                                  },
                                ),
                                Text(point.downVoteList != null
                                    ? (point.downVoteList.length - 1).toString()
                                    : '0'),
                              ],
                            ),
                            // RaisedButton(
                            // onPressed: () {},
                            // child: Text('Więcej'),
                            //),
                            //
                          ],
                        );
                      },
                    ),
                  ),
                  _typeOfTrash == 'Prywatne śmieci'
                      ? CarouselGallery(context)
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  Future<Null> fetchPoints(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://uberclone-f1030.firebaseio.com/points.json')
        .then<Null>(
      (http.Response response) {
        final List<Point> fetchedPointList = [];
        final Map<String, dynamic> pointListData = json.decode(response.body);
        if (pointListData == null) {
          return;
        }
        pointListData.forEach(
          (String pointId, dynamic pointListData) {
            final Point point = Point(
                id: pointId,
                latitude: pointListData['latitude'],
                longitude: pointListData['longitude'],
                type: pointListData['type'],
                upVoteList: pointListData['upVoteList'],
                downVoteList: pointListData['downVoteList']);
            fetchedPointList.add(point);
            BitmapDescriptor _icon;
            if (point.type == 'koszrecykling') {
              _icon = BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow);
            } else if (point.type == 'koszubrania') {
              _icon = BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure);
            } else if (point.type == 'inne') {
              _icon = BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueMagenta);
            }
            markers.add(
              Marker(
                onTap: () => _settingModalBottomSheet(context, point),
                icon: _icon,
                markerId: MarkerId(pointId),
                position: new LatLng(
                    pointListData['latitude'], pointListData['longitude']),
              ),
            );
            _isLoading = false;
            notifyListeners();
          },
        );
      },
    ).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }
}
