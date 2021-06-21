import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:what_eat/screens/AuthPage.dart';
import 'package:what_eat/UserInformation.dart';
import 'package:what_eat/screens/MainPage/Sections/DetailPage.dart';
import 'package:what_eat/screens/LoginPage/Sections/SignInPage.dart';
import 'package:what_eat/screens/MainPage/MainPage.dart';
import 'package:what_eat/screens/MyHomePage.dart';
import 'package:what_eat/screens/MainPage/Sections/ReservationPage.dart';
import 'package:what_eat/screens/MainPage/Sections/ReviewPage.dart';
import 'package:what_eat/screens/MyInfoPage/MyInfoPage.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/EditInfoPage.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/EditPage.dart';
import 'package:what_eat/screens/TimeLinePage/TimeLinePage.dart';
import 'package:what_eat/screens/LoginPage/LandingPage.dart';


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
        ChangeNotifierProvider<UserInformation>(create: (context) => UserInformation()),
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
          LandingPage.id: (context) => LandingPage(),
          SignInPage.id: (context) => SignInPage(),
          AuthPage.id: (context) => AuthPage(),
          '/':(context) => MyHomePage(title: 'WhatEat'),
        },
      ),

    );
  }
}
