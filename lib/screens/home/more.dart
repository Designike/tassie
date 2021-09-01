import 'package:flutter/material.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/results/recipeDescription.dart';

import '../../constants.dart';

class More extends StatefulWidget {
  late final EndUser? user;
  late final List<String> recipes;
  late final List<String> imageUrl;
  late final List<String> id;
  late final List<String> userNames;
  More(
      {this.user,
      required this.recipes,
      required this.imageUrl,
      required this.id,
      required this.userNames});
  // This widget is the root of your application.
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  void initState() {
    super.initState();
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
                          image: (widget.imageUrl.length != 0)
                              ? NetworkImage(widget.imageUrl[index])
                              : NetworkImage('https://i.imgur.com/sUFH1Aq.png'),

                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return Description(mixture: widget.id[index]);
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
                                    widget.recipes[index].toUpperCase(),
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
                                    (widget.userNames.length != 0)
                                        ? widget.userNames[index].toUpperCase()
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
              childCount: widget.recipes.length,
            ),
          )
        ],
      ),
    );
  }
}
