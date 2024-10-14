import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/utils.dart';
import '../model/customer_model.dart';

class AddCustomerController extends GetxController {
  final customerFormKey = GlobalKey<FormState>();
  Rx<TextEditingController> customerNameController =
      TextEditingController().obs;

  Rx<TextEditingController> openingBalanceController =
      TextEditingController().obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  @override
  void onClose() {
    customerNameController.value.dispose();
    openingBalanceController.value.dispose();
    super.onClose();
  }

  Future<String> addCustomer(
    String customertName,
    double openingBalance,
  ) async {
    String res = "Some error occured";

    try {
      String customerId = const Uuid().v1();
      final userId = _auth.currentUser!.uid;

      Customer customer = Customer(
        customerId: customerId,
        userId: userId,
        customerName: customertName,
        openingBalance: openingBalance,
      );

      _firestore.collection('customer').doc(customerId).set(
            customer.toJson(),
          );

      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  void addCustomerToDB() async {
    isLoading.value = true;

    try {
      String res = await addCustomer(
        customerNameController.value.text.trim(),
        double.parse(openingBalanceController.value.text.trim()),
      );

      if (res == "Success") {
        customerNameController.value.clear();
        openingBalanceController.value.clear();

        isLoading.value = false;
        Get.back();
        showSnackBar('Customer added', Get.context!);
      } else {
        isLoading.value = false;

        showSnackBar(res, Get.context!);
      }
    } catch (e) {
      showSnackBar(e.toString(), Get.context!);
    }
  }
}
