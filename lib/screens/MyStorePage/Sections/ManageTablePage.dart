import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:what_eat/UserInformation.dart';

class ManageTablePage extends StatefulWidget {
  static const id = "manageTable_page";

  @override
  _ManageTablePageState createState() => _ManageTablePageState();
}

class _TableState {
  bool enabled;
  int currentNumber;

  _TableState({this.enabled, this.currentNumber});
}

class _ManageTablePageState extends State<ManageTablePage> {
  List<TextEditingController> controllerList = [];
  List<_TableState> tableStateList = [];
  List<Function> buttonFunctionList = List<Function>.filled(12, null);
  UserInformation userinfo;

  renderList() {
    List<Widget> tableElementList = [];
    for (int i = 0; i < 12; ++i) {
      tableElementList.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 3.0),
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10.0)),
          height: 60,
          child: Row(
            children: [
              Text('${i+1} 인', style: TextStyle(
                fontSize: 20,
                color: tableStateList[i].enabled ? Colors.blue : Colors.grey
              )),
              Row(
                children: [
                  Text('${tableStateList[i].currentNumber}', 
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  Container(
                    height: 30,
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: TextField(
                      controller: controllerList[i],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(2)
                      ],
                      onChanged: (_) {
                        setState(() {
                          if (controllerList[i].text == '' || tableStateList[i].currentNumber == int.parse(controllerList[i].text))
                            buttonFunctionList[i] = null;
                          else
                            buttonFunctionList[i] = () {
                              setState(() {
                                tableStateList[i].currentNumber = int.parse(controllerList[i].text);
                                if (tableStateList[i].currentNumber != 0)
                                  tableStateList[i].enabled = true;
                                else
                                  tableStateList[i].enabled = false;
                                buttonFunctionList[i] = null;
                              });
                              FocusScope.of(context).unfocus();
                              List<int> updateList = [];
                              for (int i = 0; i < 12; ++i)
                                updateList.add(tableStateList[i].currentNumber);
                              userinfo.info.storeRef.update({'table' : updateList});
                            };
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 30,
                    child: ElevatedButton(
                      child: Text("저장"),
                      onPressed: buttonFunctionList[i],
                    ),
                  )
                ],
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        )
      );
    }
    return tableElementList;
  }

  @override
    void initState() {
      super.initState();
      userinfo = Provider.of<UserInformation>(context, listen: false);
      userinfo.info.storeRef.get().then((doc) {
        Map<String, dynamic> result = doc.data();
        if (result['table'] != null){
          for (int i = 0; i < 12; ++i) 
            setState(() {
              controllerList.add(TextEditingController(text: result['table'][i].toString()));
              tableStateList.add(_TableState(enabled : result['table'][i] != 0 ? true : false, currentNumber: result['table'][i]));
            });
        }
        else {
          for (int i = 0; i < 12; ++i) 
            setState(() {
              controllerList.add(TextEditingController(text: '0'));
              tableStateList.add(_TableState(enabled : false, currentNumber: 0 ));
            });
        }
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('테이블 관리')),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: controllerList.length == 0 ? Container() :
        ListView(
          children: renderList(),
        ),
      )
    );
  }
}