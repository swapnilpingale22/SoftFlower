import 'package:expense_manager/Features/agent/controller/add_agent_controller.dart';
import 'package:expense_manager/Features/common_widgets/custom_button.dart';
import 'package:expense_manager/Features/common_widgets/custom_text_field.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAgentScreen extends StatefulWidget {
  const AddAgentScreen({super.key});

  @override
  State<AddAgentScreen> createState() => _AddAgentScreenState();
}

class _AddAgentScreenState extends State<AddAgentScreen> {
  AddAgentController addAgentController = Get.put(AddAgentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Farmer',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        child: Form(
                          key: addAgentController.agentFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Farmer Name',
                                style: lightTextTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CustomTextField(
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please enter Farmer name';
                                  }
                                  return null;
                                },
                                controller: addAgentController
                                    .agentNameController.value,
                                hintText: 'Enter farmer name',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'City',
                                style: lightTextTheme.bodyMedium!.copyWith(
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
                                controller:
                                    addAgentController.cityController.value,
                                hintText: 'Enter your city',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Motor Rent',
                                style: lightTextTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.number,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please enter motor rent';
                                  }
                                  if (double.tryParse(val) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (double.parse(val) < 0) {
                                    return 'Value cannot be negative';
                                  }
                                  return null;
                                },
                                controller: addAgentController
                                    .motorRentController.value,
                                hintText: 'Enter motor rent',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Jaga Bhade',
                                style: lightTextTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.number,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please enter jaga bhade';
                                  }
                                  if (double.tryParse(val) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (double.parse(val) < 0) {
                                    return 'Value cannot be negative';
                                  }
                                  return null;
                                },
                                controller: addAgentController
                                    .jagaBhadeController.value,
                                hintText: 'Enter jaga bhade',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Coolie',
                                style: lightTextTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.number,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please enter coolie';
                                  }
                                  if (double.tryParse(val) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (double.parse(val) < 0) {
                                    return 'Value cannot be negative';
                                  }
                                  return null;
                                },
                                controller:
                                    addAgentController.coolieController.value,
                                hintText: 'Enter coolie',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Postage',
                                style: lightTextTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.number,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please enter postage';
                                  }
                                  if (double.tryParse(val) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (double.parse(val) < 0) {
                                    return 'Value cannot be negative';
                                  }
                                  return null;
                                },
                                controller:
                                    addAgentController.postageController.value,
                                hintText: 'Enter postage',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Caret',
                                style: lightTextTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.number,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please enter caret';
                                  }
                                  if (double.tryParse(val) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (double.parse(val) < 0) {
                                    return 'Value cannot be negative';
                                  }

                                  return null;
                                },
                                controller:
                                    addAgentController.caretController.value,
                                hintText: 'Enter caret ',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                isLoading: addAgentController.isLoading.value,
                text: 'Save',
                onTap: () {
                  if (addAgentController.agentFormKey.currentState!
                      .validate()) {
                    addAgentController.addAgentToDB();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
