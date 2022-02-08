import 'package:flutter/material.dart';

class Post with ChangeNotifier {
  String userimageUrl;
  String name;
  double rate;
  String mapUrl;
  String comment;
  String placeName;
  String postImageUrl;

  Post({
    @required this.userimageUrl,
    @required this.name,
    @required this.rate,
    @required this.mapUrl,
    @required this.comment,
    @required this.placeName,
    @required this.postImageUrl,
  });
}
