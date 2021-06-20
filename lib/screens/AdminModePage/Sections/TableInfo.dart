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
              return Table(
                  children: [
                    TableRow(children: List.generate(6, (index) => Text((index + 1).toString(), style: TextStyle(fontWeight: FontWeight.bold)))),
                    TableRow(children: List.generate(6, (index) => Text('${asyncSnapshot.data['occupied'][index]}/${asyncSnapshot.data['table'][index]}'))),
                    TableRow(children: List.generate(6, (index) => Text((index + 7).toString(), style: TextStyle(fontWeight: FontWeight.bold)))),
                    TableRow(children: List.generate(6, (index) => Text('${asyncSnapshot.data['occupied'][index + 6]}/${asyncSnapshot.data['table'][index + 6]}'))),
                  ],
                );
            break;
          }
          return null;
        }
      ),
    );
  }
}