import 'package:flutter/material.dart';

class TimeLineCard extends StatelessWidget {
  static const id = 'detail_page';
  @required final int type;
  @required final String storeTitle;
  @required final String time;
  final double storeRate;

  TimeLineCard({this.type, this.storeTitle, this.time, this.storeRate = -1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10.0)),
      height: 80,
      child: Row(
        children: [
          Text(storeTitle, style: TextStyle(
            fontSize: 20,
          )),
          Container(height: 10, child: VerticalDivider()),
          Column(
            children: [
              Container(),
              Text('${storeRate.toString().substring(0, 3)} / 10.0'),
              Text(time, style: TextStyle(
                fontSize: 10
              )),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }
}
