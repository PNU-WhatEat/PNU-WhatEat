import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/UserInformation.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/ListElement.dart';

class MyStorePage extends StatefulWidget {
  static const id = "mystore_page";

  @override
  _MyStorePageState createState() => _MyStorePageState();
}

class Store {
    final String title;
    final double rate;
    final int reviews;
    bool isOpen;

    Store({this.title, this.rate, this.reviews, this.isOpen});
}

class _MyStorePageState extends State<MyStorePage> {
  Store store;
  UserInformation userInfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userInfo = Provider.of<UserInformation>(context, listen: false);
    if (userInfo.info.storeRef != null)
      print(userInfo.info.storeRef);
      userInfo.info.storeRef.get().then((value) {
        setState(() {
          store = Store(title: value['title'], rate: 0, reviews: 0, isOpen: true);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    print(store);
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(store.title, style : Theme.of(context).textTheme.headline4),
                        Text('평점 : ${store.rate.toString()}', style : Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                    Text(store.isOpen ? '영업 중' : '영업 종료', style: TextStyle(color: store.isOpen ? Colors.blue : Colors.red)),
                ]),
                Text('리뷰 수 : ${store.reviews}'),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('테이블 관리'),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ],
                  ),
                  onTap: () {

                  }
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('메뉴 관리'),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ],
                  ),
                  onTap: () {
                    
                  }
                ),
                InkWell(
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
            ],)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(icon: Icon(Icons.delete, color: Colors.red), label: Text('가게 삭제', style: TextStyle(color: Colors.red)))
            ],
          )
        ],
      ) : 
      Container(
        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
        child: TextButton.icon(icon: Icon(Icons.add), label: Text("가게 추가"), onPressed: () async {
          DocumentReference storeRef = FirebaseFirestore.instance.collection('St_temp').doc('1pRjEFVCcTOtFmfpw2uB');
          userInfo.setStore(storeRef);
        }),
      )
    );
  }
}