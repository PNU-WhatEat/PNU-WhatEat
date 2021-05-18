import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/UserInformation.dart';
import 'package:what_eat/screens/MyStorePage/MyStorePage.dart';
import './Sections/MyMainInfo.dart';
import './Sections/TimeLine.dart';
import './Sections/ListElement.dart';

class MyInfoPage extends StatelessWidget {
  static const id = "myInfo_page";
  
  @override
  Widget build(BuildContext context) {
    UserInformation userinfo = Provider.of<UserInformation>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            MyMainInfo(name: userinfo.info.name, email: userinfo.info.email, phoneNumber: userinfo.info.phoneNumber, follower: userinfo.info.follower, following: userinfo.info.following, like: userinfo.info.like),
            Divider(
              thickness: 10,
            ),
            TimeLine(review: userinfo.info.review, visited: userinfo.info.visited),
            ListElement(icon: Icon(Icons.favorite, color: Colors.blue), title: "즐겨찾기", value: userinfo.info.favorite.toString(), onTap: () {
              // Todo : navigate to favoritePage
            }), 
            Divider(thickness: 1,),
            ListElement(icon: Icon(Icons.house, color: Colors.blue), title: "내 가게", onTap: () {
              Navigator.pushNamed(context, MyStorePage.id);
            }),
            Divider(thickness: 1,),
            ListElement(icon: Icon(Icons.sync_alt, color: Colors.blue), title: "관리모드 전환"),
            Divider(thickness: 1,),
            ListElement(icon: Icon(Icons.exit_to_app, color: Colors.blue), title: "로그아웃", onTap: () async {
              await userinfo.signOut();
            }),
            Divider(thickness: 1,),
          ],
        ),
      ),
    );
  }
}
