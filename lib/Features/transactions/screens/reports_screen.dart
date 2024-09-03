import 'package:animate_do/animate_do.dart';
import 'package:expense_manager/Features/pdf/paragraph_pdf_api.dart';
import 'package:expense_manager/Features/transactions/controller/reports_controller.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../pdf/save_and_opne_pdf.dart';

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
            : (reportsController.startDate.value != null &&
                    reportsController.endDate.value != null &&
                    reportsController.transactions.isEmpty)
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (reportsController.startDate.value != null &&
                                reportsController.endDate.value != null)
                              Expanded(
                                child: Text(
                                  "Reports From: \n${reportsController.formattedStartDate.value} to ${reportsController.formattedEndDate.value}",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            if (reportsController.formattedStartDate.value !=
                                    null &&
                                reportsController.formattedEndDate.value !=
                                    null)
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () {
                                  reportsController.resetDateRange();
                                },
                              ),
                            IconButton(
                              onPressed: () {
                                reportsController.selectDateRange(context);
                              },
                              icon: const Icon(Icons.sort),
                            )
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "No transactions available for selected date range",
                              textAlign: TextAlign.center,
                              style: lightTextTheme.headlineMedium?.copyWith(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (reportsController.startDate.value !=
                                          null &&
                                      reportsController.endDate.value != null)
                                    Expanded(
                                      child: Text(
                                        "Reports From: \n${reportsController.formattedStartDate.value} to ${reportsController.formattedEndDate.value}",
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  if (reportsController
                                              .formattedStartDate.value !=
                                          null &&
                                      reportsController
                                              .formattedEndDate.value !=
                                          null)
                                    IconButton(
                                      icon: const Icon(Icons.refresh),
                                      onPressed: () {
                                        reportsController.resetDateRange();
                                      },
                                    ),
                                  IconButton(
                                    onPressed: () {
                                      reportsController
                                          .selectDateRange(context);
                                    },
                                    icon: const Icon(Icons.sort),
                                  )
                                ],
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    reportsController.transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction =
                                      reportsController.transactions[index];

                                  String formattedDate =
                                      DateFormat('dd/MM/yyyy')
                                          .format(transaction.transactionDate);

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
                                            shape: LinearBorder.none,
                                            childrenPadding: EdgeInsets.zero,
                                            title: Text(
                                                'Farmer: ${transaction.agentName}'),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Date: $formattedDate',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  'Daag: ${transaction.daag}',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  'Total sale: ${transaction.totalSale}',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  'Commission: ${transaction.commission}',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  'Motor Rent: ${transaction.motorRent}',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  'Coolie: ${transaction.coolie}',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  'Jaga Bhade: ${transaction.jagaBhade}',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  'Postage: ${transaction.postage}',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  'Caret: ${transaction.caret}',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  'Total Expense: ${transaction.totalExpense}',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  'Total Balance: ${transaction.totalBalance}',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w500,
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
                                                  itemCount: transaction
                                                      .transactionDetailsList
                                                      .length,
                                                  itemBuilder:
                                                      (context, subIndex) {
                                                    var transactionDetails =
                                                        reportsController
                                                                .transactions[index]
                                                                .transactionDetailsList[
                                                            subIndex];
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
                                                            'Product: ${transactionDetails.itemName}',
                                                            style:
                                                                const TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Quantity: ${transactionDetails.quantity}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Rate: ${transactionDetails.rate}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Total Sale: ${transactionDetails.totalSale}',
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
                                                    transactionId: transaction
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
                                          ),
                                          Positioned(
                                            right: 10,
                                            top: 60,
                                            child: CircleAvatar(
                                              backgroundColor: primaryColor3,
                                              child: InkWell(
                                                onTap: () async {
                                                  //generate and open PDF
                                                  final paragraphPdf =
                                                      await ParagraphPdfApi
                                                          .generateParagraphPdf(
                                                    transData: reportsController
                                                        .transactions,
                                                    index: index,
                                                  );

                                                  SaveAndOpneDocument.openPdf(
                                                      paragraphPdf);
                                                },
                                                child: const Icon(
                                                  Icons.picture_as_pdf,
                                                  color: textColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
