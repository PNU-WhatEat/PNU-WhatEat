import 'package:flutter/material.dart';
import 'package:what_eat/screens/MyInfoPage/Sections/TimeLine.dart';

class TimeLinePage extends StatefulWidget {
  static const id = "timeLine_page";
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class WidgetState {
  int category;
}

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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('타임 라인'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 5,),
          Row(
            children: [
              TextButton(
                child: Text('리뷰'), 
                onPressed: () { 
                  setState(() { state.category ^= 1; }); 
                },
                style: (state.category & 1) == 0 ? 
                  TextButton.styleFrom(minimumSize: Size(100, 60), side: BorderSide(color: Colors.grey, width: 3)) : 
                  TextButton.styleFrom(minimumSize: Size(100, 60)),
              ),
              TextButton(
                child: Text('방문'), 
                onPressed: () { 
                  setState(() { state.category ^= 2; }); 
                },
                style: (state.category & 2) == 0 ? 
                  TextButton.styleFrom(minimumSize: Size(100, 60), side: BorderSide(color: Colors.grey, width: 3)) : 
                  TextButton.styleFrom(minimumSize: Size(100, 60)),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          Divider(thickness: 1,),
          //widget.category == 0 ? ReviewList() : VisitedList();
        ],
      ),
    );
  }
}
