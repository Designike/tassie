import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUtil {
  final String? uid;
  DatabaseUtil({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("userInfo");
  
  final CollectionReference recipeCollection = FirebaseFirestore.instance.collection("recipes");

  Future updateUserData(String name) async {
    return await userCollection.doc(uid).set({
      "name": name,
    });
  }

  Future addNewRecipe(String recipeName, List<String?> ingredients, List<String?> steps) async {
    return await recipeCollection.doc(uid).set({
      "recipeName": recipeName,
      "ingredients": ingredients,
      "steps": steps
    });
  }
}
