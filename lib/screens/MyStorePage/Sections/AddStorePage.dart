import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStorePage extends StatefulWidget {
  static const id = "addStore_page";

  @override
  _AddStorePageState createState() => _AddStorePageState();
}

class _Store {
  final String title;
  final String address;
  final String docId;

  _Store({this.title, this.address, this.docId});
}

class _AddStorePageState extends State<AddStorePage> {
  TextEditingController controller = TextEditingController();
  List<_Store> storeList = [];

  List<Widget> renderList() {
    List<Widget> result = [];
    for (var element in storeList)
      result.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10.0)),
          height: 80,
          child: InkWell(
            child: Column(
              children: [
                Text(element.title, style: TextStyle(
                  fontSize: 20,
                )),
                Text(element.address, style: TextStyle(
                  fontSize: 10,
                )),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("가게 추가"),
                    content: Text("\'${element.title}\'을 가게로\n소유하시겠습니까?"),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    actions: [
                      TextButton(
                        child: Text("확인"), 
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context, element.docId);
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
          ),
        )
    );
    return result;
  }

  void searchPressed() {
    FirebaseFirestore.instance.collection('St_temp').where('title', isGreaterThanOrEqualTo: controller.text, isLessThan: controller.text + '\uf8ff').get().then((results) {
      setState(() {
        storeList = [];
        for (var result in results.docs)
          storeList.add(_Store(
            title: result['title'],
            address: result['address'],
            docId: result.id,
          ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('가게 추가')),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    height: 50,
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '가게 이름'
                      ),
                      onSubmitted: (value) {
                        searchPressed();
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
                  height: 50,
                  child: ElevatedButton(
                    child: Text("검색"),
                    onPressed: searchPressed,
                  ),
                )
              ],
            ),
            Flexible(
              child: ListView(
                children: renderList(),
              ),
            )
          ],
        ),
      )
    );
  }
}