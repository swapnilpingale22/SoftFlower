import 'package:expense_manager/Features/common_widgets/custom_button.dart';
import 'package:expense_manager/Features/common_widgets/custom_text_field.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/add_company_controller.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({super.key});

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  AddCompanyController addCompanyController = Get.put(AddCompanyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Company',
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
                          key: addCompanyController.companyFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Company Name',
                                style: lightTextTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CustomTextField(
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please enter company name';
                                  }
                                  return null;
                                },
                                controller: addCompanyController
                                    .companyNameController.value,
                                hintText: 'Enter company name',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Owner Name',
                                style: lightTextTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CustomTextField(
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please enter owner name';
                                  }
                                  return null;
                                },
                                controller: addCompanyController
                                    .ownerNameController.value,
                                hintText: 'Enter owner name',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Address',
                                style: lightTextTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CustomTextField(
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please enter your address';
                                  }
                                  return null;
                                },
                                controller: addCompanyController
                                    .addressController.value,
                                hintText: 'Enter your address',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'City/Town',
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
                                controller: addCompanyController
                                    .cityTownController.value,
                                hintText: 'Enter your city',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Pin code',
                                style: lightTextTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CustomTextField(
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please enter your pincode';
                                  }
                                  if (int.tryParse(val) == null) {
                                    return 'Number must contain only digits';
                                  }
                                  if (val.length < 6) {
                                    return 'Enter minimum 6 digit number';
                                  }

                                  return null;
                                },
                                controller: addCompanyController
                                    .pincodeController.value,
                                hintText: 'Enter your pin code',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Contact No',
                                style: lightTextTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CustomTextField(
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please enter your contact no';
                                  }
                                  if (int.tryParse(val) == null) {
                                    return 'Mobile number must contain only digits';
                                  }
                                  if (val.length != 10) {
                                    return 'Enter valid mobile number';
                                  }

                                  return null;
                                },
                                controller: addCompanyController
                                    .contactNoController.value,
                                hintText: 'Enter your contact no',
                                keyboardType: TextInputType.number,
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
                isLoading: addCompanyController.isLoading.value,
                text: 'Save',
                onTap: () {
                  if (addCompanyController.companyFormKey.currentState!
                      .validate()) {
                    addCompanyController.addCompanyToDB();
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
