import 'package:animate_do/animate_do.dart';
import 'package:expense_manager/Features/transactions/controller/reports_controller.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../pdf/save_and_opne_pdf.dart';
import '../../pdf/single_transaction_pdf_api.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  ReportsController reportsController = Get.put(ReportsController());
  final singleTransactionPdfController =
      Get.put(SingleTransactionPdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patti Reports',
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (reportsController.startDate.value ==
                                          null &&
                                      reportsController.endDate.value == null)
                                    const Expanded(
                                      child: Text(
                                        "Showing all reports",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
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
                                    icon: const Icon(
                                        Icons.edit_calendar_outlined),
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
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 20, 0, 20),
                                            child: Column(
                                              children: [
                                                //name, date
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        transaction.agentName,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: const TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    const CustomDivider(
                                                        height: 25),
                                                    Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        formattedDate,
                                                        style: const TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    const Expanded(
                                                        child: SizedBox()),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                // daag, postage
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Daag",
                                                      style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      '${transaction.daag}',
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    // Expanded(
                                                    //   child: CustomDataColumn(
                                                    //     title: "Daag",
                                                    //     value:
                                                    //         '${transaction.daag}',
                                                    //   ),
                                                    // ),
                                                    // const Expanded(
                                                    //     child: SizedBox()),
                                                    // const Expanded(
                                                    //     child: SizedBox()),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                //motor rent, commission
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: CustomDataColumn(
                                                        title: "Commission",
                                                        value: transaction
                                                            .commission
                                                            .toStringAsFixed(2),
                                                      ),
                                                    ),
                                                    const CustomDivider(),
                                                    Expanded(
                                                      child: CustomDataColumn(
                                                        title: "Motor Rent",
                                                        value:
                                                            '${transaction.motorRent}',
                                                      ),
                                                    ),

                                                    const CustomDivider(),
                                                    Expanded(
                                                      child: CustomDataColumn(
                                                        title: "Coolie",
                                                        value: transaction
                                                            .coolie
                                                            .toStringAsFixed(2),
                                                      ),
                                                    ),

                                                    // const Expanded(
                                                    //     child: SizedBox()),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                //jaga bhade, coolie
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: CustomDataColumn(
                                                        title: "Jaga Bhade",
                                                        value:
                                                            '${transaction.jagaBhade}',
                                                      ),
                                                    ),
                                                    const CustomDivider(),
                                                    Expanded(
                                                      child: CustomDataColumn(
                                                        title: "Postage",
                                                        value: transaction
                                                            .postage
                                                            .toStringAsFixed(2),
                                                      ),
                                                    ),
                                                    const CustomDivider(),
                                                    Expanded(
                                                      child: CustomDataColumn(
                                                        title: "Caret",
                                                        value:
                                                            '${transaction.caret}',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),

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
                                                                  .transactions[
                                                                      index]
                                                                  .transactionDetailsList[
                                                              subIndex];
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 10, 5, 10),
                                                        width: Get.width * 0.60,
                                                        height: 50,
                                                        child: Card(
                                                          color: primaryColor3,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          elevation: 4,
                                                          child: ListTile(
                                                            title: Text(
                                                              transactionDetails
                                                                  .itemName,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            subtitle: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CustomItemRow(
                                                                  title:
                                                                      'Quantity:',
                                                                  value:
                                                                      '${transactionDetails.quantity}',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                CustomItemRow(
                                                                  title:
                                                                      'Rate:',
                                                                  value:
                                                                      '${transactionDetails.rate}',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                CustomItemRow(
                                                                  title:
                                                                      'Total Sale:',
                                                                  value:
                                                                      '${transactionDetails.totalSale}',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: CustomDataColumn(
                                                        title: "Total Sale",
                                                        value: transaction
                                                            .totalSale
                                                            .toStringAsFixed(2),
                                                      ),
                                                    ),
                                                    const CustomDivider(),
                                                    Expanded(
                                                      child: CustomDataColumn(
                                                        title: "Expense",
                                                        value: transaction
                                                            .totalExpense
                                                            .toStringAsFixed(2),
                                                      ),
                                                    ),
                                                    const CustomDivider(),
                                                    Expanded(
                                                      child: CustomDataColumn(
                                                        title: "Balance",
                                                        value: transaction
                                                            .totalBalance
                                                            .toStringAsFixed(2),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const ExpansionTile(
                                            initiallyExpanded: true,
                                            shape: LinearBorder.none,
                                            childrenPadding: EdgeInsets.zero,
                                            // title: CustomRow(
                                            //   title: 'Farmer:',
                                            //   value: transaction.agentName,
                                            // ),
                                            //  Text(
                                            //     'Farmer: ${transaction.agentName}'),
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [],
                                            ),
                                            subtitle: Column(
                                              children: [],
                                            ),

                                            children: [],
                                          ),
                                          Positioned(
                                            right: 10,
                                            top: 10,
                                            child: CircleAvatar(
                                              foregroundImage: const AssetImage(
                                                "assets/images/remove.png",
                                              ),
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
                                                // child:
                                                //  Image.asset(
                                                //   "assets/images/remove.png",
                                                //   height: 30,
                                                //   width: 30,
                                                // ),
                                                //     const Icon(
                                                //   Icons.delete_forever,
                                                //   color: textColor,
                                                // ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 57,
                                            top: 10,
                                            child: CircleAvatar(
                                              backgroundColor: primaryColor3,
                                              child: InkWell(
                                                onTap: () async {
                                                  //generate and open PDF
                                                  final paragraphPdf =
                                                      await singleTransactionPdfController
                                                          .generateSingleTransactionPdf(
                                                    transData: reportsController
                                                        .transactions,
                                                    index: index,
                                                  );

                                                  SaveAndOpneDocument.openPdf(
                                                      paragraphPdf);
                                                },
                                                child:
                                                    singleTransactionPdfController
                                                            .isPDFLoading.value
                                                        ? const Center(
                                                            child:
                                                                CupertinoActivityIndicator(
                                                              color: textColor,
                                                            ),
                                                          )
                                                        : Image.asset(
                                                            "assets/images/pdf2.png",
                                                            height: 28,
                                                            width: 28,
                                                          ),
                                                // const Icon(
                                                //     Icons
                                                //         .picture_as_pdf,
                                                //     color: textColor,
                                                //   ),
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

class CustomDivider extends StatelessWidget {
  final double? height;
  const CustomDivider({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: height ?? 40,
      color: Colors.black26,
      margin: const EdgeInsets.symmetric(horizontal: 15),
    );
  }
}

class CustomDataColumn extends StatelessWidget {
  final String title;
  final String value;
  const CustomDataColumn({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class CustomRow extends StatelessWidget {
  const CustomRow({
    super.key,
    required this.title,
    required this.value,
    this.fontWeight,
  });

  final String title;
  final String value;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: fontWeight,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            textAlign: TextAlign.end,
            value,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: fontWeight,
            ),
          ),
        ),
        const Expanded(
          flex: 1,
          child: SizedBox(),
        )
      ],
    );
  }
}

class CustomItemRow extends StatelessWidget {
  const CustomItemRow({
    super.key,
    required this.title,
    required this.value,
    this.fontWeight,
  });

  final String title;
  final String value;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              // fontWeight: fontWeight,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            textAlign: TextAlign.end,
            value,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: fontWeight,
              fontSize: 15,
            ),
          ),
        ),
        const Expanded(
          flex: 1,
          child: SizedBox(),
        )
      ],
    );
  }
}
