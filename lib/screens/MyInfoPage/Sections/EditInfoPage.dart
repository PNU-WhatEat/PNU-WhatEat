import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/UserInformation.dart';
import 'ListElement.dart';
import 'EditPage.dart';

class EditPageArgs {
  final String title;
  final String message;

  EditPageArgs({this.title, this.message});
}

class EditInfoPage extends StatelessWidget {
  static const id = "editInfo_Page";
  
  @override
  Widget build(BuildContext context) {
    UserInformation userinfo = Provider.of<UserInformation>(context);
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
                  value: userinfo.info.name,
                  onTap: () {
                    _navigateAndDisplaySelection(
                      ctx,
                      EditPageArgs(
                          title : '이름 변경',
                          message : '이름',
                      )
                    );
                  }),
              Divider(
                thickness: 1,
              ),
              ListElement(
                  title: "이메일",
                  value: userinfo.info.email,
                  onTap: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text("구현중인 기능입니다."), duration: Duration(seconds: 1)));
                  }),
              Divider(
                thickness: 1,
              ),
              ListElement(
                  title: "전화번호",
                  value: userinfo.info.phoneNumber,
                  onTap: () {
                    _navigateAndDisplaySelection(
                      ctx,
                      EditPageArgs(
                          title : '전화번호 변경',
                          message : '전화번호',
                      )
                    );
                  }),
              Divider(
                thickness: 1,
              ),
              ListElement(
                  title: "비밀번호 재설정",
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("비밀번호 재설정"),
                          content: Text("비밀번호 재설정 이메일을 보내고\n로그아웃합니다."),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          actions: [
                            TextButton(
                              child: Text("확인"), 
                              onPressed: () {
                                userinfo.sendPasswordResetEmail();
                                userinfo.signOut();
                                Navigator.pop(context);
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
                    });
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

    if (result == false) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
            content: Text('Exception: Error')
        ));
    }
  }
}
