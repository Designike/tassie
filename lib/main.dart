import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/wrapper.dart';
import 'package:tassie/utilities/auth.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthUtil().user,
      initialData: EndUser(uid: ''),
      child: MaterialApp(
        title: "Tassie",
        theme: ThemeData(
          fontFamily: "Raleway",
          accentColor: kPrimaryColorAccent,
          primaryColor: kPrimaryColor,
        ),
        home: Wrapper(),
      ),
    );
  }
}
