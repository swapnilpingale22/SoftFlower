// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/Features/agent/models/agent_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';
import '../models/transaction_details_model.dart';
import '../models/transactions_model.dart';

class MonthTransactionController extends GetxController {
  final monthTransactionFormKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  RxBool isSaveLoading = false.obs;

  //farmer
  Rx<String?> selectedAgentId = Rx<String?>(null);
  RxList<Agent> agents = <Agent>[].obs;
  RxList<Agent> filteredAgents = <Agent>[].obs;
  RxString agentName = "".obs;

  //month
  Rx<String?> selectedMonth = Rx<String?>(null);
  RxList<String> monthList = <String>[
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ].obs;

//transactions
  RxList<Transactions> transactions = <Transactions>[].obs;
  RxList<Transactions> allTransactions = <Transactions>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgents();
    filteredAgents.value = agents;
  }

  void fetchAgents() {
    final uid = _auth.currentUser!.uid;
    isLoading.value = true;
    firestore
        .collection('agent')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      agents.value = snapshot.docs.map((doc) => Agent.fromSnap(doc)).toList();
      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
      log("Error fetching agents: $e");
    });
  }

  void fetchAgentDetails(String agentId) {
    Agent? agent = agents.firstWhere(
      (a) => a.agentId == agentId,
    );
    if (agent != null) {
      agentName.value = agent.agentName;
    }
  }

  void fetchTransactions() {
    isLoading.value = true;
    // final uid = _auth.currentUser!.uid;
    DateTime startDate =
        DateTime(DateTime.now().year, _getMonthNumber(selectedMonth.value!), 1);

    DateTime endDate = DateTime(
            DateTime.now().year, _getMonthNumber(selectedMonth.value!) + 1, 1)
        .subtract(const Duration(days: 1));

    firestore
        .collection('transactionMain')
        // .where('userId', isEqualTo: uid)
        .where('agentName', isEqualTo: agentName.value)
        .where('transactionDate', isGreaterThanOrEqualTo: startDate)
        .where('transactionDate', isLessThanOrEqualTo: endDate)
        .snapshots()
        .listen((snapshot) async {
      List<Transactions> fetchedTransactions = [];
      if (snapshot.docs.isEmpty) {
        showSnackBar(
            'No transactions available for selected month!', Get.context!);
      } else {
        for (var doc in snapshot.docs) {
          // Fetch transaction main data
          var transactionMain = Transactions.fromSnap(doc);

          // DateTime transactionDate = transactionMain.transactionDate;
          // if (transactionDate.month == _getMonthNumber(selectedMonth.value!)) {
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
          // }
        }
      }
      //sort by date ascending
      fetchedTransactions.sort(
        (a, b) {
          DateTime dateA = a.transactionDate;
          DateTime dateB = b.transactionDate;
          return dateA.compareTo(dateB);
        },
      );

      // Initially display all transactions
      transactions.value = fetchedTransactions;
      // if (transactions.isNotEmpty) {
      //   showSnackBar(
      //       'Transactions found: ${transactions.length}', Get.context!);
      // }
      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
      log("Error fetching transactions: $e");
    });
  }

  int _getMonthNumber(String monthName) {
    switch (monthName) {
      case 'January':
        return 1;
      case 'February':
        return 2;
      case 'March':
        return 3;
      case 'April':
        return 4;
      case 'May':
        return 5;
      case 'June':
        return 6;
      case 'July':
        return 7;
      case 'August':
        return 8;
      case 'September':
        return 9;
      case 'October':
        return 10;
      case 'November':
        return 11;
      case 'December':
        return 12;
      default:
        return 0;
    }
  }
}
