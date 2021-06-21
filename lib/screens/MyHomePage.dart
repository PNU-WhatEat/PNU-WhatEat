import 'package:flutter/material.dart';

import 'MainPage/MainPage.dart';
import 'MyInfoPage/MyInfoPage.dart';
import 'SearchPage.dart';
//아이콘을 누르면 이동할 page를 import

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _children = [MainPage(), SearchPage(), SearchPage(), MyInfoPage()];
  // 위에 이동할 page 차례대로 입력
  int _currentIndex = 0;

  final pageController = PageController();

  void onTabClickHandle(int _index) {
    print('onTabClickHandle $_index');
    pageController.jumpToPage(_index);
  }

  void onPageChangeHandler(int _index) {
    print('onPageChangeHandler $_index');
    setState(() {
      _currentIndex = _index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChangeHandler,
          children: _children,
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: onTabClickHandle,
            currentIndex: _currentIndex,
            items: [
              new BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: "Favorite",
              ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "내정보",
              )
            ])
    );
  }
}
