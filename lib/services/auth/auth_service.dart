import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class AuthService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //sign in users
  Future<UserCredential>signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      //add new document for user in users collectioon if doesnt already exists

      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true),
      );

      return userCredential;
    }
    on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }

  }

  //sign out users
  Future<void>signOut() async{
    return await FirebaseAuth.instance.signOut();

  }



  //register new users
  Future<UserCredential>signUpWithEmailAndPassword(String email, password) async
  {
    try{
      UserCredential userCredential =  await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      //after creating user, create a new document for user in users collection
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });


      return userCredential;
    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
}

}