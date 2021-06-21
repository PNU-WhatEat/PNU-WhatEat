import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/UserInformation.dart';
import 'package:what_eat/screens/AdminModePage/AdminModePage.dart';
import 'package:what_eat/screens/MyStorePage/MyStorePage.dart';
import './Sections/MyMainInfo.dart';
import './Sections/TimeLine.dart';
import './Sections/ListElement.dart';

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyInfoPage extends StatelessWidget {
  static const id = "myInfo_page";
  
  @override
  Widget build(BuildContext context) {
    UserInformation userinfo = Provider.of<UserInformation>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            MyMainInfo(name: userinfo.info.name, email: userinfo.info.email, phoneNumber: userinfo.info.phoneNumber, follower: userinfo.info.follower, following: userinfo.info.following, like: userinfo.info.like),
            Divider(
              thickness: 10,
            ),
            TimeLine(review: userinfo.info.review, visited: userinfo.info.visited),
            ListElement(icon: Icon(Icons.favorite, color: Colors.blue), title: "즐겨찾기", value: userinfo.info.favorite.toString(), onTap: () {
              // Todo : navigate to favoritePage
            }), 
            Divider(thickness: 1,),
            ListElement(icon: Icon(Icons.house, color: Colors.blue), title: "내 가게", onTap: () {
              Navigator.pushNamed(context, MyStorePage.id);
            }),
            Divider(thickness: 1,),
            ListElement(icon: Icon(Icons.sync_alt, color: Colors.blue), title: "관리모드 전환", onTap: () {
              userinfo.info.storeRef.get().then((doc) {
                if (doc.get('isOpen') == true) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AdminModePage();
                    },
                  );
                }
                else {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text("가게가 오픈되어 있지 않습니다.\n오픈하고 관리모드로 들어가시겠습니까?"),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        actions: [
                          TextButton(
                            child: Text("확인"), 
                            onPressed: () {
                              userinfo.info.storeRef.update({'isOpen' : true});
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AdminModePage();
                                },
                              );
                            }
                          ),
                          TextButton(
                            child: Text("취소"), 
                            onPressed: () {
                              Navigator.pop(context);
                            }
                          )
                        ]
                      );
                    }
                  );
                  
                }
              });
            }),
            Divider(thickness: 1,),
            ListElement(icon: Icon(Icons.exit_to_app, color: Colors.blue), title: "로그아웃", onTap: () async {
              await userinfo.signOut();
            }),
            Divider(thickness: 1,),
            // TODO: remove below codes when publishing
            IconButton(icon: Icon(Icons.android_rounded), onPressed: () {
              FirebaseFirestore.instance.collection('User').where('name', isEqualTo: '조병우').get().then((doc) {
                doc.docs[0]['storeRef'].update({"reservation" : FieldValue.arrayUnion([{
                  "table" : Random().nextInt(12),
                  "time" : DateTime.now(),
                  "userRef" : FirebaseFirestore.instance.collection('User').doc(userinfo.getUser().uid)
                }])});
              });
            }),
            Container(width: 100),
          ],
        ),
      ),
    );
  }
}
