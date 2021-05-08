import 'package:flutter/material.dart';
import 'ListElement.dart';
import 'EditPage.dart';
import 'MyMainInfo.dart';

class EditPageArgs {
  final String title;
  final String message;

  EditPageArgs({this.title, this.message});
}

class EditInfoPage extends StatefulWidget {
  static const id = "editInfo_Page";

  @override
  _EditInfoPageState createState() => _EditInfoPageState();
}

class WidgetState {
  String name;
  String email;
  String phoneNumber;

  WidgetState({this.name, this.email, this.phoneNumber});
}

class _EditInfoPageState extends State<EditInfoPage> {
  WidgetState state = WidgetState();
  @override
  Widget build(BuildContext context) {
    final EditInfoPageArgs args = ModalRoute.of(context).settings.arguments;
    setState(() {
      state.name = args.name;
      state.email = args.email;
      state.phoneNumber = args.phoneNumber;
    });
    return Scaffold(
        appBar: AppBar(
          title: Text('내 정보 수정'),
        ),
        body: Builder(builder: (BuildContext ctx) {
          return Column(
            children: [
              Center(
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    icon:
                        Icon(Icons.account_circle_rounded, color: Colors.blue),
                    iconSize: 80),
              ),
              Divider(
                thickness: 10,
              ),
              ListElement(
                  title: "이름",
                  value: state.name,
                  onTap: () {
                    _navigateAndDisplaySelection(
                      ctx,
                      EditPageArgs(
                          title : '이름 변경',
                          message : '이름'
                      )
                    );
                  }),
              Divider(
                thickness: 1,
              ),
              ListElement(
                  title: "이메일",
                  value: state.email,
                  onTap: () {
                    _navigateAndDisplaySelection(
                      ctx,
                      EditPageArgs(
                          title : '이메일 변경',
                          message : '이메일'
                      )
                    );
                  }),
              Divider(
                thickness: 1,
              ),
              ListElement(
                  title: "전화번호",
                  value: state.phoneNumber,
                  onTap: () {
                    _navigateAndDisplaySelection(
                      ctx,
                      EditPageArgs(
                          title : '전화번호 변경',
                          message : '전화번호'
                      )
                    );
                  }),
              Divider(
                thickness: 1,
              ),
              ListElement(
                  title: "비밀번호",
                  onTap: () {
                    _navigateAndDisplaySelection(
                      ctx,
                      EditPageArgs(
                          title : '비밀번호 변경',
                          message : '비밀번호'
                      )
                    );
                  }),
              Divider(
                thickness: 1,
              )
            ],
          );
        }));
  }

  _navigateAndDisplaySelection(BuildContext context, EditPageArgs arguments) async {
    final result = await Navigator.pushNamed(context, EditPage.id, arguments: arguments);
    
    if (result.toString() == 'true') {
      Navigator.pop(context);
    }
    else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
            content: Text('Exception: Error')
        ));
    }
  }
}
