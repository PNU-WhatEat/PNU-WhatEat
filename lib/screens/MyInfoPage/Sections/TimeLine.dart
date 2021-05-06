import 'package:flutter/material.dart';
import './ListElement.dart';

class TimeLine extends StatelessWidget {
  static const id = "myMainInfo_widget";
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListElement(icon: Icon(Icons.timer), title: "타임라인", value: "13"), // dummy
      Row(children: [
        InkWell(
          onTap: () { }, // Todo
          child: Center(
            child: Column(children: [
              Text('리뷰'),
              Text('3'), // dummy
            ],),
            heightFactor: 2.5,
            widthFactor: 5,
          )
        ),
        InkWell(
          onTap: () { }, // Todo
          child: Center(
            child: Column(children: [
              Text('방문'),
              Text('10'), // dummy
            ],),
            heightFactor: 2.5,
            widthFactor: 5,
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      Divider(thickness: 1,),
    ],);
  }
}
