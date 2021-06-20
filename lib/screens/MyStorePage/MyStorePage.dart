import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/UserInformation.dart';
import 'package:what_eat/screens/MyStorePage/Sections/ManageMenuPage.dart';
import 'package:what_eat/screens/MyStorePage/Sections/ManageStoreInfoPage.dart';
import 'package:what_eat/screens/MyStorePage/Sections/ManageTablePage.dart';

import 'Sections/AddStorePage.dart';

class MyStorePage extends StatefulWidget {
  static const id = "mystore_page";

  @override
  _MyStorePageState createState() => _MyStorePageState();
}

class _Store {
  final String title;
  double rate;
  int reviews;
  bool isOpen;

  _Store({this.title, this.rate, this.reviews, this.isOpen}) {
    rate = (rate == null? 0 : rate);
    reviews = (reviews == null? 0 : reviews);
    isOpen = (isOpen == null? false : isOpen);
  }
}

class _MyStorePageState extends State<MyStorePage> {
  _Store store;
  UserInformation userinfo;

  @override
    void initState() {
      super.initState();
      userinfo = Provider.of<UserInformation>(context, listen: false);
      if (userinfo.info.storeRef != null) {
        userinfo.info.storeRef.get().then((doc) {
          Map<String, dynamic> result = doc.data();
          setState(() {
            store = _Store(title: result['title'], rate: result['rate'], reviews: result['reviews'], isOpen: result['isOpen']);
          });
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('내 가게 관리')),
      body: store != null ? 
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(border: Border.all(width: 1.0), borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(store.title, style : TextStyle(fontSize: 20, color:store.isOpen ? Colors.blue : Colors.grey)),
                      Text(store.isOpen ? '영업 중' : '영업 종료', style: TextStyle(color: store.isOpen ? Colors.blue : Colors.red)),
                  ]),
                  Text('평점 : ${store.rate.toString()}'),
                  Text('리뷰 수 : ${store.reviews}'),
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('테이블 관리'),
                          Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, ManageTablePage.id);
                      }
                    ),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('메뉴 관리'),
                          Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, ManageMenuPage.id);
                      }
                    ),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('리뷰 관리'),
                          Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        ],
                      ),
                      onTap: () {
                        
                      }
                    ),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('기타 정보 관리'),
                          Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, ManageStoreInfoPage.id).then((_) {
                          userinfo.info.storeRef.get().then((doc) {
                            Map<String, dynamic> result = doc.data();
                            setState(() {
                              store = _Store(title: result['title'], rate: result['rate'], reviews: result['reviews'], isOpen: result['isOpen']);
                            });
                          });
                        });
                      }
                    ),
                  ),
              ],)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(icon: Icon(Icons.delete, color: Colors.red), label: Text('가게 삭제', style: TextStyle(color: Colors.red)), onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("가게 삭제"),
                        content: Text("정말로 소유 가게를 삭제하시겠습니까?\n가게 정보는 계속 유지되나\n가게 정보 수정과 예약 수락이 불가능합니다."),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        actions: [
                          TextButton(
                            child: Text("확인"), 
                            onPressed: () {
                              userinfo.setStore(null);
                              setState(() {
                                store = null;                       
                              });
                              Navigator.pop(context);
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
                })
              ],
            )
          ],
        ) : 
        Container(
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
          child: TextButton.icon(icon: Icon(Icons.add), label: Text("가게 추가"), onPressed: () {
            Navigator.pushNamed(context, AddStorePage.id).then((result) {
              if (result != null) {
                DocumentReference storeRef = FirebaseFirestore.instance.collection('St_temp').doc(result);
                userinfo.setStore(storeRef);
                  storeRef.get().then((doc) {
                    Map<String, dynamic> result = doc.data();
                    if (result['rate'] == null)
                      storeRef.update({'rate' : 0.0});
                    if (result['reviews'] == null)
                      storeRef.update({'reviews' : 0});
                    if (result['isOpen'] == null)
                      storeRef.update({'isOpen' : false});
                    setState(() {
                      store = _Store(
                        title: result['title'],
                        rate: result['rate'],
                        reviews: result['reviews'],
                        isOpen: result['isOpen']
                      );
                    });
                    
                  });
              }
            });
          }),
        )
    );
  }
}