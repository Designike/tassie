import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUtil {
  final String? uid;
  DatabaseUtil({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("userInfo");

  final databaseReference = FirebaseFirestore.instance;

  Future updateUserData(String name) async {
    return await userCollection.doc(uid).set({
      "name": name,
    });
  }

  Future addNewRecipe(
      String recipeName, List<String?> ingredients, List<String?> steps) async {
    return await databaseReference
        .collection("recipeCollection")
        .doc(uid)
        .collection("userRecipeCollection")
        .doc(recipeName)
        .set(
      {
        "recipeName": recipeName,
        "ingredients": ingredients,
        "steps": steps,
      },
      SetOptions(merge: true),
    );
  }

  // late List<String> recipename = [];
  // Future myRecipe() async {
  //   Stream<QuerySnapshot> querySnapshot = FirebaseFirestore.instance
  //       .collection("recipeCollection")
  //       .doc(uid)
  //       .collection("userRecipeCollection")
  //       .snapshots();
  //   querySnapshot.forEach((field) {
  //     field.docs.asMap().forEach((index, data) {
  //       recipename.add(field.docs[index]["recipeName"]);
  //     });
  //   });
  //   return recipename;
  // for (var queryDocumentSnapshot in querySnapshot.docs) {
  //   Map<String, dynamic> data = queryDocumentSnapshot.data();

  //   name.add(data["recipeName"]);

  //   return name;
  // }
  // }
}
