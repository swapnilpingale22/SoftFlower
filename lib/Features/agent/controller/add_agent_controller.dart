import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/Features/agent/models/agent_model.dart';
import 'package:expense_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddAgentController extends GetxController {
  final agentFormKey = GlobalKey<FormState>();

  Rx<TextEditingController> agentNameController = TextEditingController().obs;
  Rx<TextEditingController> cityController = TextEditingController().obs;
  Rx<TextEditingController> motorRentController = TextEditingController().obs;
  Rx<TextEditingController> coolieController = TextEditingController().obs;
  Rx<TextEditingController> postageController = TextEditingController().obs;
  Rx<TextEditingController> caretController = TextEditingController().obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;

  @override
  void onClose() {
    agentNameController.value.dispose();
    motorRentController.value.dispose();
    coolieController.value.dispose();
    cityController.value.dispose();
    postageController.value.dispose();
    super.onClose();
  }

  Future<String> addAgent(
    String agentName,
    String agentCity,
    double motorRent,
    double coolie,
    double postage,
    double caret,
  ) async {
    String res = "Some error occured";

    try {
      String agentId = const Uuid().v1();

      Agent agent = Agent(
        agentId: agentId,
        agentName: agentName,
        agentCity: agentCity,
        motorRent: motorRent,
        coolie: coolie,
        postage: postage,
        caret: caret,
      );

      _firestore.collection('agent').doc(agentId).set(
            agent.toJson(),
          );

      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  void addAgentToDB() async {
    isLoading.value = true;

    try {
      String res = await addAgent(
        agentNameController.value.text.trim(),
        cityController.value.text.trim(),
        double.parse(motorRentController.value.text.trim()),
        double.parse(coolieController.value.text.trim()),
        double.parse(postageController.value.text.trim()),
        double.parse(caretController.value.text.trim()),
      );

      if (res == "Success") {
        agentNameController.value.clear();
        cityController.value.clear();
        motorRentController.value.clear();
        coolieController.value.clear();
        postageController.value.clear();
        caretController.value.clear();

        isLoading.value = false;
        Get.back();
        showSnackBar('Agent added', Get.context!);
      } else {
        isLoading.value = false;

        showSnackBar(res, Get.context!);
      }
    } catch (e) {
      showSnackBar(e.toString(), Get.context!);
    }
  }
}
