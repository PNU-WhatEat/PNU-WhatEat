import 'package:flutter/material.dart';
import 'package:what_eat/screens/DetailPage.dart';
import 'package:what_eat/screens/MainPage.dart';
import 'package:what_eat/screens/ReservationPage.dart';
import 'package:what_eat/screens/ReviewPage.dart';
import 'package:what_eat/screens/MyInfoPage/MyInfoPage.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/EditInfoPage.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/EditPage.dart';
import 'package:what_eat/screens/TimeLinePage/TimeLinePage.dart';
import 'package:what_eat/screens/LoginPage.dart';
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
        MyInfoPage.id: (context) => MyInfoPage(),
        EditInfoPage.id: (context) => EditInfoPage(),
        EditPage.id: (context) => EditPage(),
        TimeLinePage.id: (context) => TimeLinePage(),
        LoginPage.id: (context) => LoginPage(),
      },
    );
  }
}
