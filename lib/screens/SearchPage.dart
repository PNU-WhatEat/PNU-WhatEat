import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);
  static const id = 'search_page';
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _filter = TextEditingController(); //검색 위젯을 컨트롤하는 위젯
  FocusNode focusNode = FocusNode(); // 현재 검색 위젯에 커서가 있는지에 대한 상태 등을 가지는 위젯
  String _searchText = "";

  _SearchPageState(){
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  @override
  Widget build(BuildContext context){ // 검색창
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
              padding:EdgeInsets.all(30)),
          Container(
            color: Colors.blue,
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: TextField(focusNode: focusNode,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  autofocus: true,
                  controller: _filter,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white60,
                          size:20,
                      ),
                        suffixIcon: focusNode.hasFocus ? IconButton(
                            icon: Icon(
                                Icons.cancel,
                                size: 20,
                            ),
                            onPressed: (){
                              setState(() {
                                _filter.clear();
                                _searchText = "";
                              });
                            },
                    )
                            :Container(),
                      hintText: '식당 이름을 입력하세요',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  ),
                focusNode.hasFocus
                    ? Expanded(
                      child: TextButton(
                        child: Text('취소'),
                        onPressed: (){
                          setState(() {
                            _filter.clear();
                            _searchText = "";
                            focusNode.unfocus();
                          });
                        },
                      ),
                )
                    : Expanded(
                  flex:0,
                  child: Container(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  }







//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton:
//         FloatingActionButton(child:  Icon(Icons.clear), onPressed: () {}),
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         actions: [IconButton(icon: Icon(Icons.search), onPressed: (){})],
//         title: TextField(
//           style: TextStyle(color: Colors.black),
//           decoration: InputDecoration(
//             hintText: '식당 이름을 입력하세요',
//             hintStyle: TextStyle(color: Colors.black)),
//           ),
//         ),
//     );
//   }
// }
