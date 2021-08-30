import 'package:flutter/material.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/home/home%20copy.dart';

class UError extends StatelessWidget {
  final EndUser? user;
  UError({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("OOPSS RAN INTO A PROBLEM..."),
          TextButton(
            onPressed: () async {
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return HomeC(user: user);
                }),
              );
            },
            child: Text("Try again"),
          ),
        ],
      ),
    );
  }
}
