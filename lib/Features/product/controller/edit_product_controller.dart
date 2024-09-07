import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';

enum Bundle {
  kilo,
  hundred,
  thousand,
}

class EditProductController extends GetxController {
  final editProductFormKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  Rx<TextEditingController> productNumberController =
      TextEditingController().obs;
  Rx<TextEditingController> productNameController = TextEditingController().obs;
  // Rx<TextEditingController> productQuantityController =
  //     TextEditingController().obs;
  Rx<TextEditingController> productComissionController =
      TextEditingController().obs;
  Rx<Bundle> bundle = Bundle.kilo.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  @override
  void onClose() {
    scrollController.dispose();
    productNumberController.value.dispose();
    productNameController.value.dispose();
    // productQuantityController.value.dispose();
    productComissionController.value.dispose();
    super.onClose();
  }

  Future<String> editProduct(
    String productId,
    int productNumber,
    String productName,
    // int quantity,
    double commission,
    String bundleType,
  ) async {
    String res = "Some error occured";
    final userId = _auth.currentUser!.uid;

    try {
      Product product = Product(
        userId: userId,
        productId: productId,
        productNumber: productNumber,
        productName: productName,
        // quantity: quantity,
        commission: commission,
        bundleType: bundleType,
      );

      _firestore.collection('product').doc(productId).update(
            product.toJson(),
          );

      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  void editProductInDB({required Product productData}) async {
    isLoading.value = true;

    try {
      String res = await editProduct(
        productData.productId,
        int.parse(productNumberController.value.text.trim()),
        productNameController.value.text.trim(),
        // int.parse(productQuantityController.value.text.trim()),
        double.parse(productComissionController.value.text.trim()),
        bundle.value.name,
      );

      if (res == "Success") {
        productNumberController.value.clear();
        productNameController.value.clear();
        // productQuantityController.value.clear();
        productComissionController.value.clear();
        bundle.value = Bundle.kilo;

        isLoading.value = false;
        Get.back();
        showSnackBar('Saved', Get.context!);
      } else {
        isLoading.value = false;

        showSnackBar(res, Get.context!);
      }
    } catch (e) {
      showSnackBar(e.toString(), Get.context!);
    }
  }
}
