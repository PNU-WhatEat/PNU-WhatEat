import 'package:flutter/material.dart';

class MyMainInfo extends StatelessWidget {
  static const id = "myMainInfo_widget";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Column(
              children: [
                Icon(
                  Icons.account_circle,
                  color: Colors.blue,
                  size: 80
                ),
                Container(
                  child: Text('홍길동', // dummy
                    style: TextStyle(
                      fontSize: 15.7,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                )// dummy
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            Column(
              children: [
                SizedBox(width: 50),
                Text('0'), // dummy
                Text('방문')
              ],
            ),
            Column(
              children: [
                SizedBox(width: 50),
                Text('0'), // dummy
                Text('좋아요')
              ],
            ),
          ]
        ),
        OutlinedButton.icon(
          onPressed: () {
            // todo
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
