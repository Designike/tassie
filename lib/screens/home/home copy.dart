import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/Error/error.dart';
import 'package:tassie/screens/home/More.dart';
import 'package:tassie/screens/results/recipeDescription.dart';
import 'package:tassie/screens/results/recipeResults.dart';

import '../../constants.dart';

class HomeC extends StatefulWidget {
  late final EndUser? user;
  HomeC({this.user});
  @override
  _HomeCState createState() => _HomeCState();
}

class _HomeCState extends State<HomeC> {
  // final AuthUtil _auth = AuthUtil();
  late EndUser? user;
  _HomeCState({this.user}) {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        if (this.mounted) {
          setState(() {
            _searchText = "";
            filteredNames = names;
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            _searchText = _filter.text;
            filteredNames = names;
          });
        }
      }
    });
  }

  Future<void> setData() async {
    try {
      await FirebaseFirestore.instance
          .collection("allRecipe")
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          recipes.add(doc["recipeName"]);
          mixture.add(doc["id"]);
          var x = doc["id"].split("-");
          uuid.add(x[0]);
        });
      });
      await getImage(uuid, recipes);
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
      setState(() {
        names = recipes.toSet().toList();
        filteredNames = names;
      });
    }
  }

  Future<void> getImage(List<String> uuid, List<String> repname) async {
    try {
      for (int i = 0; i < uuid.length; i++) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('images/' + uuid[i] + '/' + repname[i]);
        var iurl = await ref.getDownloadURL();
        url.add(iurl);
        await FirebaseFirestore.instance
            .collection("userInfo")
            .doc(uuid[i])
            .get()
            .then((doc) {
          userName.add(doc["name"]);
        });
      }
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
      setState(() {
        recommended(repname, userName, url);
        featured(recipes, userName, url);
      });
    }
  }

  void recommended(
      List<String> recipes, List<String> userName, List<String> url) {
    List numberList = [];
    var t = 0;
    while (t != 4) {
      Map tem = {};
      Random random = new Random();
      int randomNumber = random.nextInt(9);
      if (!numberList.contains(randomNumber)) {
        tem['recipeName'] = recipes[randomNumber];
        tem['userName'] = userName[randomNumber];
        tem['url'] = url[randomNumber];
        tem['mixture'] = mixture[randomNumber];
        recommend.add(tem);
        numberList.add(randomNumber);
        t++;
      }
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  void featured(List<String> recipes, List<String> userName, List<String> url) {
    List numberList = [];
    var t = 0;
    while (t != 4) {
      Map tem = {};
      Random random = new Random();
      int randomNumber = random.nextInt(9);
      if (!numberList.contains(randomNumber)) {
        tem['recipeName'] = recipes[randomNumber];
        tem['userName'] = userName[randomNumber];
        tem['url'] = url[randomNumber];
        tem['mixture'] = mixture[randomNumber];
        feature.add(tem);
        numberList.add(randomNumber);
        t++;
      }
    }
    if (this.mounted) {
      setState(() {
        if (feature.length == 4) {
          isLoading = false;
        }
      });
    }
  }

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List<String> names = [];
  List<String> filteredNames = [];
  List<String> recipes = [];
  List<String> uuid = [];
  List<String> url = [];
  List<String> userName = [];
  List<String> mixture = [];
  List<Map> recommend = [];
  List<Map> feature = [];
  bool isLoading = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  Widget? _buildList() {
    if (!(_searchText == "")) {
      List<String> tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;

      return Container(
        decoration: BoxDecoration(
          color: kTextWhite,
          boxShadow: [
            BoxShadow(
              color: kPrimaryColorAccent,
              offset: Offset(0.0, 25.0),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: LimitedBox(
          maxHeight: 220.0,
          child: ListView.builder(
            padding: EdgeInsets.all(0.0),
            itemCount: names.length == 0 ? 0 : filteredNames.length,
            itemBuilder: (BuildContext context, int index) {
              return new ListTile(
                title: Text(filteredNames[index]),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return RecipeResults(
                          user: user, name: filteredNames[index]);
                    }),
                  );
                },
              );
            },
          ),
        ),
      );
    } else {
      return null;
    }
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
            body: Container(
              height: size.height,
              width: size.width,
              margin: EdgeInsets.only(bottom: 50.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // search box
                    // HeaderWithSearchBox(size: size),
                    Container(
                      margin: EdgeInsets.only(bottom: kDefaultPadding * 1.2),
                      height: size.height * 0.3,
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: kDefaultPadding,
                                right: kDefaultPadding,
                                // bottom: kDefaultPadding,
                                top: kDefaultPadding * 2),
                            height: size.height * 0.3 - 25,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(36),
                                bottomRight: Radius.circular(36),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Hi Tassite!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35.0,
                                      ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding),
                                    height: 54,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 10),
                                            blurRadius: 40,
                                            color:
                                                kPrimaryColor.withOpacity(0.23),
                                          ),
                                        ]),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            onChanged: (value) {},
                                            controller: _filter,
                                            decoration: InputDecoration(
                                              hintText: 'Search Recipes',
                                              hintStyle: TextStyle(
                                                color: kPrimaryColor
                                                    .withOpacity(0.5),
                                              ),
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        Icon(Icons.search,
                                            color: kTextBlack[800]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //search box end
                        ],
                      ),
                    ),

                    Stack(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              //Recommended with more button
                              TitleWithMoreButton(
                                  title: "Recommended",
                                  press: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return More(
                                            user: user,
                                            recipes: recipes,
                                            imageUrl: url,
                                            id: mixture,
                                            userNames: userName);
                                      }),
                                    );
                                  }),

                              // first row recipes div
                              // RecommendedRecipes(recommend: recommend),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    RecipeCard(
                                      title: recommend[0]["recipeName"],
                                      recipeByUser: recommend[0]["userName"],
                                      press: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return Description(
                                                mixture: recommend[0]
                                                    ["mixture"]);
                                          }),
                                        );
                                      },
                                      image: recommend[0]["url"],
                                    ),
                                    RecipeCard(
                                      title: recommend[1]["recipeName"],
                                      recipeByUser: recommend[1]["userName"],
                                      press: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return Description(
                                                mixture: recommend[1]
                                                    ["mixture"]);
                                          }),
                                        );
                                      },
                                      image: recommend[1]["url"],
                                    ),
                                    RecipeCard(
                                      title: recommend[2]["recipeName"],
                                      recipeByUser: recommend[2]["userName"],
                                      press: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return Description(
                                                mixture: recommend[2]
                                                    ["mixture"]);
                                          }),
                                        );
                                      },
                                      image: recommend[2]["url"],
                                    ),
                                    RecipeCard(
                                      title: recommend[3]["recipeName"],
                                      recipeByUser: recommend[3]["userName"],
                                      press: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return Description(
                                                mixture: recommend[3]
                                                    ["mixture"]);
                                          }),
                                        );
                                      },
                                      image: recommend[3]["url"],
                                    ),
                                  ],
                                ),
                              ),

                              //Recommended with more button
                              TitleWithMoreButton(
                                  title: "Featured",
                                  press: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return More(
                                            user: user,
                                            recipes: recipes,
                                            imageUrl: url,
                                            id: mixture,
                                            userNames: userName);
                                      }),
                                    );
                                  }),

                              // second row div
                              // RecommendedRecipes(recommend: recommend),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    RecipeCard(
                                      title: feature[0]["recipeName"],
                                      recipeByUser: feature[0]["userName"],
                                      press: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return Description(
                                                mixture: feature[0]["mixture"]);
                                          }),
                                        );
                                      },
                                      image: feature[0]["url"],
                                    ),
                                    RecipeCard(
                                      title: feature[1]["recipeName"],
                                      recipeByUser: feature[1]["userName"],
                                      press: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return Description(
                                                mixture: feature[1]["mixture"]);
                                          }),
                                        );
                                      },
                                      image: feature[1]["url"],
                                    ),
                                    RecipeCard(
                                      title: feature[2]["recipeName"],
                                      recipeByUser: feature[2]["userName"],
                                      press: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return Description(
                                                mixture: feature[2]["mixture"]);
                                          }),
                                        );
                                      },
                                      image: feature[2]["url"],
                                    ),
                                    RecipeCard(
                                      title: feature[3]["recipeName"],
                                      recipeByUser: feature[3]["userName"],
                                      press: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return Description(
                                                mixture: feature[3]["mixture"]);
                                          }),
                                        );
                                      },
                                      image: feature[3]["url"],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // search suggestions
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: kDefaultPadding,
                              right: kDefaultPadding,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              child: Container(
                                child: _buildList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class HeaderWithSearchBox extends StatefulWidget {
  const HeaderWithSearchBox({
    required this.size,
  });
  final Size size;

  @override
  _HeaderWithSearchBoxState createState() => _HeaderWithSearchBoxState();
}

class _HeaderWithSearchBoxState extends State<HeaderWithSearchBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: kDefaultPadding * 1.2),
      height: widget.size.height * 0.2,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: 36 + kDefaultPadding,
            ),
            height: widget.size.height * 0.2 - 25,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Hi Tassite!',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                      ),
                ),
                Spacer(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    height: 54,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 40,
                            color: kPrimaryColor.withOpacity(0.23),
                          ),
                        ]),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {},
                            // controller: _filter,
                            decoration: InputDecoration(
                              hintText: 'Search Recipes',
                              hintStyle: TextStyle(
                                color: kPrimaryColor.withOpacity(0.5),
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.search, color: kTextBlack[800]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          //search box end
        ],
      ),
    );
  }
}

