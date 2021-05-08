import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import 'MyInfoPage/MyInfoPage.dart';

class LoginPage extends StatefulWidget {
  static const id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/loginImage.gif'), fit: BoxFit.cover)
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SignInButton(Buttons.Google,
                onPressed: () {
                  // Todo : login
                  Navigator.pushReplacementNamed(context, MyInfoPage.id);
                },
              ),
              SizedBox(height: 30),
              SignInButton(Buttons.Email, 
                onPressed: () {
                  // Todo : login
                  Navigator.pushReplacementNamed(context, MyInfoPage.id);
                },
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
