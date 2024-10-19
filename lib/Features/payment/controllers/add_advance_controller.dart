import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/utils.dart';
import '../../customer/model/customer_model.dart';
import '../models/customer_advance_model.dart';

class AddAdvanceController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;
  RxBool isSaveLoading = false.obs;
  final advanceFormKey = GlobalKey<FormState>();

  RxBool isBackDated = false.obs;
  Rx<DateTime?> selectedTransactionDate = Rx<DateTime?>(null);
  DateTime? selectedDate;

  RxList<Customer> customers = <Customer>[].obs;
  Rx<String?> selectedCustomerId = Rx<String?>(null);

  Rx<TextEditingController> advanceAmountController =
      TextEditingController().obs;
  Rx<TextEditingController> remarkController = TextEditingController().obs;

  RxString customerName = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  @override
  void onClose() {
    advanceAmountController.value.dispose();
    remarkController.value.dispose();
    super.onClose();
  }

  Future<void> fetchCustomers() async {
    final uid = _auth.currentUser!.uid;
    isLoading.value = true;
    final snapshot = await firestore
        .collection('customer')
        .where('userId', isEqualTo: uid)
        .where('isActive', isEqualTo: 1)
        .orderBy('customerName')
        .get();

    customers.value =
        snapshot.docs.map((doc) => Customer.fromSnap(doc)).toList();

    isLoading.value = false;
  }

  void fetchAgentDetails(String customerId) {
    Customer? customer = customers.firstWhere(
      (a) => a.customerId == customerId,
    );
    customerName.value = customer.customerName;
  }

  Future<String> addCustomerAdvance({
    required DateTime transactionDate,
    required String customerId,
    required String customerName,
    required double custPaidAmount,
  }) async {
    String res = "Some error occured";

    try {
      String paymentId = const Uuid().v1();
      final userId = _auth.currentUser!.uid;

      CustomerAdvance customerAdvance = CustomerAdvance(
        userId: userId,
        paymentId: paymentId,
        paymentDate: transactionDate,
        customerId: customerId,
        customerName: customerName,
        custPaidAmount: custPaidAmount,
        remark: remarkController.value.text,
      );

      firestore.collection('custAdvance').doc(paymentId).set(
            customerAdvance.toJson(),
          );

      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  void addCustomerAdvanceDB() async {
    isLoading.value = true;
    DateTime selectedDate = selectedTransactionDate.value ?? DateTime.now();

    try {
      String res = await addCustomerAdvance(
        custPaidAmount: double.parse(advanceAmountController.value.text.trim()),
        customerId: selectedCustomerId.value ?? "",
        customerName: customerName.value,
        transactionDate: selectedDate,
      );

      if (res == "Success") {
        advanceAmountController.value.clear();
        remarkController.value.clear();

        isLoading.value = false;
        Get.back();
        showSnackBar('Advanve added', Get.context!);
      } else {
        isLoading.value = false;

        showSnackBar(res, Get.context!);
      }
    } catch (e) {
      showSnackBar(e.toString(), Get.context!);
    } finally {
      isLoading.value = false;
    }
  }
}
