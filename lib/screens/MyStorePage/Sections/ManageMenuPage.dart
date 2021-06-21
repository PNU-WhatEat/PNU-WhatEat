import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/UserInformation.dart';

class ManageMenuPage extends StatefulWidget {
  static const id = "managemenu_page";

  @override
  _ManageMenuPageState createState() => _ManageMenuPageState();
}

class _ManageMenuPageState extends State<ManageMenuPage> {
  TextEditingController menuController = TextEditingController(), priceController = TextEditingController();
  List<Map<String, dynamic>> menuList = [];
  bool addButtonEnable = false;
  UserInformation userinfo;

  List<Widget> renderList() {
    List<Widget> result = [];
    for (int i = 0; i < menuList.length; ++i) {
      result.add(
        Container(
          key: ValueKey(i),
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10.0)),
          height: 80,
          child: Row(
            children: [
              Column(
                children: [
                  Text('$i. ${menuList[i]['name']}', style: TextStyle(
                    fontSize: 20,
                  )),
                  Text('${menuList[i]['price']}원', style: TextStyle(
                    fontSize: 10,
                  )),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.delete), 
                label: Text('삭제'),
                style : ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                onPressed: () {
                  print(i);
                  setState(() {
                    menuList.removeAt(i);
                  });
                  userinfo.info.storeRef.update({'menu' : menuList});
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      );
    }
    return result;
  }

  void reorderData(int oldindex, int newindex){
    setState(() {
      if(newindex>oldindex){
        newindex-=1;
      }
      final items = menuList.removeAt(oldindex);
      menuList.insert(newindex, items);
    });
    userinfo.info.storeRef.update({'menu': menuList});
  }

  @override
  void initState() {
    userinfo = Provider.of<UserInformation>(context, listen: false);
    userinfo.info.storeRef.get().then((doc) {
      Map<String, dynamic> result = doc.data();
      if (result['menu'] != null) {
        setState(() {
          menuList = (result['menu'] as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
        });
        
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메뉴 관리')),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      height: 50,
                      child: TextField(
                        controller: menuController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '메뉴 이름'
                        ),
                        onChanged: (_) {
                          if (menuController.text != '' && priceController.text != '')
                            setState(() {
                              addButtonEnable = true;
                            });
                          else
                            setState(() {
                              addButtonEnable = false;
                            });
                        }
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 7),
                      height: 50,
                      child: TextField(
                        controller: priceController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '가격'
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (_) {
                          if (menuController.text != '' && priceController.text != '')
                            setState(() {
                              addButtonEnable = true;
                            });
                          else
                            setState(() {
                              addButtonEnable = false;
                            });
                        }
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: ElevatedButton(
                      child: Text("추가"),
                      onPressed: !addButtonEnable ? null : () {
                        setState(() {
                          menuList.add({'name' : menuController.text, 'price' : priceController.text});
                        });
                        userinfo.info.storeRef.update({'menu': menuList});
                        menuController.clear();
                        priceController.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            ),
            Flexible(
              child: ReorderableListView(
                children: renderList(),
                onReorder: reorderData,
              )
            )
          ],
        ),
      )
    );
  }
}