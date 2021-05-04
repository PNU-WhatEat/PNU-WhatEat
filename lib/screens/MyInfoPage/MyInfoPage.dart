import 'package:flutter/material.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/MyMainInfo.dart';

class MyInfoPage extends StatelessWidget {
  static const id = "myInfo_page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          MyMainInfo(),
          Divider(
            thickness: 10,
          ),

        ],
      ),
    );
  }
}
