import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/screens/LoginPage/Sections/SignInPage.dart';
import 'package:what_eat/UserInformation.dart';

class LandingPage extends StatelessWidget {
  static const id = 'login_page';
  @override
  Widget build(BuildContext context) {
    UserInformation userinfo = Provider.of<UserInformation>(context);
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
                onPressed: () async {
                  bool result = await userinfo.signInWithGoogleAccount();
                  if (result == false) {
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
                },
              ),
              SizedBox(height: 30),
              SignInButton(Buttons.Email, 
                onPressed: () {
                  Navigator.pushNamed(context, SignInPage.id);
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
