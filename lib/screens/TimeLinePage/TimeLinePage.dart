import 'package:flutter/material.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/TimeLine.dart';

class TimeLinePage extends StatelessWidget {
  static const id = "timeLine_page";
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
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.filter_alt),
                label: Text("필터"),
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0))),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          )
        ],
      ),
    );
  }
}
