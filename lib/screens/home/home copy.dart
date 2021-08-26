import 'package:flutter/material.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/new_recipe/newRecipe.dart';
import 'package:tassie/utilities/auth.dart';

import '../../constants.dart';

class HomeC extends StatelessWidget {
  final AuthUtil _auth = AuthUtil();
  late EndUser? user;
  HomeC({this.user});

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

      //body

      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // search box
              Container(
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
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
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
                          margin:
                              EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          padding:
                              EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
              ),

              //First scrolling div

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    // Recommended text
                    Container(
                      height: 24,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: kDefaultPadding / 4),
                            child: Text(
                              "Recommended",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 7,
                              margin:
                                  EdgeInsets.only(right: kDefaultPadding / 4),
                              color: kPrimaryColor.withOpacity(0.2),
                            ),
                          )
                        ],
                      ),
                    ),

                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Container(
                    //     height: 25.0,
                    //     child: Material(
                    //       borderRadius: BorderRadius.circular(20.0),
                    //       shadowColor: Colors.amberAccent,
                    //       color: Colors.amber,
                    //       elevation: 1.0,
                    //       child: Center(
                    //         child: Text(
                    //           'More',
                    //           style: TextStyle(
                    //             fontFamily: 'Raleway',
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // More button
                    Spacer(),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'More',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
