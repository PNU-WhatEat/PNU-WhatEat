import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:what_eat/screens/LoginPage/Sections/EmailLoginPage.dart';

import '../MyInfoPage/MyInfoPage.dart';

class LoginPage extends StatelessWidget {
  static const id = 'login_page';
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
                  Navigator.pushNamed(context, EmailLoginPage.id);
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
