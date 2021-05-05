import 'package:flutter/material.dart';
import 'ListElement.dart';
import 'EditPage.dart';

class EditPageArguments {
  final String title;
  final String message;

  EditPageArguments(this.title, this.message);
}

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
        ListElement(title: "이름", value: "홍길동", onTap: () { _navigateAndDisplaySelection(context, EditPageArguments(
          '이름 변경',
          '이름'
        )); }), // dummy
        Divider(thickness: 1,),
        ListElement(title: "이메일", value: "whquddn55@gmail.com", onTap: () { _navigateAndDisplaySelection(context, EditPageArguments(
          '이메일 변경',
          '이메일'
        )); }), // dummy
        Divider(thickness: 1,),
        ListElement(title: "전화번호", value: "01077087809", onTap: () { _navigateAndDisplaySelection(context, EditPageArguments(
          '전화번호 변경',
          '전화번호'
        )); }), // dummy
        Divider(thickness: 1,),
        ListElement(title: "비밀번호", onTap: () { _navigateAndDisplaySelection(context, EditPageArguments(
          '비밀번호 변경',
          '비밀번호'
        )); }), // dummy
        Divider(thickness: 1,)
      ],
      ),
    );
  }

  _navigateAndDisplaySelection(BuildContext context, EditPageArguments arguments) async {
    final result = await Navigator.pushNamed(context, EditPage.id, arguments: arguments);
    // 
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.toString())));
  }
}
