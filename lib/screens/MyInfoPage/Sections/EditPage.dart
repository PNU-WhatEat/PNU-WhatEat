import 'package:flutter/material.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/EditInfoPage.dart';
import 'ListElement.dart';

class EditPage extends StatefulWidget {
  static const id = "edit_Page";

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController controller = TextEditingController();
  Function isButtonEnable;
  
  @override
  Widget build(BuildContext context) {
    final EditPageArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(args.title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Form(
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: args.message,
                      ),
                      obscureText:
                          (args.message.compareTo("비밀 번호") == 0 ? true : false),
                      onChanged: (text) {
                        if (text.isEmpty)
                          setState(() => {isButtonEnable = null});
                        else
                          setState(() => {isButtonEnable = () {
                            // Todo: 서버에 정보수정 요청
                            Navigator.pop(context, true); // 정보수정이 됐으면 true 반환 else 재수정 요청
                          }});
                        print(text);
                      },
                    ),
                    ElevatedButton(
                      child: Text('확인'),
                      onPressed: isButtonEnable,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                ),
              ),
            )));
  }
}
