import 'package:flutter/material.dart';
import 'ListElement.dart';
import 'EditPage.dart';

class EditInfoPage extends StatelessWidget {
  static const id = "editInfo_Page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보 수정'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column( children: [
        Center ( child:
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            icon: Icon(
              Icons.account_circle_rounded, 
              color: Colors.blue
            ),
            iconSize: 80
          ),
        ),
        Divider(thickness: 10,),
        ListElement(title: "이름", value: "홍길동", onTap: () { Navigator.pushNamed(context, EditPage.id); }), // dummy
        Divider(thickness: 1,),
        ListElement(title: "이메일", value: "whquddn55@gmail.com"), // dummy
        Divider(thickness: 1,),
        ListElement(title: "전화번호", value: "01077087809"), // dummy
        Divider(thickness: 1,)
      ],
      ),
    );
  }
}
