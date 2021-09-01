import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/screens/Error/error.dart';
import 'package:tassie/screens/home/home%20copy.dart';

import '../../constants.dart';

class Description extends StatefulWidget {
  late final String? mixture;
  Description({this.mixture});

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  String name = '';
  String userName = '';
  String uid = '';
  String imageUrl = "";
  static List<String> steps = [];
  static List<String> ingredients = [];
  bool isLoading = true;

  Future<void> getData() async {
    late List<String> result;
    result = widget.mixture!.split("-");
    name = result[1];
    uid = result[0];
    await FirebaseFirestore.instance
        .collection('recipeCollection')
        .doc(uid)
        .collection('userRecipeCollection')
        .doc(name)
        .get()
        .then((doc) {
      steps = new List<String>.from(doc["steps"]);
      ingredients = new List<String>.from(doc["ingredients"]);
    });
    await getName();
    await getImage();
    if (this.mounted) {
      setState(() {
        if (imageUrl.length != 0) {
          isLoading = false;
        }
      });
    }
  }

  Future<void> getName() async {
    try {
      await FirebaseFirestore.instance
          .collection("userInfo")
          .doc(uid)
          .get()
          .then((value) {
        userName = value["name"];
      });
    } catch (e) {
      print(e);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return UError();
        }),
      );
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  Future<void> getImage() async {
    final ref = FirebaseStorage.instance.ref().child('images/$uid/$name');
 
    var url = await ref.getDownloadURL();
    if (this.mounted) {
      setState(() {
        imageUrl = url;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            body: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: _RecipeAppBar(
                    minExtended: kToolbarHeight,
                    maxExtended: size.height * 0.80,
                    size: size,
                    imageUrl: imageUrl,
                  ),
                ),
                SliverToBoxAdapter(
                  child: DescriptionBody(
                      size: size,
                      ingredients: ingredients,
                      steps: steps,
                      recipeName: name,
                      userName: userName),
                )
              ],
            ),
          );
  }
}

class DescriptionBody extends StatefulWidget {
  final Size size;
  final List<String> ingredients;
  final List<String> steps;
  final String recipeName;
  final String userName;

  DescriptionBody(
      {required this.size,
      required this.ingredients,
      required this.steps,
      required this.recipeName,
      required this.userName});
  @override
  _DescriptionBodyState createState() => _DescriptionBodyState();
}

class _DescriptionBodyState extends State<DescriptionBody> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: kTextWhite,
        boxShadow: [
          BoxShadow(
            blurRadius: 40.0,
            offset: Offset(0.0, -20.0),
            spreadRadius: 260.0,
            color: kTextBlack[800]!.withOpacity(0.3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // recipe name
          RecipeName(title: widget.recipeName, recipeByUser: widget.userName),

          // margin space
          SizedBox(
            height: 50.0,
          ),

          // ingredients
          TitleWithCustomUnderline(text: "Ingredients"),
          // margin space
          SizedBox(
            height: 10.0,
          ),
          MyList(listItems: widget.ingredients),

          // Steps
          TitleWithCustomUnderline(text: "Steps"),
          // margin space
          SizedBox(
            height: 10.0,
          ),
          MyList(listItems: widget.steps),

          // margin space
          SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }
}

class _RecipeAppBar extends SliverPersistentHeaderDelegate {
  const _RecipeAppBar(
      {required this.maxExtended,
      required this.minExtended,
      required this.size,
      required this.imageUrl});
  final double maxExtended;
  final double minExtended;
  final Size size;
  final String imageUrl;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percentage = shrinkOffset / maxExtended;
    final uploadlimit = 25 / 100;
    final backvalue = (1 - percentage - 0.65).clamp(0, uploadlimit);
    final fixrotation = pow(percentage, 1.5);

    final card = _CoverCard(
      size: size,
      percentage: percentage,
      uploadlimit: uploadlimit,
      backvalue: backvalue,
      imageUrl: imageUrl,
    );

    final bottomSilverBar = _CustomBottomSliverBar(
      size: size,
      fixrotation: fixrotation,
      percentage: percentage,
    );

    final extraPaddingBar = Positioned(
      bottom: 0,
      child: Container(
        height: 200.0,
        width: size.width,
        decoration: BoxDecoration(
          color: kTextWhite,
        ),
      ),
    );
    final extraPaddingBarDesign = Positioned(
      bottom: 30,
      child: Container(
        height: 200.0,
        width: size.width,
        child: Image.asset(
          'assets/photos/abstract.png',
          fit: BoxFit.cover,
        ),
      ),
    );

    return Container(
      child: Stack(
        children: [
          // appbar background
          SliverBackground(size: size),

          // custom shape and recipe card

          if (percentage > uploadlimit) ...[
            card,
            bottomSilverBar,
            extraPaddingBar,
            extraPaddingBarDesign,
          ] else ...[
            extraPaddingBar,
            extraPaddingBarDesign,
            bottomSilverBar,
            card,
          ],
        ],
      ),
    );
  }

  @override
  double get maxExtent => maxExtended;

  @override
  double get minExtent => minExtended;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class SliverBackground extends StatelessWidget {
  SliverBackground({required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 200.0,
      child: Image.asset(
        'assets/photos/desc-bg-lg.png',
        width: size.width,
      ),
    );
  }
}

class _CoverCard extends StatelessWidget {
  _CoverCard(
      {required this.size,
      required this.percentage,
      required this.uploadlimit,
      required this.backvalue,
      required this.imageUrl});
  final Size size;
  final double percentage;
  final double uploadlimit;
  final double angleForCard = 7;
  final num backvalue;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: size.height * 0.15,
        left: 0.0,
        child: Transform(
          transform: Matrix4.identity()
            ..rotateZ(percentage > uploadlimit
                ? (backvalue * angleForCard)
                : percentage * angleForCard),
          child: CoverPhoto(size: size, imageUrl: imageUrl),
        ));
  }
}

class CoverPhoto extends StatelessWidget {
  CoverPhoto({required this.size, required this.imageUrl});
  final Size size;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width - (2 * kDefaultPadding),
      height: size.height * 0.4,
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}

class _CustomBottomSliverBar extends StatelessWidget {
  _CustomBottomSliverBar(
      {required this.size,
      required this.fixrotation,
      required this.percentage});

  final Size size;
  final num fixrotation;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 199,
      left: -size.width * fixrotation.clamp(0, 0.60),
      right: 0,
      height: size.height * 0.12,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: CutRectangle(),
          ),
        ],
      ),
    );
  }
}

class CutRectangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = kTextWhite;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 10;
    final path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.40, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RecipeName extends StatelessWidget {
  RecipeName({required this.title, required this.recipeByUser});

  final String title;
  final String recipeByUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 40.0,
            fontWeight: FontWeight.w700,
          ),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 5,
        ),
        Text(
          recipeByUser.toUpperCase(),
          style: TextStyle(
            color: kTextBlack[800],
            fontSize: 20.0,
          ),
          overflow: TextOverflow.clip,
          softWrap: false,
          maxLines: 1,
        ),
      ],
    );
  }
}

class MyList extends StatelessWidget {
  MyList({required this.listItems});
  final List<String> listItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.only(bottom: 30.0),
          itemCount: listItems.length,
          shrinkWrap: true,
          itemExtent: 30,
          itemBuilder: (context, index) {
            return ListTile(
              leading: MyBullet(),
              title: Text(listItems[index]),
            );
          }),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        color: kTextBlack[800],
        shape: BoxShape.circle,
      ),
    );
  }
}
