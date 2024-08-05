import 'package:animate_do/animate_do.dart';
import 'package:expense_manager/Features/product/screens/add_product_screen.dart';
import 'package:expense_manager/Features/product/screens/edit_product_alert_box.dart';
import 'package:expense_manager/Features/transactions/controller/add_transaction_controller.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/edit_product_controller.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  AddTransactionController addTransactionController =
      Get.put(AddTransactionController());

  EditProductController editProductController =
      Get.put(EditProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor3,
        child: const Icon(Icons.add, size: 28),
        onPressed: () => Get.to(
          () => const AddProductScreen(),
        ),
      ),
      body: Obx(
        () => addTransactionController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : addTransactionController.products.isEmpty
                ? Center(
                    child: Text(
                      "No data available",
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
                            itemCount: addTransactionController.products.length,
                            itemBuilder: (context, index) {
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
                                      '${addTransactionController.products[index].productNumber}. ${addTransactionController.products[index].productName}',
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
                                        Text(
                                          'Quantity: ${addTransactionController.products[index].quantity}  \nCommission: ${addTransactionController.products[index].commission}  \nBundle Type: ${addTransactionController.products[index].bundleType}',
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: primaryColor3,
                                              child: InkWell(
                                                onTap: () async =>
                                                    await showEditProductDialog(
                                                  context,
                                                  editProductController,
                                                  addTransactionController
                                                      .products[index],
                                                ),
                                                child: const Icon(
                                                  Icons.edit_note_outlined,
                                                  color: textColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            CircleAvatar(
                                              backgroundColor: primaryColor3,
                                              child: InkWell(
                                                onTap: () {
                                                  addTransactionController
                                                      .showDeleteDialog(
                                                    agentId:
                                                        addTransactionController
                                                            .products[index]
                                                            .productId,
                                                    collectionName: 'product',
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
                                    // trailing: Column(
                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                    //   crossAxisAlignment: CrossAxisAlignment.end,
                                    //   children: [
                                    //     Expanded(
                                    //       child: InkWell(
                                    //         onTap: () {},
                                    //         child: const Icon(Icons.edit_note_outlined),
                                    //       ),
                                    //     ),
                                    //     const SizedBox(height: 10),
                                    //     Expanded(
                                    //       child: InkWell(
                                    //         onTap: () {},
                                    //         child: const Icon(Icons.delete_forever),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
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
