import 'package:expense_manager/Features/agent/models/agent_model.dart';
import 'package:expense_manager/Features/common_widgets/custom_button.dart';
import 'package:expense_manager/Features/common_widgets/custom_text_field.dart';
import 'package:expense_manager/Features/product/models/product_model.dart';
import 'package:expense_manager/Features/transactions/controller/add_transaction_controller.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:expense_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  AddTransactionController addTransactionController =
      Get.put(AddTransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Patti',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(
        () => addTransactionController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: addTransactionController.transactionFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //date section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    addTransactionController
                                        .selectedTransactionDate
                                        .value = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );

                                    if (addTransactionController
                                            .selectedTransactionDate.value !=
                                        null) {
                                      addTransactionController
                                              .selectedTransactionDate.value =
                                          addTransactionController
                                              .selectedTransactionDate.value;
                                    }
                                  },
                                  child: Obx(
                                    () => Row(
                                      children: [
                                        const Icon(
                                            Icons.edit_calendar_outlined),
                                        const SizedBox(width: 5),
                                        Text(
                                          addTransactionController
                                                      .selectedTransactionDate
                                                      .value !=
                                                  null
                                              ? DateFormat('dd/MM/yyyy').format(
                                                  addTransactionController
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
                                  ),
                                ),
                              ],
                            ),
                            //agent section
                            Text(
                              'Farmer Name',
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
                              child: addTransactionController.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(10),
                                      underline: const SizedBox.shrink(),
                                      isExpanded: true,
                                      dropdownColor: primaryColor3,
                                      value: addTransactionController
                                          .selectedAgentId.value,
                                      hint: Text(
                                        'Select a farmer',
                                        style: lightTextTheme.headlineMedium
                                            ?.copyWith(
                                          fontSize: 14,
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onChanged: (String? newValue) {
                                        addTransactionController
                                            .selectedAgentId.value = newValue!;
                                        addTransactionController
                                            .fetchAgentDetails(newValue);
                                      },
                                      items: addTransactionController.agents
                                          .map((Agent agent) {
                                        return DropdownMenuItem<String>(
                                          value: agent.agentId,
                                          child: Text(
                                            agent.agentName,
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

                            Visibility(
                              visible: addTransactionController
                                      .selectedAgentId.value !=
                                  null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Daag/Box',
                                    style: lightTextTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  CustomTextField(
                                    keyboardType: TextInputType.number,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return 'Please enter daag/box';
                                      }
                                      if (int.tryParse(val) == null) {
                                        return 'Please enter a valid number';
                                      }
                                      if (int.parse(val) < 0) {
                                        return 'Value cannot be negative';
                                      }
                                      return null;
                                    },
                                    controller: addTransactionController
                                        .productBoxController.value,
                                    hintText: 'Enter daag/box',
                                    onChanged: (daagValue) {
                                      addTransactionController
                                          .updateCalculatedFields();
                                    },
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
                                        return 'Motor rent cannot be negative';
                                      }
                                      return null;
                                    },
                                    controller: addTransactionController
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
                                    controller: addTransactionController
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
                                    controller: addTransactionController
                                        .coolieController.value,
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
                                    controller: addTransactionController
                                        .postageController.value,
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
                                    controller: addTransactionController
                                        .caretController.value,
                                    hintText: 'Enter caret ',
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),

                            //product section
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
                              child: addTransactionController.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(10),
                                      underline: const SizedBox.shrink(),
                                      isExpanded: true,
                                      dropdownColor: primaryColor3,
                                      value: addTransactionController
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
                                        addTransactionController
                                            .selectedProductId
                                            .value = newValue!;
                                        addTransactionController
                                            .fetchProductDetails(newValue);
                                      },
                                      items: addTransactionController.products
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
                              visible: addTransactionController
                                      .selectedProductId.value !=
                                  null,
                              child: Form(
                                key:
                                    addTransactionController.productListFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                        if (double.tryParse(val) == null) {
                                          return 'Please enter a valid number';
                                        }
                                        if (double.parse(val) < 0) {
                                          return 'Value cannot be negative';
                                        }
                                        return null;
                                      },
                                      controller: addTransactionController
                                          .productCommissionController.value,
                                      hintText: 'Enter commission',
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Quantity',
                                                style: lightTextTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              CustomTextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (val) {
                                                  if (val == null ||
                                                      val.isEmpty) {
                                                    return 'Enter quantity';
                                                  }
                                                  if (double.tryParse(val) ==
                                                      null) {
                                                    return 'Please enter a valid number';
                                                  }
                                                  if (double.parse(val) < 0) {
                                                    return 'Value cannot be negative';
                                                  }
                                                  return null;
                                                },
                                                controller:
                                                    addTransactionController
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
                                                style: lightTextTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              CustomTextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (val) {
                                                  if (val == null ||
                                                      val.isEmpty) {
                                                    return 'Enter rate';
                                                  }
                                                  if (double.tryParse(val) ==
                                                      null) {
                                                    return 'Please enter a valid number';
                                                  }
                                                  if (double.parse(val) < 0) {
                                                    return 'Value cannot be negative';
                                                  }
                                                  return null;
                                                },
                                                controller:
                                                    addTransactionController
                                                        .productRateController
                                                        .value,
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
                                              if (addTransactionController
                                                      .productListFormKey
                                                      .currentState !=
                                                  null) {
                                                if (addTransactionController
                                                    .productListFormKey
                                                    .currentState!
                                                    .validate()) {
                                                  addTransactionController
                                                      .addProduct();
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
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  addTransactionController.productsList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    addTransactionController
                                        .productsList[index].itemName,
                                  ),
                                  subtitle: Text(
                                      'Qty: ${addTransactionController.productsList[index].itemQuantity.toStringAsFixed(0)}  x  ₹${addTransactionController.productsList[index].itemRate.toStringAsFixed(2)}'),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          addTransactionController
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
                                        '₹${addTransactionController.productsList[index].totalSale.toStringAsFixed(2)}',
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
                        isLoading: addTransactionController.isSaveLoading.value,
                        text: 'Save',
                        onTap: () {
                          if (addTransactionController.selectedAgentId.value !=
                                      null &&
                                  addTransactionController
                                      .productsList.isNotEmpty
                              // && addTransactionController
                              //         .selectedCompanyId.value !=
                              //     null
                              ) {
                            if (addTransactionController
                                .transactionFormKey.currentState!
                                .validate()) {
                              addTransactionController.addTransactionMainToDB();
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
