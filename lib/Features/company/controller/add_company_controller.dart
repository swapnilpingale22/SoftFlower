import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/Features/company/models/company_model.dart';
import 'package:expense_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddCompanyController extends GetxController {
  final companyFormKey = GlobalKey<FormState>();

  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  Rx<TextEditingController> ownerNameController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> cityTownController = TextEditingController().obs;
  Rx<TextEditingController> pincodeController = TextEditingController().obs;
  Rx<TextEditingController> contactNoController = TextEditingController().obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;

  @override
  void onClose() {
    companyNameController.value.dispose();
    ownerNameController.value.dispose();
    addressController.value.dispose();
    cityTownController.value.dispose();
    pincodeController.value.dispose();
    super.onClose();
  }

  Future<String> addCompany(
    String companyName,
    String ownerName,
    String address,
    String city,
    int pincode,
    int mobileNumber,
  ) async {
    String res = "Some error occured";

    try {
      String companyId = const Uuid().v1();

      Company product = Company(
        companyId: companyId,
        companyName: companyName,
        ownerName: ownerName,
        address: address,
        city: city,
        pincode: pincode,
        mobileNumber: mobileNumber,
      );

      _firestore.collection('company').doc(companyId).set(
            product.toJson(),
          );

      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  void addCompanyToDB() async {
    isLoading.value = true;

    try {
      String res = await addCompany(
        companyNameController.value.text.trim(),
        ownerNameController.value.text.trim(),
        addressController.value.text.trim(),
        cityTownController.value.text.trim(),
        int.parse(pincodeController.value.text.trim()),
        int.parse(contactNoController.value.text.trim()),
      );

      if (res == "Success") {
        companyNameController.value.clear();
        ownerNameController.value.clear();
        addressController.value.clear();
        cityTownController.value.clear();
        pincodeController.value.clear();
        contactNoController.value.clear();

        isLoading.value = false;
        Get.back();
        showSnackBar('Company added', Get.context!);
      } else {
        isLoading.value = false;

        showSnackBar(res, Get.context!);
      }
    } catch (e) {
      showSnackBar(e.toString(), Get.context!);
    }
  }
}
