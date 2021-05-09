import 'package:flutter/material.dart';

class ListElement extends StatelessWidget {
  final Icon icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  ListElement({this.icon, this.title, this.value, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Row(children: [
            icon == null ? SizedBox.shrink() : Icon(icon.icon),
            icon == null ? SizedBox.shrink() : SizedBox(width: 5.0,),
            Text(title, style: TextStyle(fontSize: 20),),
          ],),
          Row(children: [
            value == null ? SizedBox.shrink() : Text(value, style: TextStyle(fontSize: 20),),
            Icon(Icons.arrow_forward_ios, color: Colors.grey) // dummy
          ],),],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      )
    );
  }
}
