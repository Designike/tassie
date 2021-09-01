import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/Error/error.dart';
import 'package:tassie/screens/results/recipeDescription.dart';

import '../../constants.dart';

class RecipeResults extends StatefulWidget {
  late final EndUser? user;
  late final String? name;
  RecipeResults({this.user, this.name});
  // This widget is the root of your application.
  @override
  _RecipeResultsState createState() => _RecipeResultsState();
}

class _RecipeResultsState extends State<RecipeResults> {
  Future<void> getData(List<String> recipe, EndUser? user, String? name) async {
    try {
      await FirebaseFirestore.instance
          .collection('allRecipe')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc["recipeName"].contains(name)) {
            recipes.add(doc["recipeName"]);
            id.add(doc["id"]);
            var result = doc["id"].split("-");
            uuid.add(result[0]);
            repname.add(result[1]);
          }
        });
      });
      await getImage(uuid, repname);
      await getName(uuid);
    } catch (e) {
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

  Future<void> getName(List<String> uuid) async {
    try {
      for (var v = 0; v < uuid.length; v++) {
        await FirebaseFirestore.instance
            .collection("userInfo")
            .doc(uuid[v])
            .get()
            .then((value) {
          userNames.add(value["name"]);
        });
      }
    } catch (e) {
      print(e);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return UError(user: widget.user);
        }),
      );
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  Future<void> getImage(List<String> uuid, List<String> repname) async {
    for (int i = 0; i < uuid.length; i++) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('images/' + uuid[i] + '/' + repname[i]);
      var url = await ref.getDownloadURL();
      imageUrl.add(url);
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  List<String> id = [];
  List<String> recipes = [];
  List<String> uuid = [];
  List<String> repname = [];
  List<String> imageUrl = [];
  List<String> userNames = [];

  @override
  void initState() {
    super.initState();
    getData(recipes, widget.user, widget.name);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: kPrimaryColor,
            expandedHeight: 200.0,
            elevation: 0.0,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: kTextWhite,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0.0,
                      child: Image.asset(
                        'assets/photos/appbar-bg-lg.png',
                        width: size.width,
                      ),
                    ),
                    Positioned(
                      bottom: 20.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: kDefaultPadding),
                        child: Text(
                          'Yumminess\nahead!',
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35.0,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 1.0, horizontal: 4.0),
                  child: Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                        vertical: kDefaultPadding / 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Ink.image(
                          image: (imageUrl.length != 0)
                              ? NetworkImage(imageUrl[index])
                              : NetworkImage('https://i.imgur.com/sUFH1Aq.png'),
                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return Description(mixture: id[index]);
                                }),
                              );
                            },
                            child: Container(
                              width: size.width - (2 * kDefaultPadding),
                              padding: EdgeInsets.only(
                                  top: kDefaultPadding * 3,
                                  left: kDefaultPadding,
                                  right: kDefaultPadding,
                                  bottom: kDefaultPadding),
                              decoration: BoxDecoration(
                                color: kTextBlack[900]!.withOpacity(0.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    recipes[index].toUpperCase(),
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.clip,
                                    softWrap: false,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    (userNames.length != 0)
                                        ? userNames[index].toUpperCase()
                                        : "User".toUpperCase(),
                                    style: TextStyle(
                                      color: kTextWhite,
                                      fontSize: 15.0,
                                    ),
                                    overflow: TextOverflow.clip,
                                    softWrap: false,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: recipes.length,
            ),
          )
        ],
      ),
    );
  }
}
