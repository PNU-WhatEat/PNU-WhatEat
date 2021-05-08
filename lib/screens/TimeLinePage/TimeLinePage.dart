import 'package:flutter/material.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/TimeLine.dart';

class TimeLinePage extends StatefulWidget {
  static const id = "timeLine_page";
  int category;

  TimeLinePage({this.category});

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  
  @override
  Widget build(BuildContext context) {
    final TimeLinePageArguments args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('타임 라인'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextButton(child: Text('리뷰'), onPressed: () { setState(() {
                widget.category = 0;
              }); },)),
              Expanded(child: TextButton(child: Text('방문'), onPressed: () { },))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Divider(thickness: 1,),
          //widget.category == 0 ? ReviewList() : VisitedList();
        ],
      ),
    );
  }
}
