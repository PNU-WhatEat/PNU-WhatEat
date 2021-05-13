import 'package:flutter/material.dart';
import 'EditInfoPage.dart';

class EditInfoPageArgs {
  final String name;
  final String email;
  final String phoneNumber;
  final String userid;

  EditInfoPageArgs({this.name, this.email, this.phoneNumber, this.userid});
}

class MyMainInfo extends StatelessWidget{
  static const id = "myMainInfo_Page";
  final String name;
  final String email;
  final String phoneNumber;
  final int follower;
  final int following;
  final int like;
  final String userid;

  MyMainInfo({this.name, this.email, this.phoneNumber, this.follower, this.following, this.like, this.userid});
  @override
  Widget build(BuildContext context) {
    return Row( children: [
      Row( children: [
          Column( children: [
              Icon(Icons.account_circle, size: 80, color: Colors.blue),
              Container(
                child: Text(name,
                  style: TextStyle(
                    fontSize: 15.7,
                    fontWeight: FontWeight.bold,
                  )
                ),
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          Column(
            children: [
              SizedBox(width: 50),
              Text(follower.toString()),
              Text('팔로워')
            ],
          ),
          Column(
            children: [
              SizedBox(width: 50),
              Text(following.toString()),
              Text('팔로잉')
            ],
          ),
          Column(
            children: [
              SizedBox(width: 50),
              Text(like.toString()),
              Text('좋아요')
            ],
          ),
        ]
      ),
      OutlinedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, EditInfoPage.id, arguments: EditInfoPageArgs(name: this.name, email: this.email, phoneNumber: this.phoneNumber, userid: this.userid));
        }, 
        icon: Icon(Icons.edit),
        label: Text("수정"),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)) 
        ),
      ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
