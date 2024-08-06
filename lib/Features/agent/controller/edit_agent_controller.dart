import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/Features/agent/models/agent_model.dart';
import 'package:expense_manager/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditAgentController extends GetxController {
  final editAgentFormKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  Rx<TextEditingController> agentNameController = TextEditingController().obs;
  Rx<TextEditingController> cityController = TextEditingController().obs;
  Rx<TextEditingController> motorRentController = TextEditingController().obs;
  Rx<TextEditingController> coolieController = TextEditingController().obs;
  Rx<TextEditingController> jagaBhadeController = TextEditingController().obs;
  Rx<TextEditingController> postageController = TextEditingController().obs;
  Rx<TextEditingController> caretController = TextEditingController().obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  @override
  void onClose() {
    scrollController.dispose();
    agentNameController.value.dispose();
    motorRentController.value.dispose();
    coolieController.value.dispose();
    jagaBhadeController.value.dispose();
    cityController.value.dispose();
    postageController.value.dispose();
    caretController.value.dispose();
    super.onClose();
  }

  Future<String> editAgent(
    String agentId,
    String agentName,
    String agentCity,
    double motorRent,
    double coolie,
    double jagaBhade,
    double postage,
    double caret,
  ) async {
    String res = "Some error occured";
    final userId = _auth.currentUser!.uid;

    try {
      Agent agent = Agent(
        userId: userId,
        agentId: agentId,
        agentName: agentName,
        agentCity: agentCity,
        motorRent: motorRent,
        coolie: coolie,
        jagaBhade: jagaBhade,
        postage: postage,
        caret: caret,
      );

      _firestore.collection('agent').doc(agentId).update(
            agent.toJson(),
          );

      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  void editAgentInDB({required Agent agentData}) async {
    isLoading.value = true;

    try {
      String res = await editAgent(
        agentData.agentId,
        agentNameController.value.text.trim(),
        cityController.value.text.trim(),
        double.parse(motorRentController.value.text.trim()),
        double.parse(coolieController.value.text.trim()),
        double.parse(jagaBhadeController.value.text.trim()),
        double.parse(postageController.value.text.trim()),
        double.parse(caretController.value.text.trim()),
      );

      if (res == "Success") {
        agentNameController.value.clear();
        cityController.value.clear();
        motorRentController.value.clear();
        coolieController.value.clear();
        jagaBhadeController.value.clear();
        postageController.value.clear();
        caretController.value.clear();

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
