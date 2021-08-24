import 'package:flutter/material.dart';
import 'package:tassie/screens/authenticate/register%20copy.dart';
import 'package:tassie/screens/authenticate/register.dart';
import 'package:tassie/screens/authenticate/sign_in%20copy.dart';
import 'package:tassie/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggle() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignInC(func: toggle);
    } else {
      return RegisterC(func: toggle);
    }
  }
}