class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding / 4),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kTextBlack[900],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 7,
              margin: EdgeInsets.only(right: kDefaultPadding / 4),
              color: kPrimaryColor.withOpacity(0.2),
            ),
          )
        ],
      ),
    );
  }
}

class TitleWithMoreButton extends StatelessWidget {
  const TitleWithMoreButton({required this.title, required this.press});
  final String title;
  final Function press;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: [
          // Recommended
          TitleWithCustomUnderline(text: title),

          // More button
          Spacer(),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Colors.amber),
                ),
              ),
            ),
            onPressed: () => {press()},
            child: Text(
              "More",
              style: TextStyle(
                fontFamily: 'Raleway',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    required this.image,
    required this.title,
    required this.recipeByUser,
    required this.press,
  });
  final String image, title, recipeByUser;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding * 2.5,
      ),
      width: size.width * 0.4,
      child: Column(
        children: [
          ClipRRect(
            child: Image.network(image,
                height: size.width * 0.4,
                width: size.width * 0.4,
                fit: BoxFit.cover),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
          ),
          GestureDetector(
            onTap: () {
              press();
            },
            child: Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50.0,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: Theme.of(context).textTheme.button,
                          overflow: TextOverflow.clip,
                          softWrap: false,
                          maxLines: 1,
                        ),
                        Text(
                          recipeByUser.toUpperCase(),
                          style: TextStyle(
                            color: kPrimaryColor.withOpacity(0.5),
                          ),
                          overflow: TextOverflow.clip,
                          softWrap: false,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendedRecipes extends StatefulWidget {
  final List<Map> recommend;
  RecommendedRecipes({required this.recommend});

  @override
  _RecommendedRecipesState createState() => _RecommendedRecipesState();
}

class _RecommendedRecipesState extends State<RecommendedRecipes> {
  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          RecipeCard(
            title: (widget.recommend.length == 0)
                ? widget.recommend[0]["recipeName"]
                : "Title".toUpperCase(),
            recipeByUser: (widget.recommend.length == 0)
                ? widget.recommend[0]["userName"]
                : "username".toUpperCase(),
            press: () {},
            image: (widget.recommend.length == 0)
                ? widget.recommend[0]["url"]
                : 'assets/photos/pizzo.jpeg',
          ),
          RecipeCard(
            title: (widget.recommend.length == 0)
                ? widget.recommend[1]["recipeName"]
                : "Title".toUpperCase(),
            recipeByUser: "Sanjeeev Kapoor",
            press: () {},
            image: "assets/photos/pizzo.jpeg",
          ),
          RecipeCard(
            title: (widget.recommend.length == 0)
                ? widget.recommend[2]["recipeName"]
                : "Title".toUpperCase(),
            recipeByUser: "Sanjeeev Kapoor",
            press: () {},
            image: "assets/photos/pizzo.jpeg",
          ),
          RecipeCard(
            title: (widget.recommend.length == 0)
                ? widget.recommend[3]["recipeName"]
                : "Title".toUpperCase(),
            recipeByUser: "Sanjeeev Kapoor",
            press: () {},
            image: "assets/photos/pizzo.jpeg",
          ),
        ],
      ),
    );
  }
}
