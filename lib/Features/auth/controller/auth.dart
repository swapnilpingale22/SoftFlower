import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart' as model;

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //logging users in

  Future<String> logInUSer({
    required String email,
    required String password,
  }) async {
    String res = "Please fill all the required fields.";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        final result = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        log('result:>>> $result');
        //     .then(
        //   (value) {
        //     log('value:>>> $value');
        //   },
        // );
        res = "Success";
      }
    } on FirebaseException catch (err) {
      log('Error: ${err.message}');
      res = err.message.toString();
    } catch (err) {
      log('Unknown Error: $err');
      res = "An unknown error occurred.";
    }
    return res;
  }

  //sign out user

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  //sign up user

  Future<String> signUpUser({
    required String email,
    required String password,
  }) async {
    String res = "Please fill all the fields.";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        //register user

        UserCredential cred =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        //add user to our database

        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
