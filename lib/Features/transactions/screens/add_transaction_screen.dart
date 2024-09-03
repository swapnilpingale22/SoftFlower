import 'package:expense_manager/Features/agent/models/agent_model.dart';
import 'package:expense_manager/Features/common_widgets/custom_button.dart';
import 'package:expense_manager/Features/common_widgets/custom_text_field.dart';
import 'package:expense_manager/Features/company/models/company_model.dart';
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
          'Add Transaction',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: //const CommingSoonScreen()
          Obx(
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
                            Text(
                              'Company Name',
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
                                      underline: const SizedBox.shrink(),
                                      isExpanded: true,
                                      dropdownColor: primaryColor3,
                                      value: addTransactionController
                                          .selectedCompanyId.value,
                                      hint: Text(
                                        'Select a company',
                                        style: lightTextTheme.headlineMedium
                                            ?.copyWith(
                                          fontSize: 14,
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onChanged: (String? newValue) {
                                        addTransactionController
                                            .selectedCompanyId
                                            .value = newValue!;
                                        addTransactionController
                                            .fetchCompanyDetails(newValue);
                                      },
                                      items: addTransactionController.companies
                                          .map((Company company) {
                                        return DropdownMenuItem<String>(
                                          value: company.companyName,
                                          child: Text(
                                            company.companyName,
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
                            //agent section
                            Text(
                              'Agent Name',
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
                                      underline: const SizedBox.shrink(),
                                      isExpanded: true,
                                      dropdownColor: primaryColor3,
                                      value: addTransactionController
                                          .selectedAgentId.value,
                                      hint: Text(
                                        'Select an agent',
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
                            //date section
                            Text(
                              'Transaction Date',
                              style: lightTextTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            GestureDetector(
                              onTap: () async {
                                DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );

                                if (selectedDate != null) {
                                  addTransactionController
                                      .selectedTransactionDate
                                      .value = selectedDate;
                                }
                              },
                              child: Obx(
                                () => Text(
                                  addTransactionController
                                              .selectedTransactionDate.value !=
                                          null
                                      ? DateFormat('dd-MM-yyyy').format(
                                          addTransactionController
                                              .selectedTransactionDate.value!)
                                      : 'Select a date',
                                  style: lightTextTheme.bodyMedium!.copyWith(
                                    fontSize: 16,
                                    color: addTransactionController
                                                .selectedTransactionDate
                                                .value !=
                                            null
                                        ? textColor
                                        : secondaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            //product section
                            Text(
                              'Product Name',
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
                                      underline: const SizedBox.shrink(),
                                      isExpanded: true,
                                      dropdownColor: primaryColor3,
                                      value: addTransactionController
                                          .selectedProductId.value,
                                      hint: Text(
                                        'Select a product',
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
                                      controller: addTransactionController
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
                                      controller: addTransactionController
                                          .productComissionController.value,
                                      hintText: 'Enter commission',
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Daag/Box',
                                      style:
                                          lightTextTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    CustomTextField(
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Please enter daag/box';
                                        }
                                        return null;
                                      },
                                      controller: addTransactionController
                                          .productBoxController.value,
                                      hintText: 'Enter daag/box',
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Rate',
                                      style:
                                          lightTextTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    CustomTextField(
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Please enter rate';
                                        }
                                        return null;
                                      },
                                      controller: addTransactionController
                                          .productRateController.value,
                                      hintText: 'Enter rate',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            CustomButton(
                              text: 'Add to list',
                              onTap: () {
                                if (addTransactionController
                                        .productListFormKey.currentState !=
                                    null) {
                                  if (addTransactionController
                                      .productListFormKey.currentState!
                                      .validate()) {
                                    addTransactionController.addProduct();
                                  }
                                } else {
                                  showSnackBar(
                                      'Please select a product!', context);
                                }
                              },
                            ),
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
                                      'Rate: ${addTransactionController.productsList[index].itemRate}, Qty: ${addTransactionController.productsList[index].itemQuantity}, Total Sale: ${addTransactionController.productsList[index].totalSale}'),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      addTransactionController
                                          .removeProduct(index);
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
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
                                      .selectedCompanyId.value !=
                                  null &&
                              addTransactionController
                                  .productsList.isNotEmpty) {
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
