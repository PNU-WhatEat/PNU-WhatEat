import 'package:flutter/material.dart';
import './ListElement.dart';
import '../../TimeLinePage/TimeLinePage.dart';

class TimeLinePageArguments {
  final int filterOption;

  TimeLinePageArguments({this.filterOption});
}

class TimeLine extends StatelessWidget {
  static const id = "myMainInfo_widget";
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListElement(icon: Icon(Icons.timer), title: "타임라인", value: "13", onTap: () { Navigator.pushNamed(context, TimeLinePage.id, arguments:TimeLinePageArguments(filterOption : 0)); }), // dummy
      Row(children: [
        InkWell(
          onTap: () {  Navigator.pushNamed(context, TimeLinePage.id, arguments:TimeLinePageArguments(filterOption : 1)); },
          child: Center(
            child: Column(children: [
              Text('리뷰'),
              Text('3'), // dummy
            ],),
            heightFactor: 2.5,
            widthFactor: 6.7,
          )
        ),
        Container(height: 80, child: VerticalDivider()),
        InkWell(
          onTap: () {  Navigator.pushNamed(context, TimeLinePage.id, arguments:TimeLinePageArguments(filterOption : 2)); }, // Todo
          child: Center(
            child: Column(children: [
              Text('방문'),
              Text('10'), // dummy
            ],),
            heightFactor: 2.5,
            widthFactor: 6.7,
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      Divider(thickness: 1,),
    ],);
  }
}
