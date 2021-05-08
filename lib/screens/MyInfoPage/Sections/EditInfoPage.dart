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
  void initState() {
    super.initState();

    final widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      setState(() {
        state.name = (ModalRoute.of(context).settings.arguments as EditInfoPageArgs).name;
        state.email = (ModalRoute.of(context).settings.arguments as EditInfoPageArgs).email;
        state.phoneNumber = (ModalRoute.of(context).settings.arguments as EditInfoPageArgs).phoneNumber;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
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
    
    if ((result as ReturnValue).success) {
      if ((result as ReturnValue).message == '이름')
        setState(() {
          state.name = (result as ReturnValue).value;
        });
      else if ((result as ReturnValue).message == '이메일')
        setState(() {
          state.name = (result as ReturnValue).value;
        });
      else if ((result as ReturnValue).message == '비밀번호')
        setState(() {
          state.name = (result as ReturnValue).value;
        });
      else {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
              content: Text('Exception: Error on return message')
          ));
      }
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
