import 'package:flutter/material.dart';
import 'package:mekancimapp/widgets/post_item.dart';
import 'package:mekancimapp/widgets/trend_item.dart';

class TrendScreeen extends StatefulWidget {
  @override
  _TrendScreeenState createState() => _TrendScreeenState();
}

class _TrendScreeenState extends State<TrendScreeen> {
  @override
  Widget build(BuildContext context) {
    return TrendItem();
  }
}
