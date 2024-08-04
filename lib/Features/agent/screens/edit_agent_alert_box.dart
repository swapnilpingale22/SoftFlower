import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../common_widgets/custom_text_field.dart';
import '../controller/edit_agent_controller.dart';
import '../models/agent_model.dart';

Future<void> showEditAgentDialog(
  BuildContext context,
  EditAgentController editAgentController,
  Agent agentData,
) {
  editAgentController.agentNameController.value.text = agentData.agentName;
  editAgentController.cityController.value.text = agentData.agentCity;
  editAgentController.motorRentController.value.text =
      agentData.motorRent.toString();
  editAgentController.jagaBhadeController.value.text =
      agentData.jagaBhade.toString();
  editAgentController.coolieController.value.text = agentData.coolie.toString();
  editAgentController.postageController.value.text =
      agentData.postage.toString();
  editAgentController.caretController.value.text = agentData.caret.toString();

  return showDialog(
    context: context,
    builder: (context) {
      return ZoomIn(
        child: AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: const BoxDecoration(
              color: mobileBackgroundColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            height: Get.height * 0.5,
            width: Get.width * 0.8,
            child: Center(
              child: Scrollbar(
                radius: const Radius.circular(5),
                controller: editAgentController.scrollController,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          children: [
                            SizedBox(
                              child: Form(
                                key: editAgentController.editAgentFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      child: Text(
                                        'Edit Agent',
                                        style:
                                            lightTextTheme.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Agent Name',
                                      style:
                                          lightTextTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    CustomTextField(
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Please enter Agent name';
                                        }
                                        return null;
                                      },
                                      controller: editAgentController
                                          .agentNameController.value,
                                      hintText: 'Enter agent name',
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'City',
                                      style:
                                          lightTextTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    CustomTextField(
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Please enter your city';
                                        }
                                        return null;
                                      },
                                      controller: editAgentController
                                          .cityController.value,
                                      hintText: 'Enter your city',
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Motor Rent',
                                      style:
                                          lightTextTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    CustomTextField(
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Please enter motor rent';
                                        }
                                        return null;
                                      },
                                      controller: editAgentController
                                          .motorRentController.value,
                                      hintText: 'Enter motor rent',
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Jaga Bhade',
                                      style:
                                          lightTextTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    CustomTextField(
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Please enter jaga bhade';
                                        }
                                        return null;
                                      },
                                      controller: editAgentController
                                          .jagaBhadeController.value,
                                      hintText: 'Enter jaga bhade',
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Coolie',
                                      style:
                                          lightTextTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    CustomTextField(
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Please enter coolie';
                                        }
                                        return null;
                                      },
                                      controller: editAgentController
                                          .coolieController.value,
                                      hintText: 'Enter coolie',
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Postage',
                                      style:
                                          lightTextTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    CustomTextField(
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Please enter postage';
                                        }
                                        return null;
                                      },
                                      controller: editAgentController
                                          .postageController.value,
                                      hintText: 'Enter postage',
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Caret',
                                      style:
                                          lightTextTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    CustomTextField(
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Please enter caret';
                                        }

                                        return null;
                                      },
                                      controller: editAgentController
                                          .caretController.value,
                                      hintText: 'Enter caret ',
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  primaryColor3,
                                ),
                              ),
                              child: Text(
                                'Close',
                                style: lightTextTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  primaryColor3,
                                ),
                              ),
                              child: Text(
                                'Save',
                                style: lightTextTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                              onPressed: () {
                                if (editAgentController
                                    .editAgentFormKey.currentState!
                                    .validate()) {
                                  editAgentController.editAgentInDB(
                                    agentData: agentData,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
