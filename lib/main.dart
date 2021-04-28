import 'package:flutter/material.dart';
import 'package:what_eat/screens/DetailPage.dart';
import 'package:what_eat/screens/MainPage.dart';
import 'package:what_eat/screens/ReservationPage.dart';
import 'package:what_eat/screens/ReviewPage.dart';

void main() {
  runApp(WhatEat());
}

class WhatEat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MainPage.id,
      routes: {
        MainPage.id: (context) => MainPage(),
        DetailPage.id: (context) => DetailPage(),
        ReservationPage.id: (context) => ReservationPage(),
        ReviewPage.id: (context) => ReviewPage(),
      },
    );
  }
}
