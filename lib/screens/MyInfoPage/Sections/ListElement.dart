import 'package:flutter/material.dart';

class ListElement extends StatelessWidget {
  Icon icon;
  String title;
  String value;
  VoidCallback onTap;
  ListElement({this.icon, this.title = "", this.value = "", this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(children: [
        SizedBox(height: 10),
          Row(children: [
            Row(children: [
              SizedBox(width: 10,),
              Text(title, style: TextStyle(fontSize: 20),),
            ],),
            Row(children: [
              Text(value, style: TextStyle(fontSize: 20),),
              Icon(Icons.arrow_forward_ios, color: Colors.grey) // dummy
            ],)
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        SizedBox(height: 10),
      ],
      )
    );
  }
}
