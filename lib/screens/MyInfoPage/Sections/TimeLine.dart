import 'package:flutter/material.dart';
import './ListElement.dart';
import '../../TimeLinePage/TimeLinePage.dart';

class TimeLinePageArguments {
  final int categoryOption;
  TimeLinePageArguments({this.categoryOption});
}

class TimeLine extends StatelessWidget {
  static const id = "myMainInfo_widget";
  final int review;
  final int visited;
  TimeLine({this.review, this.visited});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListElement(icon: Icon(Icons.timer), title: "타임라인", value: (review+visited).toString(), onTap: () { Navigator.pushNamed(context, TimeLinePage.id, arguments:TimeLinePageArguments(categoryOption : 0)); }), // dummy
      Row(children: [
        InkWell(
          onTap: () {  Navigator.pushNamed(context, TimeLinePage.id, arguments:TimeLinePageArguments(categoryOption : 1)); },
          child: Center(
            child: Column(children: [
              Text('리뷰'),
              Text(review.toString()), // dummy
            ],),
            heightFactor: 2.5,
            widthFactor: 6.7,
          )
        ),
        Container(height: 80, child: VerticalDivider()),
        InkWell(
          onTap: () {  Navigator.pushNamed(context, TimeLinePage.id, arguments:TimeLinePageArguments(categoryOption : 2)); }, // Todo
          child: Center(
            child: Column(children: [
              Text('방문'),
              Text(visited.toString()), // dummy
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
