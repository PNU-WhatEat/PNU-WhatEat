import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/UserInformation.dart';
import 'SignUpPage.dart';

class SignInPage extends StatefulWidget {
  static const id = 'emailLogin_page';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserInformation userinfo;

  Widget build(BuildContext context) {
    userinfo = Provider.of<UserInformation>(context);
    emailController.text = "whquddn55@gmail.com";
    passwordController.text = "test123";
    return Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
        
      ),
      body:
        ListView(children: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          border: OutlineInputBorder(),
                          hintText: "이메일",
                        ),
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                          hintText: "비밀번호",
                        ),
                      ),
                    ].map((w) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: w,
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: OutlinedButton(
                    child: Text(
                      "로그인",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode()); // 키보드 감춤
                      _signIn();
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.only(top: 50),
                  child: Text("아직도 가입하시지 않으셨나요?")
                ),
                OutlinedButton(
                  child: Text(
                    "회원가입",
                    style: TextStyle(color: Colors.blue,),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                )
              ],
            ),
          ),
        ],
      )
    );
  }

  void _signIn() async {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("   Signing-In...")
          ],
        ),
      ));
    bool result = await userinfo.signInWithEmail(emailController.text, passwordController.text);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (result == false) showLastFBMessage();
    else Navigator.pop(context);
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

