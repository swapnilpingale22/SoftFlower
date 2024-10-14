import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/Features/customer/model/customer_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';

class CustomersController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  RxList<Customer> customers = <Customer>[].obs;
  RxList<Customer> filteredCustomers = <Customer>[].obs;
  Rx<TextEditingController> searchCustomersController =
      TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
    filteredCustomers.value = customers;
  }

  void fetchCustomers() {
    final uid = _auth.currentUser!.uid;

    isLoading.value = true;
    firestore
        .collection('customer')
        .where('userId', isEqualTo: uid)
        .where('isActive', isEqualTo: 1)
        .orderBy('customerName')
        .snapshots()
        .listen((snapshot) {
      customers.value =
          snapshot.docs.map((doc) => Customer.fromSnap(doc)).toList();
      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
      log("Error fetching products: $e");
    });
  }

  void searchCustomersByName(String query) {
    if (query.isEmpty) {
      filteredCustomers.value = customers;
    } else {
      filteredCustomers.value = customers
          .where((customer) =>
              customer.customerName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  showCustomerDeleteDialog(
      {required String customerId, required String collectionName}) {
    showCupertinoDialog(
      context: Get.context!,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('Do you really want to delete?'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Yes'),
            onPressed: () async {
              try {
                final documentReference = FirebaseFirestore.instance
                    .collection(collectionName)
                    .doc(customerId);

                await documentReference.update({'isActive': 0})
                    // .delete()
                    .then(
                  (value) {
                    Get.back();
                  },
                );
                // final uid = _auth.currentUser!.uid;
                // //first fetch all trans

                // QuerySnapshot allTransactions = await FirebaseFirestore.instance
                //     .collection('transactionMain')
                //     .where('userId', isEqualTo: uid)
                //     .where('agentId', isEqualTo: agentId)
                //     .get();

                // //set isActive 0  for all trans
                // for (var transaction in allTransactions.docs) {
                //   transaction.reference.update({'isActive': 0});
                //   // showSnackBar('Deleted successfully!', Get.context!);
                //   log('Deleted successfully! ${transaction.reference.id}');
                // }

                // // set isActive 0  for farmer
                // await firestore
                //     .collection(collectionName)
                //     .doc(agentId)
                //     // .delete()
                //     .update({'isActive': 0}).then(
                //   (value) {
                //     Get.back();
                //   },
                // );
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
    );
  }
}
