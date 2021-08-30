import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Description extends StatefulWidget {
  late final String? mixture;
  Description({this.mixture});

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  String name = '';
  String uid = '';
  String imageUrl = "";
  static List<String> steps = [];
  static List<String> ingredients = [];

  Future<void> getData() async {
    late List<String> result;
    result = widget.mixture!.split("-");
    print(result);
    name = result[1];
    print(name);
    uid = result[0];
    print(uid);
    await FirebaseFirestore.instance
        .collection('recipeCollection')
        .doc(uid)
        .collection('userRecipeCollection')
        .doc(name)
        .get()
        .then((doc) {
      steps = new List<String>.from(doc["steps"]);
      ingredients = new List<String>.from(doc["ingredients"]);
      print(steps);
      print(ingredients);
    });
    await getImage();
    setState(() {
      print(imageUrl);
    });
  }

  Future<void> getImage() async {
    final ref = FirebaseStorage.instance.ref().child('images/$uid/$name');
    // print(ref);
    var url = await ref.getDownloadURL();
    setState(() {
      // print(user.uid);
      imageUrl = url;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Text(name),
          ),
          // Container(
          //   child: ListView.builder(
          //       itemCount: steps.length,
          //       itemBuilder: (context, index) {
          //         return Padding(
          //           padding: const EdgeInsets.symmetric(
          //               vertical: 1.0, horizontal: 4.0),
          //           child: Card(
          //             child: ListTile(
          //               title: Text(steps[index]),
          //             ),
          //           ),
          //         );
          //       }),
          // ),
          // Container(
          //   child: ListView.builder(
          //       itemCount: ingredients.length,
          //       itemBuilder: (context, index) {
          //         return Padding(
          //           padding: const EdgeInsets.symmetric(
          //               vertical: 1.0, horizontal: 4.0),
          //           child: Card(
          //             child: ListTile(
          //               title: Text(ingredients[index]),
          //             ),
          //           ),
          //         );
          //       }),
          // ),
        ],
      ),
    );
  }
}
