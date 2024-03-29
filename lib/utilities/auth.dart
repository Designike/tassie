import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/utilities/database.dart';

import '../main.dart';

class AuthUtil {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  EndUser _userFromFirebaseUser(User? user) {
    return EndUser(uid: user?.uid);
  }

  Stream<EndUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Future signInAnon() async {
  //   try {
  //     UserCredential result = await _auth.signInAnonymously();
  //     User? user = result.user;
  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
    }
  }

  Future registerWithEmailAndPasword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseUtil(uid: user?.uid).updateUserData(name);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Future anonSignOut() async {
  //   try {
  //     await FirebaseAuth.instance.currentUser!.delete();
  //     return await _auth.signOut();
  //   } catch (error) {
  //     print(error.toString());
  //     return null;
  //   }
  // }
}
