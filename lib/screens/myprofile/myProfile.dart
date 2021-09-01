import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/Error/error.dart';

import '../../constants.dart';
import '../../main.dart';
import '../wrapper.dart';

class Profile extends StatefulWidget {
  late final EndUser? user;

  Profile({this.user});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String userName = "";
  late final String? email;
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void getemail() {
    User? user = _auth.currentUser!;
    email = user.email;
    if (this.mounted) {
      setState(() {});
    }
  }

  Future<void> getName() async {
    try {
      await FirebaseFirestore.instance
          .collection("userInfo")
          .doc(widget.user!.uid)
          .get()
          .then((value) {
        if (this.mounted) {
          setState(() {
            userName = value["name"];
            if (userName.length != 0) {
              isLoading = false;
            }
          });
        }
        // print(userName);
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
  }

  @override
  void initState() {
    super.initState();
    getName();
    getemail();
    print(userName);
    print(email);
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
            backgroundColor: kTextWhite,
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: size.height * 0.4,
                    child: Center(
                      child: Image.asset(
                        'assets/photos/profile.png',
                        height: size.width * 0.4,
                        width: size.width * 0.4,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryColorAccent,
                      boxShadow: [
                        BoxShadow(
                          color: kTextBlack[700]!.withOpacity(0.2),
                          offset: Offset(0.0, 5.0),
                          blurRadius: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: (size.height * 0.4) - 15.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: size.height * 0.6,
                    decoration: BoxDecoration(
                      color: kTextWhite,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0)),
                      boxShadow: [
                        BoxShadow(
                          color: kTextBlack[700]!.withOpacity(0.3),
                          offset: Offset(0.0, -10.0),
                          blurRadius: 15.0,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            // height: 250.0,
                            padding: EdgeInsets.all(kDefaultPadding),
                            // decoration: BoxDecoration(),
                            child: Row(
                              children: [
                                // Icon(
                                //   Icons.perm_identity,
                                //   size: 50,
                                // ),
                                ClipOval(
                                  child: Material(
                                    color: kPrimaryColor, // Button color
                                    child: InkWell(
                                      splashColor:
                                          kTextBlack[800], // Splash color
                                      onTap: () {},
                                      child: SizedBox(
                                          width: 64,
                                          height: 64,
                                          child: Icon(
                                            Icons.fingerprint,
                                            color: kTextWhite,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding),
                                  child: Text(
                                    userName.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // height: 250.0,
                            padding: EdgeInsets.all(kDefaultPadding),
                            // decoration: BoxDecoration(),
                            child: Row(
                              children: [
                                // Icon(
                                //   Icons.perm_identity,
                                //   size: 50,
                                // ),
                                ClipOval(
                                  child: Material(
                                    color: kPrimaryColor, // Button color
                                    child: InkWell(
                                      splashColor:
                                          kTextBlack[800], // Splash color
                                      onTap: () {},
                                      child: SizedBox(
                                          width: 64,
                                          height: 64,
                                          child: Icon(
                                            Icons.email,
                                            color: kTextWhite,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding),
                                  child: Text(
                                    email!,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // LogoutSlider(size: size),
                          // Spacer(),
                          GestureDetector(
                            onTap: () async {
                              await _auth.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return Wrapper();
                                }),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(kDefaultPadding),
                              height: 64.0,
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                      width: 2.0,
                                    ),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(25.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Logout',
                                        style: TextStyle(
                                          fontFamily: 'Raleway',
                                          color: kTextBlack[800],
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}


// () async {
      //   await _auth.signOut();
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) {
      //       return MyApp();
      //     }),
      //   );
      // },