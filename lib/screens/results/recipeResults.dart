import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/Error/error.dart';
import 'package:tassie/screens/results/recipeDescription.dart';

import '../../constants.dart';

// class Results extends StatefulWidget {
//   late final EndUser? user;
//   late final String? name;
//   Results({this.user, this.name});

//   @override
//   _ResultsState createState() => _ResultsState();
// }

// class _ResultsState extends State<Results> {
//   Future<void> getData(List<String> recipe, EndUser? user, String? name) async {
//     // late List<String> recipe = [];
//     await FirebaseFirestore.instance
//         .collection('allRecipe')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         if (doc["recipeName"].contains(name)) {
//           recipes.add(doc["recipeName"]);
//           id.add(doc["id"]);
//         }
//       });
//     });
//     setState(() {});
//   }

//   List<String> recipes = [];
//   List<String> id = [];

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getData(recipes, widget.user, widget.name);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         backgroundColor: Colors.blue[900],
//         title: Text('Choose a Location'),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: ListView.builder(
//           itemCount: recipes.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
//               child: Card(
//                 child: ListTile(
//                   onTap: () async {
//                     await Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) {
//                         return Description(mixture: id[index]);
//                       }),
//                     );
//                   },
//                   title: Text(recipes[index]),
//                 ),
//               ),
//             );
//           }),
//     );
//   }
// }

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // Application name
//       title: 'Flutter Stateful Clicker Counter',
//       theme: ThemeData(
//           // Application theme data, you can set the colors for the application as
//           // you want
//           // primarySwatch: Colors.blue,

//           ),
//       home: RecipeResults(),
//     );
//   }
// }
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
    // late List<String> recipe = [];
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
    setState(() {
      print(uuid);
      print(repname);
      print(imageUrl);
    });
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
    setState(() {});
  }

  Future<void> getImage(List<String> uuid, List<String> repname) async {
    for (int i = 0; i < uuid.length; i++) {
      print("henlo");
      final ref = FirebaseStorage.instance
          .ref()
          .child('images/' + uuid[i] + '/' + repname[i]);
      // .child('images/jVRQiFTQbbTday9Ql4boxFHX9gr2/paneer tikka');
      print(ref);
      var url = await ref.getDownloadURL();
      print(url);
      // print(user.uid);
      imageUrl.add(url);
    }

    setState(() {});
  }

  // List<String> recipe = [
  //   'Khamman',
  //   'Dhokla',
  //   'Khichdi',
  //   'Undhyu',
  //   'Jalebi',
  //   'Fafda',
  //   'Puri',
  //   'Pav Bhaji',
  //   'Gulab Jamun',
  //   'Barfi',
  //   'Laddu',
  //   'Farali Khichdi',
  //   'Pizza',
  //   'Burger',
  //   'Pasta',
  //   'French Fries',
  // ];
  List<String> id = [];
  List<String> recipes = [];
  List<String> uuid = [];
  List<String> repname = [];
  List<String> imageUrl = [];
  List<String> userNames = [];
  // List<GestureDetector> _getRecipes() {
  //   List<GestureDetector> _cards = [];

  //   for (int i = 0; i < recipe.length; i++) {
  //     _cards.add(
  //       GestureDetector(
  //         onTap: () async {
  //           await Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) {
  //               return RecipeDescription(user: 'user', name: recipe[i]);
  //             }),
  //           );
  //         },
  //         child: Container(
  //           padding: EdgeInsets.all(kDefaultPadding / 2),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //             boxShadow: [
  //               BoxShadow(
  //                 offset: Offset(0, 10),
  //                 blurRadius: 20.0,
  //                 color: kPrimaryColor.withOpacity(0.23),
  //               ),
  //             ],
  //           ),
  //           child: Stack(
  //             children: [
  //               Image.network('https://picsum.photos/200/300', height: size.height * 0.3, fit: BoxFit.cover),
  //               Positioned(
  //                 bottom: 10.0,
  //                 left: 10.0,
  //                 child: Flexible(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         recipe[i].toUpperCase(),
  //                         style: Theme.of(context).textTheme.button,
  //                         overflow: TextOverflow.clip,
  //                         softWrap: false,
  //                         maxLines: 1,
  //                       ),
  //                       Text(
  //                         recipe[i].toUpperCase(),
  //                         style: TextStyle(
  //                           color: kPrimaryColor.withOpacity(0.5),
  //                         ),
  //                         overflow: TextOverflow.clip,
  //                         softWrap: false,
  //                         maxLines: 1,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //   return _cards;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(recipes, widget.user, widget.name);
    // getImage(uuid, repname);
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
                        // (imageUrl != "")
                        //   ? Image.network(imageUrl)
                        //   : Image.network('https://i.imgur.com/sUFH1Aq.png'))
                        Ink.image(
                          // image: NetworkImage(imageUrl[index]),
                          // placeholder:NetworkImage('https://i.imgur.com/sUFH1Aq.png'),
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
                          // height: size.height * 0.25,
                          // width: size.width - (2 * kDefaultPadding),
                          fit: BoxFit.cover,
                        ),
                        // ListTile(
                        //   onTap: () async {
                        //     await Navigator.pushReplacement(
                        //       context,
                        //       MaterialPageRoute(builder: (context) {
                        //         return RecipeDescription(user: 'user', name: recipe[index]);
                        //       }),
                        //     );
                        //   },
                        //   title: Text(recipe[index]),
                        // ),
                        // Positioned(
                        //   bottom: 0.0,
                        //   left: 0.0,
                        //   child: Container(
                        //     width: size.width - (2 * kDefaultPadding),
                        //     padding: EdgeInsets.all(kDefaultPadding),
                        //     decoration: BoxDecoration(
                        //       color: kTextBlack[900].withOpacity(0.5),
                        //     ),
                        //     child: Flexible(
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             recipe[index].toUpperCase(),
                        //             style: TextStyle(
                        //               color: kPrimaryColor,
                        //               fontSize: 20.0,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //             overflow: TextOverflow.clip,
                        //             softWrap: false,
                        //             maxLines: 1,
                        //           ),
                        //           Text(
                        //             'User'.toUpperCase(),
                        //             style: TextStyle(
                        //               color: kTextWhite,
                        //               fontSize: 15.0,
                        //             ),
                        //             overflow: TextOverflow.clip,
                        //             softWrap: false,
                        //             maxLines: 1,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
