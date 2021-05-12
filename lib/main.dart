import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:what_eat/AuthPage.dart';
import 'package:what_eat/UserInformation.dart';
import 'package:what_eat/screens/DetailPage.dart';
import 'package:what_eat/screens/LoginPage/Sections/EmailLoginPage.dart';
import 'package:what_eat/screens/MainPage.dart';
import 'package:what_eat/screens/ReservationPage.dart';
import 'package:what_eat/screens/ReviewPage.dart';
import 'package:what_eat/screens/MyInfoPage/MyInfoPage.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/EditInfoPage.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/EditPage.dart';
import 'package:what_eat/screens/TimeLinePage/TimeLinePage.dart';
import 'package:what_eat/screens/LoginPage/LoginPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WhatEat());
}

class WhatEat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        initialRoute: AuthPage.id,
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
          EmailLoginPage.id: (context) => EmailLoginPage(),
          AuthPage.id: (context) => AuthPage(),
        },
      ),
    );
  }
}
