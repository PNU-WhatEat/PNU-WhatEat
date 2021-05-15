import 'package:flutter/material.dart';
import 'package:what_eat/screens/DetailPage.dart';
import 'package:what_eat/screens/MyInfoPage/MyInfoPage.dart';
//import 'package:what_eat/screens';
import 'package:what_eat/screens/ReviewPage.dart';
import 'MyInfoPage/MyInfoPage.dart';
import 'MyInfoPage/MyInfoPage.dart';

class MainPage extends StatefulWidget {
  static const id = 'main_page';
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _children = [MainPage(), ReviewPage(), DetailPage(), MyInfoPage()];

  void _onTap(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final pageController = PageController();

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

        // body: PageView(
        //   controller: pageController,
        //   onPageChanged: onPageChanged,
        //   children: _children,
        // ),


        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: _onTap,
            currentIndex: _currentIndex,
            items: [
              new BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  label:'즐겨찾기'
              ),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label:'내 정보'
              )
            ]
        )
    );
  }
}
