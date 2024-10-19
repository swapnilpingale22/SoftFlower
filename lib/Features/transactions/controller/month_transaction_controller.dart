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
  RxList<Transactions> allMonthlyTransactions = <Transactions>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgents();
    filteredAgents.value = agents;
    selectedMonth.value = monthList[DateTime.now().month - 1];
  }

  Future<void> fetchAgents() async {
    final uid = _auth.currentUser!.uid;
    isLoading.value = true;
    var agentSnapshot = await firestore
        .collection('agent')
        .where('userId', isEqualTo: uid)
        .where('isActive', isEqualTo: 1)
        .orderBy('agentName')
        .get();
    agents.value =
        agentSnapshot.docs.map((doc) => Agent.fromSnap(doc)).toList();
    isLoading.value = false;
    //     .listen((snapshot) {
    //   agents.value = snapshot.docs.map((doc) => Agent.fromSnap(doc)).toList();
    //   isLoading.value = false;
    // }, onError: (e) {
    //   isLoading.value = false;
    //   log("Error fetching agents: $e");
    // });
  }

  void fetchAgentDetails(String agentId) {
    Agent? agent = agents.firstWhere(
      (a) => a.agentId == agentId,
    );

    agentName.value = agent.agentName;
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
        .where('isActive', isEqualTo: 1)
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

  void fetchAllMonthlyTransactions() {
    isLoading.value = true;
    final uid = _auth.currentUser!.uid;

    DateTime startDate =
        DateTime(DateTime.now().year, _getMonthNumber(selectedMonth.value!), 1);

    DateTime endDate = DateTime(
            DateTime.now().year, _getMonthNumber(selectedMonth.value!) + 1, 1)
        .subtract(const Duration(days: 1));

    firestore
        .collection('transactionMain')
        .where('userId', isEqualTo: uid)
        .where('isActive', isEqualTo: 1)
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

          // Add transaction main to the list
          fetchedTransactions.add(transactionMain);
          // }
        }
      }

      // Initially display all transactions
      allMonthlyTransactions.value = fetchedTransactions;

      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
      log("Error fetching transactions: $e");
    });
  }

  Rx<double?> totalDaag = Rx<double?>(null);
  Rx<double?> totalSale = Rx<double?>(null);
  Rx<double?> totalCommission = Rx<double?>(null);
  Rx<double?> totalExpense = Rx<double?>(null);
  Rx<double?> totalBalance = Rx<double?>(null);

  double getTotalDaagForAgent(int index) {
    double totalDaagForAgent = allMonthlyTransactions
        .where(
          (transaction) => transaction.agentId == agents[index].agentId,
        )
        .fold(0, (sumVal, transaction) => sumVal + transaction.daag);

    return totalDaagForAgent;
  }

  double getTotalSaleForAgent(int index) {
    double totalSaleForAgent = allMonthlyTransactions
        .where(
          (transaction) => transaction.agentId == agents[index].agentId,
        )
        .fold(0, (sumVal, transaction) => sumVal + transaction.totalSale);

    return totalSaleForAgent;
  }

  double getTotalCommissionForAgent(int index) {
    double totalCommissionForAgent = allMonthlyTransactions
        .where(
          (transaction) => transaction.agentId == agents[index].agentId,
        )
        .fold(0, (sumVal, transaction) => sumVal + transaction.commission);

    return totalCommissionForAgent;
  }

  double getTotalExpenseForAgent(int index) {
    double totalExpenseForAgent = allMonthlyTransactions
        .where(
          (transaction) => transaction.agentId == agents[index].agentId,
        )
        .fold(0, (sumVal, transaction) => sumVal + transaction.totalExpense);

    return totalExpenseForAgent;
  }

  double getTotalBalanceForAgent(int index) {
    double totalBalanceForAgent = allMonthlyTransactions
        .where(
          (transaction) => transaction.agentId == agents[index].agentId,
        )
        .fold(0, (sumVal, transaction) => sumVal + transaction.totalBalance);

    return totalBalanceForAgent;
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
