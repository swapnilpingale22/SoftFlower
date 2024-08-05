import 'package:animate_do/animate_do.dart';
import 'package:expense_manager/Features/transactions/controller/reports_controller.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  ReportsController reportsController = Get.put(ReportsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reports',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(
        () => reportsController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : reportsController.transactions.isEmpty
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
                            itemCount: reportsController.transactions.length,
                            itemBuilder: (context, index) {
                              return ZoomIn(
                                child: Card(
                                    color: primaryColor2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    elevation: 4,
                                    child: Stack(
                                      children: [
                                        ExpansionTile(
                                          childrenPadding: EdgeInsets.zero,
                                          title: Text(
                                              'Date${reportsController.transactions[index].transactionDate}'),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Total sale: ${reportsController.transactions[index].totalSale}',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                'Total Expense: ${reportsController.transactions[index].totalExpense}',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                'Total Balance: ${reportsController.transactions[index].totalBalance}',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                'Caret: ${reportsController.transactions[index].caret}',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                'Commission: ${reportsController.transactions[index].commission}',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                'Coolie: ${reportsController.transactions[index].coolie}',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                'Daag: ${reportsController.transactions[index].daag}',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                'Jaga Bhade: ${reportsController.transactions[index].jagaBhade}',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                'Motor Rent: ${reportsController.transactions[index].motorRent}',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                'Postage: ${reportsController.transactions[index].postage}',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                          children: [
                                            SizedBox(
                                              height: 140,
                                              width: Get.width,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: reportsController
                                                    .transactions[index]
                                                    .transactionDetailsList
                                                    .length,
                                                itemBuilder:
                                                    (context, subIndex) {
                                                  var data = reportsController
                                                      .transactions[index]
                                                      .transactionDetailsList;
                                                  return Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        10, 10, 5, 10),
                                                    width: Get.width * 0.65,
                                                    height: 50,
                                                    child: Card(
                                                      color: primaryColor3,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      elevation: 4,
                                                      child: ListTile(
                                                        title: Text(
                                                          'Product: ${data[subIndex].itemName}',
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                        subtitle: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Quantity: ${data[subIndex].quantity}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Rate: ${data[subIndex].rate}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Total Sale: ${data[subIndex].totalSale}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                        Positioned(
                                          right: 10,
                                          top: 10,
                                          child: CircleAvatar(
                                            backgroundColor: primaryColor3,
                                            child: InkWell(
                                              onTap: () {
                                                reportsController
                                                    .showDeleteDialog(
                                                  transactionId:
                                                      reportsController
                                                          .transactions[index]
                                                          .transactionId,
                                                  collectionName:
                                                      'transactionMain',
                                                );
                                              },
                                              child: const Icon(
                                                Icons.delete_forever,
                                                color: textColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )

                                    //           ConstrainedBox(
                                    //             constraints: const BoxConstraints(
                                    //               maxHeight: 2700,
                                    //               maxWidth: 270,
                                    //             ),
                                    //             child: ListView.builder(
                                    //               scrollDirection: Axis.vertical,
                                    //               physics:
                                    //                   const NeverScrollableScrollPhysics(),
                                    //               shrinkWrap: true,
                                    // itemCount: reportsController
                                    //     .transactions[index]
                                    //     .transactionDetailsList
                                    //     .length,
                                    //               itemBuilder:
                                    //                   (context, subIndex) {
                                    //                 return Card(
                                    //                   child: ListTile(
                                    //                     tileColor: primaryColor3,
                                    //                     title: Text(
                                    //                       'Product: ${reportsController.transactions[index].transactionDetailsList[subIndex].itemName}',
                                    //                       style: const TextStyle(
                                    //                         color: Colors.black87,
                                    //                       ),
                                    //                     ),
                                    //                     subtitle: Column(
                                    //                       crossAxisAlignment:
                                    //                           CrossAxisAlignment
                                    //                               .start,
                                    //                       children: [
                                    //                         Text(
                                    //                           'Quantity: ${reportsController.transactions[index].transactionDetailsList[subIndex].quantity}',
                                    //                           style:
                                    //                               const TextStyle(
                                    //                             color: Colors
                                    //                                 .black87,
                                    //                           ),
                                    //                         ),
                                    //                         Text(
                                    //                           'Rate: ${reportsController.transactions[index].transactionDetailsList[subIndex].rate}',
                                    //                           style:
                                    //                               const TextStyle(
                                    //                             color: Colors
                                    //                                 .black87,
                                    //                           ),
                                    //                         ),
                                    //                         Text(
                                    //                           'Total Sale: ${reportsController.transactions[index].transactionDetailsList[subIndex].totalSale}',
                                    //                           style:
                                    //                               const TextStyle(
                                    //                             color: Colors
                                    //                                 .black87,
                                    //                           ),
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 );
                                    //               },
                                    //             ),
                                    //           )
                                    //         ],
                                    //       ),
                                    //       Column(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.end,
                                    //         crossAxisAlignment:
                                    //             CrossAxisAlignment.end,
                                    //         children: [
                                    //           const SizedBox(height: 10),
                                    //           CircleAvatar(
                                    //             backgroundColor: primaryColor3,
                                    //             child: InkWell(
                                    //               onTap: () {
                                    //                 reportsController
                                    //                     .showDeleteDialog(
                                    //                   transactionId:
                                    //                       reportsController
                                    //                           .transactions[index]
                                    //                           .transactionId,
                                    //                   collectionName:
                                    //                       'transactionMain',
                                    //                 );
                                    //               },
                                    //               child: const Icon(
                                    //                 Icons.delete_forever,
                                    //                 color: textColor,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
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
