import 'package:expense_manager/Features/common_widgets/custom_button.dart';
import 'package:expense_manager/Features/common_widgets/custom_text_field.dart';
import 'package:expense_manager/Features/product/controller/add_product_controller.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  AddProductController addproductController = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Flower',
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
                            key: addproductController.productFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  'Flower Name',
                                  style: lightTextTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                CustomTextField(
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please enter flower name';
                                    }
                                    return null;
                                  },
                                  controller: addproductController
                                      .productNameController.value,
                                  hintText: 'Enter flower name',
                                ),
                                const SizedBox(height: 10),

                                Text(
                                  'Commission',
                                  style: lightTextTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                CustomTextField(
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please enter commission';
                                    }
                                    if (double.tryParse(val) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    if (double.parse(val) < 0) {
                                      return 'Value cannot be negative';
                                    }
                                    return null;
                                  },
                                  controller: addproductController
                                      .productComissionController.value,
                                  hintText: 'Enter commission',
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Bundle Type',
                                  style: lightTextTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                //kilo
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          addproductController.bundle.value ==
                                                  Bundle.kilo
                                              ? primaryColor3
                                              : Colors.black26,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      addproductController.bundle.value =
                                          Bundle.kilo;
                                    },
                                    title: const Text('Kilo'),
                                    textColor:
                                        addproductController.bundle.value ==
                                                Bundle.kilo
                                            ? primaryColor3
                                            : Colors.black,
                                    trailing: Radio(
                                      value: Bundle.kilo,
                                      activeColor:
                                          addproductController.bundle.value ==
                                                  Bundle.kilo
                                              ? primaryColor3
                                              : Colors.black,
                                      groupValue:
                                          addproductController.bundle.value,
                                      onChanged: (Bundle? val) {
                                        addproductController.bundle.value =
                                            val!;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                //hundred
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          addproductController.bundle.value ==
                                                  Bundle.hundred
                                              ? primaryColor3
                                              : Colors.black26,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      addproductController.bundle.value =
                                          Bundle.hundred;
                                    },
                                    title: const Text('Hundred'),
                                    textColor:
                                        addproductController.bundle.value ==
                                                Bundle.hundred
                                            ? primaryColor3
                                            : Colors.black,
                                    trailing: Radio(
                                      value: Bundle.hundred,
                                      activeColor:
                                          addproductController.bundle.value ==
                                                  Bundle.hundred
                                              ? primaryColor3
                                              : Colors.black,
                                      groupValue:
                                          addproductController.bundle.value,
                                      onChanged: (Bundle? val) {
                                        addproductController.bundle.value =
                                            val!;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                //thousand
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          addproductController.bundle.value ==
                                                  Bundle.thousand
                                              ? primaryColor3
                                              : Colors.black26,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      addproductController.bundle.value =
                                          Bundle.thousand;
                                    },
                                    title: const Text('Thousand'),
                                    textColor:
                                        addproductController.bundle.value ==
                                                Bundle.thousand
                                            ? primaryColor3
                                            : Colors.black,
                                    trailing: Radio(
                                      value: Bundle.thousand,
                                      activeColor:
                                          addproductController.bundle.value ==
                                                  Bundle.thousand
                                              ? primaryColor3
                                              : Colors.black,
                                      groupValue:
                                          addproductController.bundle.value,
                                      onChanged: (Bundle? val) {
                                        addproductController.bundle.value =
                                            val!;
                                      },
                                    ),
                                  ),
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
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                isLoading: addproductController.isLoading.value,
                text: 'Save',
                onTap: () {
                  if (addproductController.productFormKey.currentState!
                      .validate()) {
                    addproductController.addProductToDB();
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
