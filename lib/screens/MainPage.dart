import 'package:flutter/material.dart';
import 'package:what_eat/screens/DetailPage.dart';

class MainPage extends StatelessWidget {
  static const id = 'main_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, DetailPage.id);
            },
            child: Text(
              "Go to detail page",
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.close,
            ),
            label: "Hello",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.close,
            ),
            label: "Hello",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.close,
            ),
            label: "Hello",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.close,
            ),
            label: "Hello",
          ),
        ],
      ),
    );
  }
}
