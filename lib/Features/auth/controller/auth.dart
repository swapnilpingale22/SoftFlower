import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  // Future<void> signInWithEmailAndPassword({
  //   required String email,
  //   required String password,
  // }) async {
  //   await _firebaseAuth.signInWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  // }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    // .then(
    //   (value) {
    //     Navigator.pushReplacement(
    //         Get.context!,
    //         MaterialPageRoute(
    //           builder: (context) => const LoginScreen(),
    //         ));
    //   },
    // );
  }
}
