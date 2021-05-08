import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import '../LoginPage.dart';
import './Sections/MyMainInfo.dart';
import './Sections/TimeLine.dart';
import './Sections/ListElement.dart';

_MyInfoPageState myInfoPageState = _MyInfoPageState();

class MyInfoPage extends StatefulWidget {
  static const id = "myInfo_page";

  @override
  _MyInfoPageState createState() => myInfoPageState;
}

class WidgetState {
  String name;
  String email;
  String phoneNumber;
  int follower;
  int following;
  int like;
  int review;
  int visited;
  int favorite;

  WidgetState({this.name, this.email, this.phoneNumber, this.follower, this.following, this.like, this.review, this.visited, this.favorite});
}

var random = new Random();
class _MyInfoPageState extends State<MyInfoPage> {
  WidgetState state = WidgetState(
    name: base64Encode(List<int>.generate(8, (index) => random.nextInt(100))),
    email: base64Encode(List<int>.generate(8, (index) => random.nextInt(100))),
    phoneNumber: base64Encode(List<int>.generate(8, (index) => random.nextInt(100))),
    follower: random.nextInt(100),
    following: random.nextInt(100),
    like: random.nextInt(100),
    review: random.nextInt(100),
    visited: random.nextInt(100),
    favorite: random.nextInt(100)
  );

  void reloadInfo() {
    setState(() {
      state = WidgetState(
        name: base64Encode(List<int>.generate(8, (index) => random.nextInt(100))),
        email: base64Encode(List<int>.generate(8, (index) => random.nextInt(100))),
        phoneNumber: base64Encode(List<int>.generate(8, (index) => random.nextInt(100))),
        follower: random.nextInt(100),
        following: random.nextInt(100),
        like: random.nextInt(100),
        review: random.nextInt(100),
        visited: random.nextInt(100),
        favorite: random.nextInt(100)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            MyMainInfo(name: state.name, email: state.email, phoneNumber: state.phoneNumber, follower: state.follower, following: state.following, like: state.like),
            Divider(
              thickness: 10,
            ),
            TimeLine(review: state.review, visited: state.visited),
            ListElement(icon: Icon(Icons.favorite), title: "즐겨찾기", value: state.favorite.toString(), onTap: () {
              // Todo : navigate to favoritePage
            }), 
            Divider(thickness: 1,),
            ListElement(icon: Icon(Icons.house), title: "내 가게"),
            Divider(thickness: 1,),
            ListElement(icon: Icon(Icons.sync_alt), title: "관리모드 전환"),
            Divider(thickness: 1,),
            ListElement(icon: Icon(Icons.exit_to_app), title: "로그아웃", onTap: () {
              //Navigator.pushReplacementNamed(context, LoginPage.id);
              setState(() {
                state.review++;
              });
            }),
            Divider(thickness: 1,),
          ],
        ),
      ),
    );
  }
}
