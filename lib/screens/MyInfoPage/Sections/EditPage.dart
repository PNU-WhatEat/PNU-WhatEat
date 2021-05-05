import 'package:flutter/material.dart';
import 'ListElement.dart';

class EditPage extends StatelessWidget {
  static const id = "edit_Page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보 수정'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column( children: [
      ]
      ),
    );
  }
}
