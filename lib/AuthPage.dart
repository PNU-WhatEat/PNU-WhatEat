import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/screens/LoginPage/LandingPage.dart';
import 'package:what_eat/screens/MyInfoPage/MyInfoPage.dart';

import 'UserInformation.dart';


class AuthPage extends StatefulWidget {
  static const id = "auth_page";
  @override
  
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  UserInformation userinfo;
  @override
  Widget build(BuildContext context) {
    userinfo = Provider.of<UserInformation>(context);
    if (userinfo.getUser() != null && userinfo.getUser().emailVerified == true) {
      return MyInfoPage();
    } else {
      return LandingPage();
    }
  }
}