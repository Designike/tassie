import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/screens/Error/error.dart';
import 'package:tassie/screens/wrapper.dart';
import 'package:tassie/utilities/auth.dart';
import 'package:tassie/utilities/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants.dart';

class NewRecipe extends StatefulWidget {
  late final EndUser? user;
  late final String? name;
  late final List<String> recipes;
  NewRecipe({this.user, this.name, required this.recipes});
  @override
  _NewRecipeState createState() => _NewRecipeState(user: user, name: name);
}

class _NewRecipeState extends State<NewRecipe> {
  late final EndUser? user;
  late final String? name;
  late String imageUrl = "";
  _NewRecipeState({this.user, this.name});

  List<Widget> _getRecipe() {
    List<Widget> recipeTextFields = [];
    for (int i = 0; i < stepsList.length; i++) {
      recipeTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: StepTextField(index: i)),
            SizedBox(
              width: 16,
            ),
            _addRemoveButtonR(i == 0, stepsList.length - 1, i),
          ],
        ),
      ));
    }
    return recipeTextFields;
  }

  Widget _addRemoveButtonR(bool add, int index, int i) {
    return InkWell(
      onTap: () {
        if (add) {
          stepsList.insert(index + 1, "");
        } else
          stepsList.removeAt(i);
        if (this.mounted) {
          setState(() {});
        }
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? kPrimaryColor : kTextBlack[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Widget> _getIngredient() {
    List<Widget> ingredientsTextFields = [];
    for (int i = 0; i < ingredientsList.length; i++) {
      ingredientsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: IngredientTextField(index: i)),
            SizedBox(
              width: 16,
            ),
            _addRemoveButtonI(i == 0, ingredientsList.length - 1, i),
          ],
        ),
      ));
    }
    return ingredientsTextFields;
  }

  Widget _addRemoveButtonI(bool add, int index, int i) {
    return InkWell(
      onTap: () {
        if (add) {
          ingredientsList.insert(index + 1, "");
        } else
          ingredientsList.removeAt(i);
        if (this.mounted) {
          setState(() {});
        }
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? kPrimaryColor : kTextBlack[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  /// add / remove button

  Future uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      var image = (await _imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 25));
      var file = File(image!.path);

      // ignore: unnecessary_null_comparison
      if (image != null) {
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('images/${user!.uid}/$recipeName')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        if (this.mounted) {
          setState(() {
            imageUrl = downloadUrl;
          });
        }
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  Future<void> setList(EndUser? user, String? name) async {
    if (name!.length == 0) {
      stepsList = [null];
      ingredientsList = [null];
    } else {
      await FirebaseFirestore.instance
          .collection('recipeCollection')
          .doc(user?.uid)
          .collection('userRecipeCollection')
          .doc(name)
          .get()
          .then((doc) {
        stepsList = new List<String>.from(doc["steps"]);
        ingredientsList = new List<String>.from(doc["ingredients"]);
      });
      final ref =
          FirebaseStorage.instance.ref().child('images/${user!.uid}/$name');
      var url = await ref.getDownloadURL();
      if (this.mounted) {
        setState(() {
          imageUrl = url;
        });
      }
    }
  }

  final AuthUtil _auth = AuthUtil();
  TextEditingController _stepController = TextEditingController();
  TextEditingController _ingredientController = TextEditingController();
  static List<String?> stepsList = [null];
  static List<String?> ingredientsList = [null];
  String recipeName = "";
  String error = "";
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    setList(user, name);
    _stepController = TextEditingController();
    _ingredientController = TextEditingController();
  }

  @override
  void dispose() {
    _stepController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // add recipe text
                Padding(
                  padding: const EdgeInsets.only(
                    top: kDefaultPadding * 2,
                    bottom: kDefaultPadding,
                  ),
                  child: Text(
                    "Add new\nrecipe!",
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ),

                //upload image

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hey, pick some mouth watering photo 😋",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        width: size.width,
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        child: (imageUrl != "")
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                placeholder: (context, url) => Container(
                                  height: size.width,
                                  width: size.width,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                      backgroundColor: kPrimaryColor,
                                      color: kTextBlack[800],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          kTextBlack[800]!)),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: 'https://i.imgur.com/sUFH1Aq.png',
                                placeholder: (context, url) => Container(
                                  height: size.width,
                                  width: size.width,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                      backgroundColor: kPrimaryColor,
                                      color: kTextBlack[800],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          kTextBlack[800]!)),
                                ),
                              ),
                      ),
                      if (error != "") ...[
                        Center(
                          child: Text(
                            error,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          if (recipeName.length == 0) {
                            if (this.mounted) {
                              setState(() {
                                error = "Please write a name first";
                              });
                            }
                          } else {
                            if (this.mounted) {
                              setState(() {
                                error = "";
                              });
                            }
                            uploadImage();
                          }
                        },
                        child: Container(
                          height: 40.0,
                          width: size.width * 0.3,
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            shadowColor: kTextBlack[700],
                            color: kTextBlack[800],
                            elevation: 5.0,
                            child: Center(
                              child: Text(
                                'Upload',
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: kDefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Recipe Name',
                            labelStyle: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 20.0,
                              color: kTextBlack[800]!.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor),
                            ),
                          ),
                          onChanged: (val) {
                            if (this.mounted) {
                              setState(() {
                                recipeName = val.toLowerCase();
                              });
                            }
                          },
                          validator: (v) {
                            if (v!.trim().isEmpty)
                              return 'Please enter something';
                            if (widget.recipes.contains(v) == true)
                              return "Already used Recipe Name";
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Ingredients',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                        ..._getIngredient(),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Steps',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                        ..._getRecipe(),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () async {
                            try {
                              if (imageUrl == "") {
                                if (this.mounted) {
                                  setState(() {
                                    error = "Please upload a photo";
                                  });
                                } else {
                                  if (this.mounted) {
                                    setState(() {
                                      error = "";
                                    });
                                  }
                                }
                              }
                              if (_formKey.currentState!.validate() == true &&
                                  imageUrl != "") {
                                _formKey.currentState?.save();
                                if (name != "") {
                                  await DatabaseUtil(uid: user?.uid)
                                      .addNewRecipe(
                                          name!, ingredientsList, stepsList);
                                } else {
                                  await DatabaseUtil(uid: user?.uid)
                                      .addNewRecipe(recipeName, ingredientsList,
                                          stepsList);
                                }
                                await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return Wrapper();
                                  }),
                                );
                              }
                            } catch (e) {
                              print(e);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return UError(
                                    user: user,
                                  );
                                }),
                              );
                            }
                          },
                          child: Container(
                            height: 40.0,
                            width: size.width * 0.3,
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              shadowColor: kTextBlack[700],
                              color: kTextBlack[800],
                              elevation: 5.0,
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100.0,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StepTextField extends StatefulWidget {
  late final int? index;

  StepTextField({this.index});
  @override
  _StepTextFieldState createState() => _StepTextFieldState();
}

class _StepTextFieldState extends State<StepTextField> {
  late TextEditingController _stepController;
  @override
  void initState() {
    super.initState();
    _stepController = TextEditingController();
  }

  @override
  void dispose() {
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _stepController.text = _NewRecipeState.stepsList[widget.index!] ?? '';
    });
    return TextFormField(
      controller: _stepController,
      onChanged: (v) =>
          _NewRecipeState.stepsList[widget.index!] = v.toLowerCase(),
      decoration: InputDecoration(
        labelText: 'Add Step',
        labelStyle: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 20.0,
          color: kTextBlack[800]!.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
      validator: (v) {
        if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}

class IngredientTextField extends StatefulWidget {
  late final int? index;

  IngredientTextField({this.index});
  @override
  _IngredientTextFieldState createState() => _IngredientTextFieldState();
}

class _IngredientTextFieldState extends State<IngredientTextField> {
  late TextEditingController _ingredientController;
  @override
  void initState() {
    super.initState();
    _ingredientController = TextEditingController();
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _ingredientController.text =
          _NewRecipeState.ingredientsList[widget.index!] ?? '';
    });
    return TextFormField(
      controller: _ingredientController,
      onChanged: (v) =>
          _NewRecipeState.ingredientsList[widget.index!] = v.toLowerCase(),
      decoration: InputDecoration(
        labelText: 'Add Ingredient',
        labelStyle: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 20.0,
          color: kTextBlack[800]!.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
      validator: (v) {
        if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
