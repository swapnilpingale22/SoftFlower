import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/theme.dart';
import '../../transactions/screens/reports_screen.dart';
import '../controllers/view_payment_controller.dart';
import '../models/sales_details_model.dart';
import '../models/sales_model.dart';

class ViewPaymentScreen extends StatefulWidget {
  const ViewPaymentScreen({super.key});

  @override
  State<ViewPaymentScreen> createState() => _ViewPaymentScreenState();
}

class _ViewPaymentScreenState extends State<ViewPaymentScreen> {
  ViewPaymentController addPaymentController = Get.put(ViewPaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Reports',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: addPaymentController.fetchMainTransactions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return _buildMainTransactionsList(snapshot.data!.docs);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildErrorWidget(Object? error) {
    return Center(child: Text('Error: $error'));
  }

  Widget _buildMainTransactionsList(
      List<QueryDocumentSnapshot> mainTransactions) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: mainTransactions.length,
        itemBuilder: (context, index) {
          final mainTransaction = SalesMain.fromSnap(mainTransactions[index]);
          log("Sales Main Length: ${mainTransactions.length}");
          return _buildTransactionCard(mainTransaction);
        },
      ),
    );
  }

  TextStyle _getTextStyle() {
    return const TextStyle(color: textColor);
  }

  Widget _buildSubTransactions(String salesMainId) {
    return StreamBuilder<QuerySnapshot>(
      stream: addPaymentController.fetchSubTransactions(salesMainId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return _buildSubTransactionsList(snapshot.data!.docs);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildSubTransactionsList(
      List<QueryDocumentSnapshot> subTransactions) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: primaryColor3,
      ),
      margin: const EdgeInsets.only(right: 10),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: subTransactions.length,
        itemBuilder: (context, index) {
          final subTransaction = SalesDetails.fromSnap(subTransactions[index]);
          log("sales Details Length: ${subTransactions.length}");
          final isLastCard = index == subTransactions.length - 1;

          return _buildSubTransactionCard(subTransaction, isLastCard);
        },
      ),
    );
  }

//Main Payment Card
  Widget _buildTransactionCard(SalesMain mainTransaction) {
    String formattedDate =
        DateFormat('dd MMM yyyy').format(mainTransaction.paymentDate);

    return ZoomIn(
      child: Card(
        color: primaryColor2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.only(bottom: 20),
        elevation: 4,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          mainTransaction.customerName,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const CustomDivider(height: 25),
                      Expanded(
                        flex: 4,
                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Balance",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '₹${mainTransaction.balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildSubTransactions(mainTransaction.paymentId),
                ],
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: CircleAvatar(
                backgroundColor: primaryColor3,
                child: InkWell(
                  onTap: () {
                    // reportsController.showDeleteDialog(
                    //   transactionId: transaction.transactionId,
                    //   collectionName: 'transactionMain',
                    // );
                  },
                  child: const Icon(
                    Icons.delete_forever,
                    color: textColor,
                  ),
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

                    // final paragraphPdf = await singleTransactionPdfController
                    //     .generateSingleTransactionPdf(
                    //   transData: reportsController.transactions,
                    //   index: index,
                    // );

                    // SaveAndOpneDocument.openPdf(paragraphPdf);
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

    // Card(
    //   margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    //   child: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           "Payment Date: $formattedDate",
    //           style: _getTextStyle(),
    //         ),
    //         Text(
    //           "Transaction ID: ${mainTransaction.paymentId}",
    //           style: _getTextStyle(),
    //         ),
    //         Text(
    //           "Customer ID: ${mainTransaction.customerId}",
    //           style: _getTextStyle(),
    //         ),
    //         Text(
    //           "Balance: \$${mainTransaction.balance.toStringAsFixed(2)}",
    //           style: _getTextStyle(),
    //         ),
    //         Text(
    //           "Status: ${mainTransaction.isActive == 1 ? 'Active' : 'Inactive'}",
    //           style: _getTextStyle(),
    //         ),
    //         _buildSubTransactions(mainTransaction.paymentId),
    //       ],
    //     ),
    //   ),
    // );
  }

//Sub Payment Card
  Widget _buildSubTransactionCard(
      SalesDetails subTransaction, bool isLastCard) {
    return SizedBox(
      // height: 80,
      child: Card(
        shadowColor: Colors.transparent,
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        elevation: 4,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: isLastCard
                  ? BorderSide.none
                  : const BorderSide(color: Colors.black26, width: 1),
            ),
          ),
          child: ListTile(
            title: Text(
              subTransaction.itemName,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "QTY ${subTransaction.quantity.toStringAsFixed(0)} x ₹${subTransaction.rate}",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            trailing: Text(
              "₹${subTransaction.saleAmount.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );

    // Card(
    //   margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    //   child: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           "itemName: ${subTransaction.itemName}",
    //           style: _getTextStyle(),
    //         ),
    //         Text(
    //           "quantity: ${subTransaction.quantity.toStringAsFixed(0)}",
    //           style: _getTextStyle(),
    //         ),
    //         Text(
    //           "rate: \$${subTransaction.rate.toStringAsFixed(2)}",
    //           style: _getTextStyle(),
    //         ),
    //         Text(
    //           "saleAmount: \$${subTransaction.saleAmount.toStringAsFixed(2)}",
    //           style: _getTextStyle(),
    //         ),
    //         Text(
    //           "Status: ${subTransaction.isActive == 1 ? 'Active' : 'Inactive'}",
    //           style: _getTextStyle(),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
