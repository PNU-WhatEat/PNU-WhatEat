import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/UserInformation.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/EditInfoPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    final EditPageArgs args = ModalRoute.of(context).settings.arguments;
    UserInformation userinfo = Provider.of<UserInformation>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(args.title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),    
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
                        (args.message.compareTo("비밀번호") == 0 ? true : false),
                    onChanged: (text) {
                      if (text.isEmpty)
                        setState(() => {isButtonEnable = null});
                      else
                        setState(() => {isButtonEnable = () {
                          if (args.message.compareTo("이름") == 0) {
                            userinfo.setName(controller.text).then((_) {
                              Navigator.pop(context, true);
                            }).catchError((_) {
                              Navigator.pop(context, false);
                            });
                          }
                          else if (args.message.compareTo("전화번호") == 0) {
                            userinfo.setPhoneNumber(controller.text).then((_) {
                              Navigator.pop(context, true);
                            }).catchError((_) {
                              Navigator.pop(context, false);
                            });
                          }
                        }});
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
          ));
  }
}
