import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class ReviewCard extends StatefulWidget {
  static const id = "reviewCard";

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class WidgetState {
  String name;
  int review;
  int follower;
  double rate;
  int like;
  int comment;
  String time;

  WidgetState({this.name, this.review, this.follower, this.rate, this.like, this.comment, this.time});
}

var random = new Random();
class _ReviewCardState extends State<ReviewCard> {
  WidgetState state = WidgetState(
    name: base64Encode(List<int>.generate(8, (index) => random.nextInt(100))),
    review: random.nextInt(100),
    follower: random.nextInt(100),
    rate: random.nextDouble() * 10,
    like: random.nextInt(100),
    comment: random.nextInt(100),
    time: base64Encode(List<int>.generate(8, (index) => random.nextInt(100))),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [],)
    );
  }
}
