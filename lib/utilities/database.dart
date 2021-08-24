import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUtil {
  final String? uid;
  DatabaseUtil({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("userInfo");

  Future updateUserData(String name) async {
    return await userCollection.doc(uid).set({
      "name": name,
    });
  }
}
