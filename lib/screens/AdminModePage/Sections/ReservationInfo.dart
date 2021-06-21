import 'package:audioplayers/audioplayers.dart';
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
  List occupied;
  int prv;
  _Reservation _reservation = _Reservation();
  final alertPlayer = AudioCache();

  @override
  void initState() {
    super.initState();
    userinfo = Provider.of<UserInformation>(context, listen: false);
    storeStream = userinfo.info.storeRef.snapshots();
  }

  renderCard(asyncSnapshot, futureSnapshot) {
    _reservation.name = futureSnapshot.data['name'];
    _reservation.table = asyncSnapshot.data['reservation'][0]['table'];
    _reservation.time = asyncSnapshot.data['reservation'][0]['time'].toDate();
    _reservation.enable = asyncSnapshot.data['table'][_reservation.table] != asyncSnapshot.data['occupied'][_reservation.table];
    occupied = asyncSnapshot.data['occupied'];
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
                onPressed: _reservation.enable ? () { 
                  ++occupied[_reservation.table];
                  userinfo.info.storeRef.update({"occupied" : occupied});
                  userinfo.info.storeRef.update({"reservation" : FieldValue.arrayRemove([asyncSnapshot.data['reservation'][0]])}); 
                } : null, 
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

  renderEmpty(String text) {
    return Container(
      height: 300,
      width : 300, 
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('0/0'),
              Container(width: 30),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30, 100, 30, 30),
            child: Text(text, style: TextStyle(color: Colors.red))
          )
        ],
      )
    );
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
              if (prv != asyncSnapshot.data['reservation'].length) {
                alertPlayer.play('alert.mp3');
                prv = asyncSnapshot.data['reservation'].length; 
              }
              if (currentPage == 0 && asyncSnapshot.data['reservation'].length != 0)
                  currentPage = 1;  
              else if (currentPage > asyncSnapshot.data['reservation'].length)
                  currentPage = asyncSnapshot.data['reservation'].length;
              
              
              return currentPage == 0 ? 
                renderEmpty("아직 예약이 들어오지 않았습니다.")
                :  
                FutureBuilder<Object>(
                  future: asyncSnapshot.data['reservation'][0]['userRef'].get(),
                  builder: (context, futureSnapshot) {
                    if (!futureSnapshot.hasData)
                      return renderEmpty("");
                    else
                      return Container(
                        height: 300,
                        width : 300, 
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('$currentPage/${asyncSnapshot.data['reservation'].length}'),
                                Container(width: 30),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(30, 60, 30, 10),
                              child: renderCard(asyncSnapshot, futureSnapshot),
                            )
                          ],
                        )
                      );
                  }
                );
            break;
          }
          return null;
        }
      ),
    );
  }
}

