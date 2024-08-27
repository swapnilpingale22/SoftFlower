import 'package:animate_do/animate_do.dart';
import 'package:expense_manager/Features/product/screens/add_product_screen.dart';
import 'package:expense_manager/Features/product/screens/edit_product_alert_box.dart';
import 'package:expense_manager/Features/transactions/controller/add_transaction_controller.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

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
          'Flowers',
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
              hintText: 'Search flower',
              durationInMilliSeconds: 500,
              isSearchBoxOnRightSide: true,
              textEditingController:
                  addTransactionController.searchProductController.value,
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
                addTransactionController.searchProductByName(value);
              },
              onChanged: (String value) {
                addTransactionController.searchProductByName(value);
              },
              onPressButton: (isSearchBarOpens) {
                addTransactionController.searchProductController.value.clear();
                addTransactionController.filteredProducts.value =
                    addTransactionController.products;
                // log('do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
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
                : addTransactionController.filteredProducts.isEmpty
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
                                itemCount: addTransactionController
                                    .filteredProducts.length,
                                itemBuilder: (context, index) {
                                  final product = addTransactionController
                                      .filteredProducts[index];
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
                                          '${product.productNumber}. ${product.productName}',
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
                                              'Quantity: ${product.quantity}  \nCommission: ${product.commission}  \nBundle Type: ${product.bundleType}',
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
                                                  backgroundColor:
                                                      primaryColor3,
                                                  child: InkWell(
                                                    onTap: () async =>
                                                        await showEditProductDialog(
                                                      context,
                                                      editProductController,
                                                      product,
                                                    ),
                                                    child: const Icon(
                                                      Icons.edit_note_outlined,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                CircleAvatar(
                                                  backgroundColor:
                                                      primaryColor3,
                                                  child: InkWell(
                                                    onTap: () {
                                                      addTransactionController
                                                          .showDeleteDialog(
                                                        agentId:
                                                            product.productId,
                                                        collectionName:
                                                            'product',
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
