import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ViewPaymentController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMainTransactions() {
    final uid = _auth.currentUser!.uid;

    return firestore
        .collection('salesMain')
        .where('userId', isEqualTo: uid)
        .where('isActive', isEqualTo: 1)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchSubTransactions(
      String salesMainId) {
    return firestore
        .collection('salesDetails')
        .where('salesMainId', isEqualTo: salesMainId)
        .snapshots();
  }
}
