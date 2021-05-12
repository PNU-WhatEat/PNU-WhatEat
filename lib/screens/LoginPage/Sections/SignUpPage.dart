import 'package:flutter/material.dart';
import 'package:what_eat/UserInformation.dart';
import 'package:provider/provider.dart';

SignUpPageState pageState;

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() {
    pageState = SignUpPageState();
    return pageState;
  }
}

class SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserProvider userinfo;

  @override
  Widget build(BuildContext context) {
    if (userinfo == null) {
      userinfo = Provider.of<UserProvider>(context);
    }

    return Scaffold(
        appBar: AppBar(title: Text("회원가입")),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                children: [
                  // Input Area
                  Container(
                    child: Column(
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: "이름",
                          ),
                        ),
                        TextField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone_android),
                            hintText: "전화번호",
                          ),
                        ),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            hintText: "이메일",
                          ),
                        ),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "비밀번호",
                          ),
                          obscureText: true,
                        ),

                      ].map((c) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: c,
                        );
                      }).toList(),
                    ),
                  ),

                  // Sign Up Button
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: OutlinedButton(
                      child: Text(
                        "회원가입",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        FocusScope.of(context)
                            .requestFocus(new FocusNode()); // 키보드 감춤
                        _signUp();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void _signUp() async {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("   Signing-Up...")
          ],
        ),
      ));
    bool result = await userinfo.signUpWithEmail(emailController.text, passwordController.text);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (result) {
      Navigator.pop(context);
    } else {
      showLastFBMessage();
    }
  }

  showLastFBMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 10),
        content: Text(userinfo.getLastFBMessage()),
        action: SnackBarAction(
          label: "Done",
          textColor: Colors.white,
          onPressed: () {},
        ),
      ));
  }
}