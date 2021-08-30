import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/Error/error.dart';
import 'package:tassie/screens/new_recipe/newRecipe.dart';

import '../../constants.dart';

class MyRecipe extends StatefulWidget {
  late final EndUser? user;
  MyRecipe({this.user});

  @override
  _MyRecipeState createState() => _MyRecipeState(user: user);
}

class _MyRecipeState extends State<MyRecipe> {
  late final EndUser? user;
  late List<String> recipe = [];
  _MyRecipeState({this.user});

  Future<void> getData(List<String> recipe, EndUser? user) async {
    // late List<String> recipe = [];
    try{
    await FirebaseFirestore.instance
        .collection('recipeCollection')
        .doc(user?.uid)
        .collection('userRecipeCollection')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        recipe.add(doc["recipeName"]);
      });
    });
    }catch(e){
      print(e);
      Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return UError(user: user);
                }),
              );
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(recipe, user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Choose a Location'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: recipe.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                  onTap: () async {
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return NewRecipe(user: user, name: recipe[index]);
                      }),
                    );
                  },
                  title: Text(recipe[index]),
                ),
              ),
            );
          }),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     elevation: 0.0,
    //     backgroundColor: kPrimaryColor,
    //     leading: Icon(
    //       Icons.menu,
    //       color: Colors.white,
    //     ),
    //   ),
    // );
  }
}
