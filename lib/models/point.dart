import 'package:flutter/material.dart';

class Point {
  final String id;
  final double latitude;
  final double longitude;
  final String type;
  List<dynamic> upVoteList;
  List<dynamic> downVoteList;

  Point({
    @required this.id,
    @required this.latitude,
    @required this.longitude,
    @required this.type,
    this.upVoteList,
    this.downVoteList,
  });
}
