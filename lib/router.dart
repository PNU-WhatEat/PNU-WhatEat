import 'package:flutter/material.dart';
import 'package:what_eat/screens/MyInfoPage/MyInfoPage.dart';  //이 형식으로 import
import 'package:what_eat/screens/MainPage.dart';
import 'package:what_eat/screens/ReviewPage.dart';
// bottom navigator를 눌러 이동할 것 이 사이에을 import
import 'package:what_eat/constants/router.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(
            settings: RouteSettings(name: settings.name, isInitialRoute: true),
            builder: (_) => MainPage()
        );
      case secondRoute:
        return MaterialPageRoute(
            settings: RouteSettings(name: settings.name, isInitialRoute: true),
            builder: (_) => ReviewPage()
        );
      case thirdRoute:
        return MaterialPageRoute(
            settings: RouteSettings(name: settings.name, isInitialRoute: true),
            builder: (_) => MyInfoPage()
        );
        default:
        return MaterialPageRoute(builder: (context) => MainPage());
    }
  }
}
