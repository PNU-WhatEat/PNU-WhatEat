import 'package:flutter/material.dart';
import 'package:what_eat/screens/ReservationPage.dart';
import 'package:what_eat/screens/ReviewPage.dart';

class DetailPage extends StatelessWidget {
  static const id = 'detail_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, ReservationPage.id);
            },
            child: Text(
              "Go to reservation page",
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, ReviewPage.id);
            },
            child: Text(
              "Go to review page",
            ),
          ),
        ],
      ),
    );
  }
}
