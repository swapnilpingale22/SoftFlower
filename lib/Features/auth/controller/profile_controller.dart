import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';
import '../models/user_model.dart' as model;

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  Rx<model.User?> userData = Rx<model.User?>(null);

  getData() async {
    isLoading.value = true;

    final uid = _auth.currentUser!.uid;

    try {
      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      userData.value = model.User.fromSnap(userSnap);
    } catch (e) {
      showSnackBar(e.toString(), Get.context!);
    }
    isLoading.value = false;
  }

  // void createNewUser(String email, String password) async {
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     log('New user created: ${userCredential.user?.uid}');
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       log('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       log('The account already exists for that email.');
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }
}
