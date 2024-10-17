import 'package:expense_manager/Features/common_widgets/custom_button.dart';
import 'package:expense_manager/Features/common_widgets/custom_text_field.dart';
import 'package:expense_manager/Features/customer/model/customer_model.dart';
import 'package:expense_manager/Features/product/models/product_model.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:expense_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/add_payment_controller.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  AddPaymentController addPaymentController = Get.put(AddPaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Payment',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(
        () => addPaymentController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: addPaymentController.paymentFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //date section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'SALEORD #${addPaymentController.currentOrderNumber.value.toString().padLeft(4, '0')}',
                                  style: lightTextTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    addPaymentController.selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );

                                    if (addPaymentController.selectedDate !=
                                        null) {
                                      addPaymentController
                                              .selectedTransactionDate.value =
                                          addPaymentController.selectedDate;
                                    }
                                  },
                                  child: Obx(
                                    () => Row(
                                      children: [
                                        const Icon(
                                            Icons.edit_calendar_outlined),
                                        const SizedBox(width: 5),
                                        Text(
                                          addPaymentController
                                                      .selectedTransactionDate
                                                      .value !=
                                                  null
                                              ? DateFormat('dd/MM/yyyy').format(
                                                  addPaymentController
                                                      .selectedTransactionDate
                                                      .value!)
                                              : DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now()),
                                          style: lightTextTheme.bodyMedium!
                                              .copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Container(
                                    //   alignment: Alignment.centerLeft,
                                    //   padding: const EdgeInsets.only(left: 8),
                                    //   height: 50,
                                    //   width: double.infinity,
                                    //   decoration: BoxDecoration(
                                    //     border: Border.all(
                                    //       color: Colors.black12,
                                    //     ),
                                    //     borderRadius: const BorderRadius.all(
                                    //       Radius.circular(10),
                                    //     ),
                                    //   ),
                                    //   child: Text(
                                    //     addPaymentController
                                    //                 .selectedTransactionDate
                                    //                 .value !=
                                    //             null
                                    //         ? DateFormat('dd/MM/yyyy').format(
                                    //             addPaymentController
                                    //                 .selectedTransactionDate
                                    //                 .value!)
                                    //         : 'Select a date',
                                    //     style: lightTextTheme.bodyMedium!
                                    //         .copyWith(
                                    //       fontSize: 14,
                                    //       color: addPaymentController
                                    //                   .selectedTransactionDate
                                    //                   .value !=
                                    //               null
                                    //           ? textColor
                                    //           : secondaryColor,
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Customer Name',
                              style: lightTextTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              child: addPaymentController.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(10),
                                      underline: const SizedBox.shrink(),
                                      isExpanded: true,
                                      dropdownColor: primaryColor3,
                                      value: addPaymentController
                                          .selectedCustomerId.value,
                                      hint: Text(
                                        'Select a Customer',
                                        style: lightTextTheme.headlineMedium
                                            ?.copyWith(
                                          fontSize: 14,
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onChanged: (String? newValue) {
                                        addPaymentController.selectedCustomerId
                                            .value = newValue!;
                                        addPaymentController
                                            .fetchAgentDetails(newValue);
                                      },
                                      items: addPaymentController.customers
                                          .map((Customer customer) {
                                        return DropdownMenuItem<String>(
                                          value: customer.customerId,
                                          child: Text(
                                            customer.customerName,
                                            style: lightTextTheme.headlineMedium
                                                ?.copyWith(
                                                    fontSize: 16,
                                                    color: textColor),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                            ),

                            const SizedBox(height: 10),

                            //balance
                            Visibility(
                              visible: addPaymentController
                                      .selectedCustomerId.value !=
                                  null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Balance',
                                    style: lightTextTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  CustomTextField(
                                    enabled: false,
                                    // keyboardType: TextInputType.number,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return 'Please enter balance';
                                      }
                                      return null;
                                    },
                                    controller: addPaymentController
                                        .balanceController.value,
                                    hintText: 'balance',
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            //flower section
                            Text(
                              'Flower Name',
                              style: lightTextTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              child: addPaymentController.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(10),
                                      underline: const SizedBox.shrink(),
                                      isExpanded: true,
                                      dropdownColor: primaryColor3,
                                      value: addPaymentController
                                          .selectedProductId.value,
                                      hint: Text(
                                        'Select a flower',
                                        style: lightTextTheme.headlineMedium
                                            ?.copyWith(
                                          fontSize: 14,
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onChanged: (String? newValue) {
                                        addPaymentController.selectedProductId
                                            .value = newValue!;
                                        addPaymentController
                                            .fetchProductDetails(newValue);
                                      },
                                      items: addPaymentController.products
                                          .map((Product product) {
                                        return DropdownMenuItem<String>(
                                          value: product.productId,
                                          child: Text(
                                            product.productName,
                                            style: lightTextTheme.headlineMedium
                                                ?.copyWith(
                                                    fontSize: 16,
                                                    color: textColor),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                            ),
                            const SizedBox(height: 10),
                            //
                            Visibility(
                              visible: addPaymentController
                                      .selectedProductId.value !=
                                  null,
                              child: Form(
                                key: addPaymentController.flowerListFormKey,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Quantity',
                                            style: lightTextTheme.bodyMedium!
                                                .copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          CustomTextField(
                                            keyboardType: TextInputType.number,
                                            validator: (val) {
                                              if (val == null || val.isEmpty) {
                                                return 'Enter quantity';
                                              }
                                              return null;
                                            },
                                            controller: addPaymentController
                                                .productQuantityController
                                                .value,
                                            hintText: 'Enter quantity',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Rate',
                                            style: lightTextTheme.bodyMedium!
                                                .copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          CustomTextField(
                                            keyboardType: TextInputType.number,
                                            validator: (val) {
                                              if (val == null || val.isEmpty) {
                                                return 'Enter rate';
                                              }
                                              return null;
                                            },
                                            controller: addPaymentController
                                                .productRateController.value,
                                            hintText: 'Enter rate',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      flex: 2,
                                      child: CustomButton(
                                        text: 'Add item',
                                        fontSize: 14,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        onTap: () {
                                          if (addPaymentController
                                                  .flowerListFormKey
                                                  .currentState !=
                                              null) {
                                            if (addPaymentController
                                                .flowerListFormKey.currentState!
                                                .validate()) {
                                              addPaymentController.addProduct();
                                            }
                                          } else {
                                            showSnackBar(
                                                'Please select a product!',
                                                context);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  addPaymentController.productsList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    addPaymentController
                                        .productsList[index].itemName,
                                  ),
                                  subtitle: Text(
                                      'Qty: ${addPaymentController.productsList[index].itemQuantity.toStringAsFixed(0)}  x  ₹${addPaymentController.productsList[index].itemRate.toStringAsFixed(2)}'),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          addPaymentController
                                              .removeProduct(index);
                                        },
                                        child: Image.asset(
                                          "assets/images/delete.png",
                                          height: 18,
                                          width: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '₹${addPaymentController.productsList[index].totalSale.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        isLoading: addPaymentController.isSaveLoading.value,
                        text: 'Save',
                        onTap: () {
                          if (addPaymentController.selectedCustomerId.value !=
                                  null &&
                              addPaymentController.productsList.isNotEmpty) {
                            if (addPaymentController
                                .paymentFormKey.currentState!
                                .validate()) {
                              addPaymentController.addTransactionMainToDB();
                            }
                          } else {
                            showSnackBar(
                                'Please fill all the fields!', context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
