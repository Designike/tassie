import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/authenticate/authenticate.dart';
import 'package:tassie/screens/home/home%20copy.dart';
import 'package:tassie/screens/my_recipe/myRecipe.dart';
import 'package:tassie/screens/myprofile/myProfile.dart';


import '../constants.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<EndUser>(context);
    Size size = MediaQuery.of(context).size;
    
    if (user.uid != null) {

      return Scaffold(
        //nav
        extendBody: true,
        bottomNavigationBar: Container(
          color: kTextWhite.withOpacity(0.0),
          padding: EdgeInsets.all(kDefaultPadding),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(25.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: kTextBlack[900]!.withOpacity(0.0),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColorAccent,
                    offset: Offset(0.0, 10.0),
                    blurRadius: 20.0,
                    spreadRadius: 10.0,
                  ),
                ],
              ),
              child: TabBar(
                labelColor: kPrimaryColor,
                unselectedLabelColor: kTextBlack[800],
                indicator: BoxDecoration(
                  color: kTextBlack[800],
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor,
                      offset: Offset(0.0, 10.0),
                      blurRadius: 20.0,
                      spreadRadius: 10.0,
                    ),
                  ],
                ),
                indicatorColor: kTextWhite,
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.home,
                      size: 25.0,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.restaurant,
                      size: 25.0,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.account_circle,
                      size: 25.0,
                    ),
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ),
        ),
        //body

        body: TabBarView(
          children: [
            HomeC(user: user),
            MyRecipe(user: user),
            Profile(user: user),
          ],
          controller: _tabController,
        ),
      );
    } else {
      return Authenticate();
    }
  }
}
