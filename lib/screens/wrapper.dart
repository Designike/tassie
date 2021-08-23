import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/authenticate/authenticate.dart';
import 'package:tassie/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<EndUser>(context);
    if (user.uid != null) {
      return Home();
    } else {
      return Authenticate();
    }
  }
}
