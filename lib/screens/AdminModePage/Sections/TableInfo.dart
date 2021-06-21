import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/UserInformation.dart';

class TableInfo extends StatefulWidget {


  @override
  _TableInfoState createState() => _TableInfoState();
}

class _TableInfoState extends State<TableInfo> {
  UserInformation userinfo;
  Stream storeStream;
  final alertPlayer = AudioCache();

  @override
  void initState() {
    super.initState();
    userinfo = Provider.of<UserInformation>(context, listen: false);
    storeStream = userinfo.info.storeRef.snapshots();
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
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Table(
                  children: [
                    TableRow(children: List.generate(6, (index) {
                      return InkWell(
                        child: Column(
                          children: [
                            Text((index + 1).toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${asyncSnapshot.data['occupied'][index]}/${asyncSnapshot.data['table'][index]}'),
                          ],
                        ),
                        onTap: asyncSnapshot.data['occupied'][index] == 0 ? null : () { 
                          alertPlayer.play('alert.mp3');
                          final l = asyncSnapshot.data['occupied'];
                          --l[index];
                          userinfo.info.storeRef.update({"occupied" : l}); 
                        }
                      );
                    })),
                    TableRow(children: List.generate(6, (_) => Divider(height : 30, thickness: 3,))),
                    TableRow(children: List.generate(6, (index) {
                      return InkWell(
                        child: Column(
                          children: [
                            Text((index + 7).toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${asyncSnapshot.data['occupied'][index + 6]}/${asyncSnapshot.data['table'][index + 6]}'),
                          ],
                        ),
                        onTap: asyncSnapshot.data['occupied'][index + 6] == 0 ? null : () { 
                          alertPlayer.play('alert.mp3');
                           final l = asyncSnapshot.data['occupied'];
                          --l[index + 6];
                          userinfo.info.storeRef.update({"occupied" : l}); 
                        }
                      );
                    })),
                  ],
                ),
              );
            break;
          }
          return null;
        }
      ),
    );
  }
}