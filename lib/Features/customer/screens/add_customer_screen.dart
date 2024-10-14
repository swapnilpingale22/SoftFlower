import 'package:expense_manager/Features/common_widgets/custom_button.dart';
import 'package:expense_manager/Features/common_widgets/custom_text_field.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/add_customer_controller.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  AddCustomerController addCustomerController =
      Get.put(AddCustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Customer',
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
              child: Obx(
                () => Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          child: Form(
                            key: addCustomerController.customerFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  'Name',
                                  style: lightTextTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                CustomTextField(
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please enter name';
                                    }
                                    return null;
                                  },
                                  controller: addCustomerController
                                      .customerNameController.value,
                                  hintText: 'Enter customer name',
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Opening Balance',
                                  style: lightTextTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                CustomTextField(
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please enter opening balance';
                                    }
                                    return null;
                                  },
                                  controller: addCustomerController
                                      .openingBalanceController.value,
                                  hintText: 'Enter opening balance',
                                ),
                                const SizedBox(height: 10),
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
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                isLoading: addCustomerController.isLoading.value,
                text: 'Save',
                onTap: () {
                  if (addCustomerController.customerFormKey.currentState!
                      .validate()) {
                    addCustomerController.addCustomerToDB();
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
