import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/utils.dart';
import '../models/product_model.dart';

enum Bundle {
  kilo,
  hundred,
  thousand,
}

class AddProductController extends GetxController {
  final productFormKey = GlobalKey<FormState>();

  Rx<TextEditingController> productNumberController =
      TextEditingController().obs;
  Rx<TextEditingController> productNameController = TextEditingController().obs;
  Rx<TextEditingController> productQuantityController =
      TextEditingController().obs;
  Rx<TextEditingController> productComissionController =
      TextEditingController().obs;
  Rx<Bundle> bundle = Bundle.kilo.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  @override
  void onClose() {
    productNumberController.value.dispose();
    productNameController.value.dispose();
    productQuantityController.value.dispose();
    productComissionController.value.dispose();
    super.onClose();
  }

  Future<String> addProduct(
    int productNumber,
    String productName,
    int quantity,
    double commission,
    String bundleType,
  ) async {
    String res = "Some error occured";

    try {
      String productId = const Uuid().v1();
      final userId = _auth.currentUser!.uid;

      Product product = Product(
        userId: userId,
        productId: productId,
        productNumber: productNumber,
        productName: productName,
        quantity: quantity,
        commission: commission,
        bundleType: bundleType,
      );

      _firestore.collection('product').doc(productId).set(
            product.toJson(),
          );

      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  void addProductToDB() async {
    isLoading.value = true;

    try {
      String res = await addProduct(
        int.parse(productNumberController.value.text.trim()),
        productNameController.value.text.trim(),
        int.parse(productQuantityController.value.text.trim()),
        double.parse(productComissionController.value.text.trim()),
        bundle.value.name,
      );

      if (res == "Success") {
        productNumberController.value.clear();
        productNameController.value.clear();
        productQuantityController.value.clear();
        productComissionController.value.clear();
        bundle.value = Bundle.kilo;

        isLoading.value = false;
        Get.back();
        showSnackBar('Product added', Get.context!);
      } else {
        isLoading.value = false;

        showSnackBar(res, Get.context!);
      }
    } catch (e) {
      showSnackBar(e.toString(), Get.context!);
    }
  }
}
