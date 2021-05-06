import 'package:flutter/material.dart';
import './Sections/MyMainInfo.dart';
import './Sections/TimeLine.dart';
import './Sections/ListElement.dart';

class MyInfoPage extends StatelessWidget {
  static const id = "myInfo_page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            MyMainInfo(),
            Divider(
              thickness: 10,
            ),
            TimeLine(),
            ListElement(icon: Icon(Icons.favorite), title: "즐겨찾기", value: "3"), // dummy
            Divider(thickness: 1,),
            ListElement(icon: Icon(Icons.house), title: "내 가게"),
            Divider(thickness: 1,),
            ListElement(icon: Icon(Icons.sync_alt), title: "관리모드 전환"),
            Divider(thickness: 1,),
          ],
        ),
      ),
    );
  }
}
