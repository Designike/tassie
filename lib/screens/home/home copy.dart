import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/new_recipe/newRecipe.dart';
import 'package:tassie/utilities/auth.dart';

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
  _HomeCState({this.user});
  // late TabController _tabController;
// (doc) {
//             print(doc["first_name"]);

  Future<void> setData() async {
    await FirebaseFirestore.instance
        .collection('allRecipe')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["recipeName"]);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setData();
    setState(() {});
    // _tabController = TabController(length: 3, vsync: this);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _tabController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        leading: Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
      //nav
      // extendBody: true,
      // bottomNavigationBar: Container(
      //   color: kTextWhite.withOpacity(0.0),
      //   padding: EdgeInsets.all(kDefaultPadding),
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.all(
      //       Radius.circular(25.0),
      //     ),
      //     child: Container(
      //       decoration: BoxDecoration(
      //         color: kTextBlack[900]!.withOpacity(0.0),
      //         boxShadow: [
      //           BoxShadow(
      //             color: kPrimaryColorAccent,
      //             offset: Offset(0.0, 10.0),
      //             blurRadius: 20.0,
      //             spreadRadius: 10.0,
      //           ),
      //         ],
      //       ),
      //       // color: kTextWhite,
      //       child: TabBar(
      //         labelColor: kPrimaryColor,
      //         unselectedLabelColor: kTextBlack[800],
      //         // indicator: UnderlineTabIndicator(
      //         //   borderSide: BorderSide(
      //         //     color: kTextWhite,
      //         //     width: 0.0,
      //         //   ),
      //         //   insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
      //         // ),
      //         indicator: BoxDecoration(
      //           color: kTextBlack[800],
      //           boxShadow: [
      //             BoxShadow(
      //               color: kPrimaryColor,
      //               offset: Offset(0.0, 10.0),
      //               blurRadius: 20.0,
      //               spreadRadius: 10.0,
      //             ),
      //           ],
      //         ),
      //         indicatorColor: kTextWhite,
      //         tabs: [
      //           Tab(
      //             icon: Icon(
      //               Icons.home,
      //               size: 25.0,
      //             ),
      //           ),
      //           Tab(
      //             icon: Icon(
      //               Icons.restaurant,
      //               size: 25.0,
      //             ),
      //           ),
      //           Tab(
      //             icon: Icon(
      //               Icons.account_circle,
      //               size: 25.0,
      //             ),
      //           ),
      //         ],
      //         controller: _tabController,
      //       ),
      //     ),
      //   ),
      // ),
      //body

      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // search box
              HeaderWithSearchBox(size: size),

              //Recommended with more button
              TitleWithMoreButton(title: "Recommended", press: () {}),

              // first row recipes div
              RecommendedRecipes(),

              //Recommended with more button
              TitleWithMoreButton(title: "Featured", press: () {}),

              // second row div
              RecommendedRecipes(),
            ],
          ),
        ),
      ),
    );
    // return Container(
    //   child: Scaffold(
    //     backgroundColor: Colors.brown[50],
    //     appBar: AppBar(
    //       title: Text('Tassie'),
    //       backgroundColor: Colors.brown[400],
    //       elevation: 0.0,
    //       actions: <Widget>[
    //         TextButton.icon(
    //           icon: Icon(Icons.person),
    //           label: Text('logout'),
    //           onPressed: () async {
    //             await _auth.signOut();
    //           },
    //         ),
    //         TextButton.icon(
    //           icon: Icon(Icons.plus_one),
    //           label: Text('New'),
    //           onPressed: () async {
    //             Navigator.pushReplacement(
    //               context,
    //               MaterialPageRoute(builder: (context) {
    //                 return NewRecipe(user: user);
    //               }),
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class HeaderWithSearchBox extends StatelessWidget {
  const HeaderWithSearchBox({
    // required Key key,
    required this.size,
  });
  // : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: kDefaultPadding * 2.5),
      height: size.height * 0.2,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: 36 + kDefaultPadding,
            ),
            height: size.height * 0.2 - 25,
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
                // Image.asset(''),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
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
                    Icon(Icons.search, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),

          //serach box end
        ],
      ),
    );
  }
}

class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({required this.text});

  final String text;
// : super(key: key);
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
// : super(key: key);
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
            onPressed: press(),
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
    // required Key key,
    required this.image,
    required this.title,
    required this.recipeByUser,
    required this.press,
  });
// : super(key: key);
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
            child: Image.asset(image,
                height: size.width * 0.4,
                width: size.width * 0.4,
                fit: BoxFit.cover),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
          ),
          GestureDetector(
            onTap: press(),
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

class RecommendedRecipes extends StatelessWidget {
  const RecommendedRecipes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          RecipeCard(
            title: "Khamman",
            recipeByUser: "Sanjeeev Kapoor",
            press: () {},
            image: "assets/photos/pizzo.jpeg",
          ),
          RecipeCard(
            title: "Khamman",
            recipeByUser: "Sanjeeev Kapoor",
            press: () {},
            image: "assets/photos/pizzo.jpeg",
          ),
          RecipeCard(
            title: "Khamman",
            recipeByUser: "Sanjeeev Kapoor",
            press: () {},
            image: "assets/photos/pizzo.jpeg",
          ),
          RecipeCard(
            title: "Khamman",
            recipeByUser: "Sanjeeev Kapoor",
            press: () {},
            image: "assets/photos/pizzo.jpeg",
          ),
        ],
      ),
    );
  }
}
