import 'package:animate_do/animate_do.dart';
import 'package:expense_manager/Features/product/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../common_widgets/custom_text_field.dart';
import '../controller/edit_product_controller.dart';

Future<void> showEditProductDialog(
  BuildContext context,
  EditProductController editProductController,
  Product productData,
) {
  editProductController.productNumberController.value.text =
      productData.productNumber.toString();
  editProductController.productNameController.value.text =
      productData.productName;
  editProductController.productQuantityController.value.text =
      productData.quantity.toString();
  editProductController.productComissionController.value.text =
      productData.commission.toString();

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
                controller: editProductController.scrollController,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            children: [
                              SizedBox(
                                child: Form(
                                  key: editProductController.editProductFormKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        child: Text(
                                          'Edit Product',
                                          style: lightTextTheme.bodyLarge!
                                              .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Product Number',
                                        style:
                                            lightTextTheme.bodyMedium!.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      CustomTextField(
                                        keyboardType: TextInputType.number,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return 'Please enter product no';
                                          }
                                          return null;
                                        },
                                        controller: editProductController
                                            .productNumberController.value,
                                        hintText: 'Enter product no',
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Product Name',
                                        style:
                                            lightTextTheme.bodyMedium!.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      CustomTextField(
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return 'Please enter product name';
                                          }
                                          return null;
                                        },
                                        controller: editProductController
                                            .productNameController.value,
                                        hintText: 'Enter product name',
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Quantity',
                                        style:
                                            lightTextTheme.bodyMedium!.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      CustomTextField(
                                        keyboardType: TextInputType.number,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return 'Please enter quantity';
                                          }
                                          return null;
                                        },
                                        controller: editProductController
                                            .productQuantityController.value,
                                        hintText: 'Enter your quantity',
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Commission',
                                        style:
                                            lightTextTheme.bodyMedium!.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      CustomTextField(
                                        keyboardType: TextInputType.number,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return 'Please enter commission';
                                          }
                                          return null;
                                        },
                                        controller: editProductController
                                            .productComissionController.value,
                                        hintText: 'Enter commission',
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Bundle Type',
                                        style:
                                            lightTextTheme.bodyMedium!.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      //kilo
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: editProductController
                                                        .bundle.value ==
                                                    Bundle.kilo
                                                ? primaryColor3
                                                : Colors.black26,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            editProductController.bundle.value =
                                                Bundle.kilo;
                                          },
                                          title: const Text('Kilo'),
                                          textColor: editProductController
                                                      .bundle.value ==
                                                  Bundle.kilo
                                              ? primaryColor3
                                              : Colors.black,
                                          trailing: Radio(
                                            value: Bundle.kilo,
                                            activeColor: editProductController
                                                        .bundle.value ==
                                                    Bundle.kilo
                                                ? primaryColor3
                                                : Colors.black,
                                            groupValue: editProductController
                                                .bundle.value,
                                            onChanged: (Bundle? val) {
                                              editProductController
                                                  .bundle.value = val!;
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      //hundred
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: editProductController
                                                        .bundle.value ==
                                                    Bundle.hundred
                                                ? primaryColor3
                                                : Colors.black26,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            editProductController.bundle.value =
                                                Bundle.hundred;
                                          },
                                          title: const Text('Hundred'),
                                          textColor: editProductController
                                                      .bundle.value ==
                                                  Bundle.hundred
                                              ? primaryColor3
                                              : Colors.black,
                                          trailing: Radio(
                                            value: Bundle.hundred,
                                            activeColor: editProductController
                                                        .bundle.value ==
                                                    Bundle.hundred
                                                ? primaryColor3
                                                : Colors.black,
                                            groupValue: editProductController
                                                .bundle.value,
                                            onChanged: (Bundle? val) {
                                              editProductController
                                                  .bundle.value = val!;
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      //thousand
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: editProductController
                                                        .bundle.value ==
                                                    Bundle.thousand
                                                ? primaryColor3
                                                : Colors.black26,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            editProductController.bundle.value =
                                                Bundle.thousand;
                                          },
                                          title: const Text('Thousand'),
                                          textColor: editProductController
                                                      .bundle.value ==
                                                  Bundle.thousand
                                              ? primaryColor3
                                              : Colors.black,
                                          trailing: Radio(
                                            value: Bundle.thousand,
                                            activeColor: editProductController
                                                        .bundle.value ==
                                                    Bundle.thousand
                                                ? primaryColor3
                                                : Colors.black,
                                            groupValue: editProductController
                                                .bundle.value,
                                            onChanged: (Bundle? val) {
                                              editProductController
                                                  .bundle.value = val!;
                                            },
                                          ),
                                        ),
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
                                  if (editProductController
                                      .editProductFormKey.currentState!
                                      .validate()) {
                                    editProductController.editProductInDB(
                                      productData: productData,
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
        ),
      );
    },
  );
}
