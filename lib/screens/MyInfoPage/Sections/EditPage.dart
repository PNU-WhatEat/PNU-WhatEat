import 'package:flutter/material.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/EditInfoPage.dart';
import 'ListElement.dart';

class EditPage extends StatelessWidget {
  static const id = "edit_Page";
  @override
  Widget build(BuildContext context) {
    final EditPageArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          }, 
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: args.message,
              ),
              obscureText: (args.message.compareTo("비밀 번호") == 0 ? true : false),
            )
          ),
          ElevatedButton(
            child: Text('확인'),
            onPressed: () {
              // Todo: 서버에 정보수정 요청
              Navigator.pop(context, true); // 정보수정이 됐으면 true 반환 else 재수정 요청
            },
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }
}
