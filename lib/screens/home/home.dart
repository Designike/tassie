import 'package:flutter/material.dart';
import 'package:tassie/main.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/my_recipe/myRecipe.dart';
import 'package:tassie/screens/new_recipe/newRecipe.dart';
import 'package:tassie/utilities/auth.dart';

class Home extends StatelessWidget {
  late final EndUser? user;
  final AuthUtil _auth = AuthUtil();
  Home({this.user});

  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Tassie'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return MyApp();
                  }),
                );
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.plus_one),
              label: Text('New'),
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NewRecipe(user: user, name: "");
                  }),
                );
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.my_library_books),
              label: Text('my'),
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return MyRecipe(user: user);
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
