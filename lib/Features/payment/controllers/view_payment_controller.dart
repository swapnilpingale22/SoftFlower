import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../../../utils/utils.dart';

class ViewPaymentController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool isDeleteLoading = false.obs;

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

  showDeleteDialog(
      {required String transactionId, required String collectionName}) {
    showCupertinoDialog(
      context: Get.context!,
      builder: (context) => Obx(
        () => CupertinoAlertDialog(
          title: const Text('Alert'),
          content: const Text('Do you really want to delete?'),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: isDeleteLoading.value
                  ? const SizedBox(
                      height: 30,
                      child: Center(
                        child: CupertinoActivityIndicator(
                          color: textColor,
                          radius: 30,
                        ),
                      ),
                    )
                  : const Text('Yes'),
              onPressed: () async {
                try {
                  final documentReference = FirebaseFirestore.instance
                      .collection(collectionName)
                      .doc(transactionId);

                  await documentReference.update({'isActive': 0}).then(
                    (value) {
                      Get.back();
                      isDeleteLoading.value = false;
                    },
                  );
                } catch (e) {
                  showSnackBar(e.toString(), Get.context!);
                }

                showSnackBar('Deleted successfully!', Get.context!);
              },
            ),
            CupertinoDialogAction(
              child: const Text('No'),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}
