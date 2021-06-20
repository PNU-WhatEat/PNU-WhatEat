import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/UserInformation.dart';

class ReservationInfo extends StatefulWidget {


  @override
  _ReservationInfoState createState() => _ReservationInfoState();
}

class _Reservation {
  String name;
  DateTime time;
  int table;
  bool enable;

  _Reservation({this.name, this.time, this.table, this.enable});
}

class _ReservationInfoState extends State<ReservationInfo> {
  UserInformation userinfo;
  Stream storeStream;
  int currentPage = 0;
  _Reservation _reservation = _Reservation();

  @override
  void initState() {
    super.initState();
    userinfo = Provider.of<UserInformation>(context, listen: false);
    storeStream = userinfo.info.storeRef.snapshots();
  }

  renderCard(asyncSnapshot) {
    if (currentPage == 0)
      return Text('예약 정보가 없습니다.');
    else {
      asyncSnapshot.data['reservation'][0]['userRef'].get().then((doc) {
        _reservation.name = doc['name'];
      });
      _reservation.table = asyncSnapshot.data['reservation'][0]['table'];
      _reservation.time = asyncSnapshot.data['reservation'][0]['time'].toDate();
      _reservation.enable = asyncSnapshot.data['table'][_reservation.table] != asyncSnapshot.data['occupied'][_reservation.table];
      return Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Text('${_reservation.time}'),
              Text('${_reservation.table + 1}번 테이블'),
              Text('예약자 : ${_reservation.name}'),
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _reservation.enable ? () { } : null, 
                  child: Text('수락', style: TextStyle(color: _reservation.enable ? Colors.blue : Colors.grey, fontWeight: FontWeight.bold),)
                ),
                TextButton(
                  onPressed: () {
                    userinfo.info.storeRef.update({"reservation" : FieldValue.arrayRemove([asyncSnapshot.data['reservation'][0]])}); 
                  }, 
                  child: Text('거절', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                ),
            ],)
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: StreamBuilder(
        stream: storeStream,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasError)
            return Text("Error: ${asyncSnapshot.error}");
          switch(asyncSnapshot.connectionState) {
            case ConnectionState.none : return Text('No data'); break;
            case ConnectionState.waiting : return Text('Waiting Data...'); break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (currentPage == 0 && asyncSnapshot.data['reservation'].length != 0)
                  currentPage = 1;  
              else if (currentPage > asyncSnapshot.data['reservation'].length)
                  currentPage = asyncSnapshot.data['reservation'].length;  
              return Container(
                  height: 300,
                  width : 300, 
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(icon: Icon(Icons.android_rounded), onPressed: () {
                            userinfo.info.storeRef.update({"reservation" : FieldValue.arrayUnion([{
                              "table" : Random().nextInt(12),
                              "time" : DateTime.now(),
                              "userRef" : FirebaseFirestore.instance.collection('User').doc(userinfo.getUser().uid)
                            }])});
                          }),
                          Container(width: 100),
                          Text('$currentPage/${asyncSnapshot.data['reservation'].length}'),
                          Container(width: 30),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 60, 30, 30),
                        child: renderCard(asyncSnapshot),
                      )
                    ],
                  )
                );
            break;
          }
          return null;
        }
      ),
    );
  }
}

