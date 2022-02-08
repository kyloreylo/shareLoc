import 'package:flutter/material.dart';

class Post with ChangeNotifier {
  String imageUrl;
  String name;
  double rate;
  String mapUrl;
  String comment;
  String placeName;

  Post({
    this.imageUrl,
    this.name,
    this.rate,
    this.mapUrl,
    this.comment,
    this.placeName,
  });
}
