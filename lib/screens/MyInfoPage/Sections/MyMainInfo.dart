import 'package:flutter/material.dart';
import 'EditInfoPage.dart';

class EditInfoPageArgs {
  final String name;
  final String email;
  final String phoneNumber;

  EditInfoPageArgs({this.name, this.email, this.phoneNumber});
}

class MyMainInfo extends StatelessWidget{
  static const id = "myMainInfo_Page";
  final String name;
  final String email;
  final String phoneNumber;
  final int follower;
  final int following;
  final int like;

  MyMainInfo({this.name, this.email, this.phoneNumber, this.follower, this.following, this.like});
  @override
  Widget build(BuildContext context) {
    return Row( children: [
      Row( children: [
          Column( children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('images/default_icon.png'),
                backgroundColor: Colors.transparent,
              ),
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
          Navigator.pushNamed(context, EditInfoPage.id, arguments: EditInfoPageArgs(name: this.name, email: this.email, phoneNumber: this.phoneNumber));
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
