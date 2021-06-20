import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/UserInformation.dart';

class ManageStoreInfoPage extends StatefulWidget {
  static const id = "manageStoreInfo_page";

  @override
  _ManageStoreInfoPageState createState() => _ManageStoreInfoPageState();
}

class _ManageStoreInfoPageState extends State<ManageStoreInfoPage> {
  UserInformation userinfo;
  Map<String, dynamic> storeInfo;

  Widget getEditWidget({String key, String title, String initValue}) {
    TextEditingController controller = TextEditingController(text: initValue);
    TextInputType keyType = TextInputType.name;
    if (key == 'contact')
      keyType = TextInputType.phone;
    if (key == 'openHour') // TODO: solve issue that how to express openHour field
      return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(title, style: TextStyle(fontSize: 30))
        ),
        Row(
          children: [
            Flexible(
              child: Container(
                height: 50,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  keyboardType: keyType,
                )
              )
            ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: ElevatedButton(
                child: Text('수정'), 
                onPressed: () {
                  userinfo.info.storeRef.update({key: controller.text}).then((_) {
                    _showSnackBar(context);
                  });
                  FocusScope.of(context).unfocus();
                  setState(() {
                    storeInfo[key] = controller.text;
                  });
                },
              ),
            )
          ],
        )
      ],
    );
  }

  _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text('수정 완료'),
          duration: Duration(seconds: 1),
      ));
  }

  @override
    void initState() {
      super.initState();
      userinfo = Provider.of<UserInformation>(context, listen: false);
      userinfo.info.storeRef.get().then((doc) {
        setState(() {
          storeInfo = doc.data();
        });
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('테이블 관리')),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            getEditWidget(key: 'title', title: '이름', initValue: storeInfo == null ? '' : storeInfo['title']),
            getEditWidget(key: 'category', title: '카테고리', initValue: storeInfo == null ? '' : storeInfo['category']),
            getEditWidget(key: 'address', title: '주소', initValue: storeInfo == null ? '' : storeInfo['address']),
            getEditWidget(key: 'openHour', title: '오픈시간', initValue: storeInfo == null ? '' : storeInfo['openHour']),
            getEditWidget(key: 'contact', title: '전화번호', initValue: storeInfo == null ? '' : storeInfo['contact']),
          ]
        ),
      )
    );
  }
}

