import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/utils.dart';
import '../models/transaction_details_model.dart';
import '../models/transactions_model.dart';

class ReportsController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var dataList = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxBool isDeleteLoading = false.obs;

  RxList<Transactions> transactions = <Transactions>[].obs;
  RxList<Transactions> allTransactions = <Transactions>[].obs;

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<String?> formattedStartDate = Rx<String?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  Rx<String?> formattedEndDate = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    // fetchData();
    fetchTransactions();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('transactionMain').get();

      var data = await Future.wait(querySnapshot.docs.map((doc) async {
        var docData = doc.data() as Map<String, dynamic>;

        var transactionDate =
            (docData['transactionDate'] as Timestamp).toDate();

        var formattedDate = DateFormat('dd/MM/yyyy').format(transactionDate);

        var mainData = {
          'Date': formattedDate,
          'Daag': docData['daag'],
          'Agent Name': docData['agentName'],
          'Product Name': '',
          'Quantity': '',
          'Rate': '',
          'Total Sale': docData['totalSale'],
          'Commission': docData['commission'],
          'Coolie': docData['coolie'],
          'Jaga Bhade': docData['jagaBhade'],
          'Motor Rent': docData['motorRent'],
          'Postage': docData['postage'],
          'Caret': docData['caret'],
          'Total Expense': docData['totalExpense'],
          'Total Balance': docData['totalBalance'],
          'transactionId': docData['transactionId'],
        };

        QuerySnapshot subCollectionSnapshot = await FirebaseFirestore.instance
            .collection('transactionMain')
            .doc(doc.id)
            .collection('transactionDetails')
            .get();

        var subCollectionData = subCollectionSnapshot.docs.map((subDoc) {
          var subDocData = subDoc.data() as Map<String, dynamic>;
          return {
            'Product Name': subDocData['itemName'],
            'Quantity': subDocData['quantity'],
            'Rate': subDocData['rate'],
          };
        }).toList();

        mainData['Product Name'] = subCollectionData[0]['Product Name'];
        mainData['Quantity'] = subCollectionData[0]['Quantity'];
        mainData['Rate'] = subCollectionData[0]['Rate'];

        return mainData;
      }).toList());

      dataList.assignAll(data);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      log("Error fetching data: $e");
    }
  }

//delete transaction

  Future<void> deleteDocumentAndSubcollections(
      String collectionName, String documentId) async {
    isDeleteLoading.value = true;
    final documentReference =
        FirebaseFirestore.instance.collection(collectionName).doc(documentId);

    QuerySnapshot subCollectionSnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .collection('transactionDetails')
        .get();
    // Get all subcollections

    // Iterate through subcollections and delete each document in them
    for (var subcollection in subCollectionSnapshot.docs) {
      await subcollection.reference.delete().then(
        (value) {
          log("Document \"${subcollection.id}\" deleted successfully.");
        },
      );
    }

    // Finally, delete the document itself
    await documentReference.delete().then(
      (value) {
        Get.back();
        isDeleteLoading.value = false;
      },
    );
  }

  Future<void> deleteCollectionWithSubcollections(
      String collectionName, String documentId) async {
    try {
      await deleteDocumentAndSubcollections(collectionName, documentId);
      log("Document and its subcollections deleted successfully");
    } catch (e) {
      isDeleteLoading.value = false;
      log("Error deleting document and its subcollections: $e");
    }
  }

  showDeleteDialog(
      {required String transactionId, required String collectionName}) {
    showCupertinoDialog(
      context: Get.context!,
      builder: (context) => Obx(
        () => CupertinoAlertDialog(
          title: const Text('Alert'),
          content: const Text('Do you really want to delete?'),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: isDeleteLoading.value
                  ? const SizedBox(
                      height: 30,
                      child: Center(
                        child: CupertinoActivityIndicator(
                          color: textColor,
                          radius: 30,
                        ),
                      ),
                    )
                  : const Text('Yes'),
              onPressed: () async {
                try {
                  await deleteCollectionWithSubcollections(
                    collectionName,
                    transactionId,
                  );
                } catch (e) {
                  showSnackBar(e.toString(), Get.context!);
                }

                showSnackBar('Deleted successfully!', Get.context!);
              },
            ),
            CupertinoDialogAction(
              child: const Text('No'),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  void fetchTransactions() {
    isLoading.value = true;
    final uid = _auth.currentUser!.uid;
    firestore
        .collection('transactionMain')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) async {
      List<Transactions> fetchedTransactions = [];

      for (var doc in snapshot.docs) {
        // Fetch transaction main data
        var transactionMain = Transactions.fromSnap(doc);

        // Fetch transaction details for each transaction main
        var transactionDetailsSnapshot = await firestore
            .collection('transactionMain')
            .doc(transactionMain.transactionId)
            .collection('transactionDetails')
            .get();

        List<TransactionDetails> transactionDetailsList =
            transactionDetailsSnapshot.docs
                .map((detailsDoc) => TransactionDetails.fromSnap(detailsDoc))
                .toList();

        // Add transaction details to transaction main
        transactionMain = transactionMain.copyWith(
          transactionDetailsList: transactionDetailsList,
        );

        // Add transaction main to the list
        fetchedTransactions.add(transactionMain);
      }
      //sort by date descending
      fetchedTransactions.sort(
        (a, b) {
          DateTime dateA = a.transactionDate;
          DateTime dateB = b.transactionDate;
          return dateB.compareTo(dateA);
        },
      );

      // Store all transactions locally
      allTransactions.value = fetchedTransactions;

      // Initially display all transactions
      transactions.value = fetchedTransactions;

      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
      log("Error fetching transactions: $e");
    });
  }

  //show date picker
  Future<void> selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor2, // Header background color
              onPrimary: textColor, // Header text color
              onSurface: textColor, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: primaryColor2,
              ),
            ),
          ),
          child: child!,
        );
      },
      barrierColor: textColor,
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: startDate.value != null && endDate.value != null
          ? DateTimeRange(start: startDate.value!, end: endDate.value!)
          : null,
    );

    if (picked != null &&
        picked !=
            DateTimeRange(
              start: startDate.value ?? DateTime.now(),
              end: endDate.value ?? DateTime.now(),
            )) {
      startDate.value = picked.start;
      endDate.value = picked.end;

      formattedStartDate.value = DateFormat('dd/MM/yyyy').format(picked.start);
      formattedEndDate.value = DateFormat('dd/MM/yyyy').format(picked.end);
    }

    // After selecting the date range, fetch and filter the documents.
    filterTransactionsByDateRange();
  }

  void filterTransactionsByDateRange() {
    if (startDate.value != null && endDate.value != null) {
      transactions.value = allTransactions.where((transaction) {
        DateTime transactionDate = transaction.transactionDate;
        return transactionDate.isAtSameMomentAs(startDate.value!) ||
            transactionDate.isAtSameMomentAs(endDate.value!) ||
            transactionDate.isAfter(startDate.value!) &&
                transactionDate
                    .isBefore(endDate.value!.add(const Duration(days: 1)));
      }).toList();
    } else {
      // If no date range is selected, display all transactions
      transactions.value = allTransactions;
    }
  }

  // Reset the date range and show all transactions
  void resetDateRange() {
    startDate.value = null;
    endDate.value = null;
    formattedStartDate.value = null;
    formattedEndDate.value = null;

    // Show all transactions
    transactions.value = allTransactions;
  }
}
