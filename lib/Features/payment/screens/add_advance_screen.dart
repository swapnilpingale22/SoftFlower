import 'package:expense_manager/Features/common_widgets/custom_button.dart';
import 'package:expense_manager/Features/common_widgets/custom_text_field.dart';
import 'package:expense_manager/Features/customer/model/customer_model.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/add_advance_controller.dart';

class AddAdvanceScreen extends StatefulWidget {
  const AddAdvanceScreen({super.key});

  @override
  State<AddAdvanceScreen> createState() => _AddAdvanceScreenState();
}

class _AddAdvanceScreenState extends State<AddAdvanceScreen> {
  AddAdvanceController addAdvanceController = Get.put(AddAdvanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Advance',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(
        () => addAdvanceController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: addAdvanceController.advanceFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //date section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    addAdvanceController.selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );

                                    if (addAdvanceController.selectedDate !=
                                        null) {
                                      addAdvanceController
                                              .selectedTransactionDate.value =
                                          addAdvanceController.selectedDate;
                                    }
                                  },
                                  child: Obx(
                                    () => Row(
                                      children: [
                                        const Icon(
                                            Icons.edit_calendar_outlined),
                                        const SizedBox(width: 5),
                                        Text(
                                          addAdvanceController
                                                      .selectedTransactionDate
                                                      .value !=
                                                  null
                                              ? DateFormat('dd/MM/yyyy').format(
                                                  addAdvanceController
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
                            const SizedBox(height: 10),
                            //customer
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
                              child: addAdvanceController.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(10),
                                      underline: const SizedBox.shrink(),
                                      isExpanded: true,
                                      dropdownColor: primaryColor3,
                                      value: addAdvanceController
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
                                        addAdvanceController.selectedCustomerId
                                            .value = newValue!;
                                        addAdvanceController
                                            .fetchAgentDetails(newValue);
                                      },
                                      items: addAdvanceController.customers
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
                            Text(
                              'Advance amount',
                              style: lightTextTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            CustomTextField(
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter amount';
                                }
                                if (double.tryParse(val) == null) {
                                  return 'Please enter a valid number';
                                }
                                if (double.parse(val) < 0) {
                                  return 'Value cannot be negative';
                                }
                                return null;
                              },
                              controller: addAdvanceController
                                  .advanceAmountController.value,
                              hintText: 'Enter an amount',
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Remark',
                                  style: lightTextTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  ' (optional)',
                                  style: lightTextTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                            CustomTextField(
                              controller:
                                  addAdvanceController.remarkController.value,
                              hintText: 'Enter remark',
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        isLoading: addAdvanceController.isSaveLoading.value,
                        text: 'Save',
                        onTap: () {
                          if (addAdvanceController.advanceFormKey.currentState!
                              .validate()) {
                            addAdvanceController.addCustomerAdvanceDB();
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
