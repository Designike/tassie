import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/wrapper.dart';

class UError extends StatelessWidget {
  final EndUser? user;
  UError({this.user});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("OOPSS RAN INTO A PROBLEM..."),
            TextButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Wrapper();
                  }),
                );
              },
              child: Text("Try again"),
            ),
          ],
        ),
      ),
    );
  }
}
