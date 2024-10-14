import 'package:animate_do/animate_do.dart';
import 'package:expense_manager/Features/customer/screens/add_customer_screen.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import '../../transactions/screens/reports_screen.dart';
import '../controller/customers_controller.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  CustomersController customersController = Get.put(CustomersController());

  // EditProductController editProductController =
  //     Get.put(EditProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customers',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
        actions: [
          const SizedBox(width: 50),
          Expanded(
            child: SearchBarAnimation(
              buttonColour: primaryColor3,
              searchBoxColour: primaryColor1,
              hintText: 'Search customer',
              durationInMilliSeconds: 500,
              isSearchBoxOnRightSide: true,
              textEditingController:
                  customersController.searchCustomersController.value,
              isOriginalAnimation: false,
              enableKeyboardFocus: true,
              buttonBorderColour: Colors.black45,
              trailingWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
              secondaryButtonWidget: const Icon(
                Icons.close,
                size: 20,
                color: Colors.black,
              ),
              buttonWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
              onFieldSubmitted: (String value) {
                customersController.searchCustomersByName(value);
              },
              onChanged: (String value) {
                customersController.searchCustomersByName(value);
              },
              onPressButton: (isSearchBarOpens) {
                customersController.searchCustomersController.value.clear();
                customersController.filteredCustomers.value =
                    customersController.customers;
              },
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor3,
        child: const Icon(Icons.add, size: 28),
        onPressed: () => Get.to(
          () => const AddCustomerScreen(),
        ),
      ),
      body: Obx(
        () => customersController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : customersController.customers.isEmpty
                ? Center(
                    child: Text(
                      "No data available",
                      style: lightTextTheme.headlineMedium?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  )
                : customersController.filteredCustomers.isEmpty
                    ? Center(
                        child: Text(
                          "No results found",
                          style: lightTextTheme.headlineMedium?.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: customersController
                                    .filteredCustomers.length,
                                itemBuilder: (context, index) {
                                  final customer = customersController
                                      .filteredCustomers[index];
                                  return ZoomIn(
                                    child: Card(
                                      color: primaryColor2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      margin: const EdgeInsets.only(bottom: 20),
                                      elevation: 4,
                                      child: ListTile(
                                        title: Text(
                                          customer.customerName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                children: [
                                                  CustomRow(
                                                    title: 'Opening Balance:',
                                                    value: customer
                                                        .openingBalance
                                                        .toStringAsFixed(2),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                const SizedBox(height: 10),
                                                CircleAvatar(
                                                  backgroundColor:
                                                      primaryColor3,
                                                  child: InkWell(
                                                    onTap: () {
                                                      customersController
                                                          .showCustomerDeleteDialog(
                                                        customerId:
                                                            customer.customerId,
                                                        collectionName:
                                                            'customer',
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.delete_forever,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}
