import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/UserInformation.dart';
import 'package:what_eat/screens/AdminModePage/Sections/TableInfo.dart';
import 'package:what_eat/screens/AdminModePage/Sections/ReservationInfo.dart';

class AdminModePage extends StatefulWidget {
  static const id = "adminmode_page";
  @override
  
  _AdminModePage createState() => _AdminModePage();
}

class _AdminModePage extends State<AdminModePage> {
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
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Text("관리모드를 나가게 될 경우 더 이상 예약을 \n받을 수 없게 됩니다.\n정말 나가시겠습니까?"),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              actions: [
                TextButton(
                  child: Text("확인"), 
                  onPressed: () {
                    Navigator.pop(context, true);
                  }
                ),
                TextButton(
                  child: Text("취소"), 
                  onPressed: () {
                    Navigator.pop(context, false);
                  }
                )
              ]
            );
          }
        ) ?? false;
      },
      child: Column(
        children: [
          TableInfo(),

          ReservationInfo(),
        ],
      )
    );           
  }
}