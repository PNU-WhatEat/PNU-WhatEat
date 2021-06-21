import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:what_eat/screens/DetailPage.dart';

final _store = FirebaseFirestore.instance;

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);
  static const id = 'search_page';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _filter =
  TextEditingController(); //검색 위젯을 컨트롤하는 위젯
  FocusNode focusNode = FocusNode(); // 현재 검색 위젯에 커서가 있는지에 대한 상태 등을 가지는 위젯
  String _searchText = "";
  List<String> searchList = [];

  _SearchPageState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 검색창
    return StreamBuilder<QuerySnapshot>(
      stream: _store.collection('St_temp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final List<dynamic> restaurantList = snapshot.data.docs
            .map((data) => (data.data() as Map)['title'])
            .toList();
        return SafeArea(
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (val) {
                            if (val == "") {
                              searchList.clear();
                            } else {
                              searchList.clear();
                              for (var i = 0;
                              i < restaurantList.length;
                              ++i) {
                                if (restaurantList[i].contains(val)) {
                                  setState(() {
                                    searchList.add(restaurantList[i]);
                                  });
                                }
                              }
                            }
                          },
                          focusNode: focusNode,
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
                              size: 20,
                            ),
                            suffixIcon: focusNode.hasFocus
                                ? IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _filter.clear();
                                  _searchText = "";
                                  focusNode.unfocus();
                                });
                              },
                            )
                                : Container(),
                            hintText: '식당 이름을 입력하세요',
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.transparent),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.transparent),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.transparent),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: searchList.length != 0,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: ListTile(
                        title: Text(searchList[index]),
                      ),
                      onTap: () async {
                        final data = (await _store.collection('St_temp').doc(
                            (await _store.collection('St_temp').where(
                                'title', isEqualTo: searchList[index])
                                .limit(1)
                                .get()).docs[0].id).get()).data();
                        Navigator.pushNamed(context, DetailPage.id, arguments: data);
                      },
                    );
                  },
                  itemCount: searchList.length,
                  shrinkWrap: true,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}