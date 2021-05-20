import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/TimeLine.dart';

import 'Sections/TimeLineCard.dart';

class TimeLinePage extends StatefulWidget {
  static const id = "timeLine_page";
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class WidgetState {
  int category;
  List<TimeLineCard> list = [];
}

var random = new Random();
class _TimeLinePageState extends State<TimeLinePage> {
  WidgetState state = WidgetState();

  @override
  void initState() {
    super.initState();

    final widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      setState(() {
        state.category = (ModalRoute.of(context).settings.arguments as TimeLinePageArguments).category;  
      });
    });

    for (int i = 0; i < 10; ++i) {
      state.list.add(TimeLineCard(
        type: random.nextInt(2) + 1, 
        storeTitle: base64Encode(List<int>.generate(8, (index) => random.nextInt(100))),
        time: base64Encode(List<int>.generate(8, (index) => random.nextInt(100))),
        storeRate: random.nextDouble() * 10)
      );
    }
  }

  List<TimeLineCard> filterList({int category, String storeTitle, double maxStoreRate, double minStoreRate}) {
    List<TimeLineCard> filteredList = [];
    for (var element in state.list) {
      print(element.type);
      if (category != null && (element.type & category) != 0)
        filteredList.add(element);
      else if (storeTitle != null && element.storeTitle.indexOf(storeTitle) != -1)
        filteredList.add(element);
      else if (minStoreRate != null && maxStoreRate != null && element.storeRate >= minStoreRate && element.storeRate <= maxStoreRate)
        filteredList.add(element);
      else if (minStoreRate != null && element.storeRate >= minStoreRate)
        filteredList.add(element);
      else if (maxStoreRate != null && element.storeRate <= maxStoreRate)
        filteredList.add(element);
    }
    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('타임 라인'),
      ),
      body: Column(
        children: [
          SizedBox(height: 1,),
          Container(
            child: Row(
              children: [
                Material(
                  shape: Border(bottom: BorderSide(color: (state.category & 1) != 0? Colors.grey : Colors.transparent)),
                  child: SizedBox(
                    width: 100,
                    child: TextButton(
                      child: Text('리뷰'), 
                      onPressed: () { 
                        setState(() { state.category ^= 1; }); 
                      },
                    ),
                  ),
                ),
                Material(
                  shape: Border(bottom: BorderSide(color: (state.category & 2) != 0? Colors.grey : Colors.transparent)),
                  child: SizedBox(
                    width: 100,
                    child: TextButton(
                      child: Text('방문'), 
                      onPressed: () { 
                        setState(() { state.category ^= 2; }); 
                      },
                    ),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
          Divider(thickness: 1,),
          Container(
            child: Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: filterList(category: state.category),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
