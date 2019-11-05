import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

Widget CarouselGallery(BuildContext context) {
  List<String> photos = [
    'cardboard',
    'glass',
    'batteries',
    'alucans',
    'plasticbottles',
  ];

  return CarouselSlider(
      items: [
        'cardboard',
        'glass',
        'batteries',
        'alucans',
        'plasticbottles',
      ].map((i) {
        return new Builder(
          builder: (BuildContext context) {
            return new Container(
              width: MediaQuery.of(context).size.width,
              margin: new EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/assets/$i.jpg'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter),
              ),
              /*child: new Text(
                  'Zdjęcie $i',
                  style: new TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),*/
            );
          },
        );
      }).toList(),
      height: MediaQuery.of(context).size.height * 0.25,
      autoPlay: false);
}
