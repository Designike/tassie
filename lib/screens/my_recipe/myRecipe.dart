import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/Error/error.dart';
import 'package:tassie/screens/new_recipe/newRecipe.dart';
import 'package:tassie/screens/results/recipeDescription.dart';

import '../../constants.dart';

class MyRecipe extends StatefulWidget {
  late final EndUser? user;
  MyRecipe({this.user});

  @override
  _Myrecipetate createState() => _Myrecipetate(user: user);
}

class _Myrecipetate extends State<MyRecipe> {
  late final EndUser? user;
  late List<String> recipe = [];
  late List<String> imageUrl = [];
  late String userName = "";
  late List<String> mixture = [];
  bool isLoading = true;
  _Myrecipetate({this.user});

  Future<void> getName() async {
    try {
      await FirebaseFirestore.instance
          .collection("userInfo")
          .doc(user!.uid)
          .get()
          .then((value) {
        userName = value["name"];
      });
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

  Future<void> getImage(String? uuid, List<String> repname) async {
    for (int i = 0; i < repname.length; i++) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('images/' + uuid! + '/' + repname[i]);
      var url = await ref.getDownloadURL();
      imageUrl.add(url);
    }
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getData(List<String> recipe, EndUser? user) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipeCollection')
          .doc(user?.uid)
          .collection('userRecipeCollection')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          String tem = "";
          recipe.add(doc["recipeName"]);
          tem = user!.uid! + "-" + doc["recipeName"];
          mixture.add(tem);
        });
      });
      await getImage(user?.uid, recipe);
    } catch (e) {
      print(e);
      if (this.mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return UError(user: user);
          }),
        );
      }
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getData(recipe, user);
    getName();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (isLoading == true)
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SpinKitThreeBounce(
                color: kPrimaryColor,
                size: 50.0,
              ),
            ),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NewRecipe(
                      user: user,
                      name: "",
                      recipes: recipe,
                    );
                  }),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: kPrimaryColor,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
                              padding:
                                  const EdgeInsets.only(left: kDefaultPadding),
                              child: Text(
                                'Your\nyummies!',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
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
                        padding: EdgeInsets.all(0.0),
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
                                    : NetworkImage(
                                        'https://i.imgur.com/sUFH1Aq.png'),
                                child: InkWell(
                                  onTap: () async {
                                    await Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      // return Description(
                                      //   mixture: mixture[index],
                                      // );
                                      return NewRecipe(
                                          user: user,
                                          name: recipe[index],
                                          recipes: recipe);
                                    }));
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          recipe[index].toUpperCase(),
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
                                          (userName.length != 0)
                                              ? userName.toUpperCase()
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
                    childCount: recipe.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 80.0),
                ),
              ],
            ),
          );
  }
}
