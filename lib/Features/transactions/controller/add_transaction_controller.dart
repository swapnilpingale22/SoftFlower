// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/Features/agent/models/agent_model.dart';
import 'package:expense_manager/Features/product/models/product_model.dart';
import 'package:expense_manager/Features/transactions/models/product.dart';
import 'package:expense_manager/Features/transactions/models/transaction_details_model.dart';
import 'package:expense_manager/Features/transactions/models/transaction_main_model.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../auth/models/user_model.dart' as model;

class AddTransactionController extends GetxController {
  final transactionFormKey = GlobalKey<FormState>();
  final productListFormKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  RxBool isSaveLoading = false.obs;
  RxBool isSaveLoading2 = false.obs;
  //company
  // Rx<String?> selectedCompanyId = Rx<String?>(null);
  // RxList<Company> companies = <Company>[].obs;

  //agent
  Rx<String?> selectedAgentId = Rx<String?>(null);
  RxList<Agent> agents = <Agent>[].obs;
  RxList<Agent> filteredAgents = <Agent>[].obs;

  //product
  Rx<String?> selectedProductId = Rx<String?>(null);
  RxList<Product> products = <Product>[].obs;
  RxList<Product> filteredProducts = <Product>[].obs;

  //company
  // Rx<Company?> selectedCompanyData = Rx<Company?>(null);
  // RxString companyName = "".obs;
  // RxString companyAddress = "".obs;
  // RxString companyCity = "".obs;
  // RxInt companyMobNo = 0.obs;
  // RxString companyOwnerName = "".obs;
  // RxInt companyPincode = 0.obs;

  //agent
  RxString agentName = "".obs;
  Rx<TextEditingController> motorRentController = TextEditingController().obs;
  Rx<TextEditingController> coolieController = TextEditingController().obs;
  Rx<TextEditingController> jagaBhadeController = TextEditingController().obs;
  Rx<TextEditingController> postageController = TextEditingController().obs;
  Rx<TextEditingController> caretController = TextEditingController().obs;
  Rx<TextEditingController> searchAgentController = TextEditingController().obs;

  //product
  RxString productName = "".obs;
  Rx<TextEditingController> productQuantityController =
      TextEditingController().obs;
  Rx<TextEditingController> productCommissionController =
      TextEditingController().obs;
  Rx<TextEditingController> productBoxController = TextEditingController().obs;
  Rx<TextEditingController> productRateController = TextEditingController().obs;
  Rx<TextEditingController> searchProductController =
      TextEditingController().obs;

  //transaction date

  Rx<DateTime?> selectedTransactionDate = Rx<DateTime?>(null);

  double totalSale = 0.0;
  double totalExpense = 0.0;
  double totalBalance = 0.0;
  double actualCommission = 0.0;
  RxDouble actualMotorRent = 0.0.obs;
  RxDouble actualCoolie = 0.0.obs;
  RxDouble actualJagaBhade = 0.0.obs;
  RxDouble actualCaret = 0.0.obs;
  // int actualDaag = 0;
  //original initial values
  RxDouble initialMotorRent = 0.0.obs;
  RxDouble initialCoolie = 0.0.obs;
  RxDouble initialJagaBhade = 0.0.obs;
  RxDouble initialCaret = 0.0.obs;

  RxList<ProductModel> productsList = <ProductModel>[].obs;

  late ProductModel productModel;
  var productCount = 0.obs;
  RxBool isBackDated = false.obs;

  Rx<model.User?> userData = Rx<model.User?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchAgents();
    fetchProducts();
    getUserData();
    filteredAgents.value = agents;
    filteredProducts.value = products;
  }

  @override
  void onClose() {
    motorRentController.value.dispose();
    coolieController.value.dispose();
    jagaBhadeController.value.dispose();
    postageController.value.dispose();
    caretController.value.dispose();
    productQuantityController.value.dispose();
    productCommissionController.value.dispose();
    productBoxController.value.dispose();
    productRateController.value.dispose();
    // searchAgentController.value.dispose();
    // searchProductController.value.dispose();
    super.onClose();
  }

  // Future<void> fetchCompanies() async {
  //   isLoading.value = true;
  //   try {
  //     QuerySnapshot querySnapshot = await firestore.collection('company').get();
  //     companies.value =
  //         querySnapshot.docs.map((doc) => Company.fromSnap(doc)).toList();
  //   } catch (e) {
  //     isLoading.value = false;
  //     log("Error fetching products: $e");
  //   }
  //   isLoading.value = false;
  // }

  void updateCalculatedFields() {
    String daagValue = productBoxController.value.text;

    if (daagValue.isNotEmpty &&
        int.tryParse(daagValue) != null &&
        daagValue != "-" &&
        daagValue != "0") {
      int daag = int.parse(daagValue);

      actualMotorRent.value = initialMotorRent.value * daag;
      actualJagaBhade.value = initialJagaBhade.value * daag;
      actualCoolie.value = initialCoolie.value * daag;
      actualCaret.value = initialCaret.value * daag;

      motorRentController.value.text = actualMotorRent.toStringAsFixed(2);
      jagaBhadeController.value.text = actualJagaBhade.toStringAsFixed(2);
      coolieController.value.text = actualCoolie.toStringAsFixed(2);
      caretController.value.text = actualCaret.toStringAsFixed(2);
    } else {
      actualMotorRent.value = initialMotorRent.value;
      actualJagaBhade.value = initialJagaBhade.value;
      actualCoolie.value = initialCoolie.value;
      actualCaret.value = initialCaret.value;

      motorRentController.value.text = actualMotorRent.toStringAsFixed(2);
      jagaBhadeController.value.text = actualJagaBhade.toStringAsFixed(2);
      coolieController.value.text = actualCoolie.toStringAsFixed(2);
      caretController.value.text = actualCaret.toStringAsFixed(2);
    }
  }

  // void fetchCompanies() {
  //   final uid = _auth.currentUser!.uid;
  //   isLoading.value = true;
  //   firestore
  //       .collection('company')
  //       .where('userId', isEqualTo: uid)
  //       .snapshots()
  //       .listen((snapshot) {
  //     companies.value =
  //         snapshot.docs.map((doc) => Company.fromSnap(doc)).toList();
  //     isLoading.value = false;
  //   }, onError: (e) {
  //     isLoading.value = false;
  //     log("Error fetching companies: $e");
  //   });
  // }

  // Future<void> fetchAgents() async {
  //   isLoading.value = true;
  //   try {
  //     QuerySnapshot querySnapshot = await firestore.collection('agent').get();
  //     agents.value =
  //         querySnapshot.docs.map((doc) => Agent.fromSnap(doc)).toList();
  //   } catch (e) {
  //     isLoading.value = false;
  //     log("Error fetching products: $e");
  //   }
  //   isLoading.value = false;
  // }

  void fetchAgents() {
    final uid = _auth.currentUser!.uid;
    isLoading.value = true;
    firestore
        .collection('agent')
        .where('userId', isEqualTo: uid)
        .where('isActive', isEqualTo: 1)
        .orderBy('agentName')
        .snapshots()
        .listen((snapshot) {
      agents.value = snapshot.docs.map((doc) => Agent.fromSnap(doc)).toList();
      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
      log("Error fetching agents: $e");
    });
  }

  //search agents
  void searchAgentByName(String query) {
    if (query.isEmpty) {
      // If the search query is empty, show all agents
      filteredAgents.value = agents;
    } else {
      // Filter agents by name
      filteredAgents.value = agents
          .where(
            (agent) =>
                agent.agentName.toLowerCase().contains(query.toLowerCase()) ||
                agent.agentCity.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
  }

  // Future<void> fetchProducts() async {
  //   isLoading.value = true;
  //   try {
  //     QuerySnapshot querySnapshot = await firestore.collection('product').get();
  //     products.value =
  //         querySnapshot.docs.map((doc) => Product.fromSnap(doc)).toList();
  //   } catch (e) {
  //     isLoading.value = false;
  //     log("Error fetching products: $e");
  //   }
  //   isLoading.value = false;
  // }

  void fetchProducts() {
    final uid = _auth.currentUser!.uid;
    isLoading.value = true;
    firestore
        .collection('product')
        .where('userId', isEqualTo: uid)
        .where('isActive', isEqualTo: 1)
        .orderBy('productName')
        .snapshots()
        .listen((snapshot) {
      products.value =
          snapshot.docs.map((doc) => Product.fromSnap(doc)).toList();
      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
      log("Error fetching products: $e");
    });
  }

  //search products
  void searchProductByName(String query) {
    if (query.isEmpty) {
      // If the search query is empty, show all agents
      filteredProducts.value = products;
    } else {
      // Filter agents by name
      filteredProducts.value = products
          .where((product) =>
              product.productName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // void fetchCompanyDetails(String companyId) {
  //   Company? company = companies.firstWhere(
  //     (a) => a.companyName == companyId,
  //   );
  //   if (company != null) {
  //     selectedCompanyData.value = company;
  //     companyName.value = company.companyName;
  //     companyAddress.value = company.address;
  //     companyCity.value = company.city;
  //     companyMobNo.value = company.mobileNumber;
  //     companyOwnerName.value = company.ownerName;
  //     companyPincode.value = company.pincode;
  //   }
  // }

  void fetchAgentDetails(String agentId) {
    Agent? agent = agents.firstWhere(
      (a) => a.agentId == agentId,
    );
    if (agent != null) {
      agentName.value = agent.agentName;
      motorRentController.value.text = agent.motorRent.toStringAsFixed(2);
      coolieController.value.text = agent.coolie.toStringAsFixed(2);
      jagaBhadeController.value.text = agent.jagaBhade.toStringAsFixed(2);
      postageController.value.text = agent.postage.toStringAsFixed(2);
      caretController.value.text = agent.caret.toStringAsFixed(2);
      //set initial values
      initialMotorRent.value = agent.motorRent;
      initialJagaBhade.value = agent.jagaBhade;
      initialCoolie.value = agent.coolie;
      initialCaret.value = agent.caret;
    }
  }

  void fetchProductDetails(String productId) {
    Product? product = products.firstWhere(
      (p) => p.productId == productId,
    );
    if (product != null) {
      productName.value = product.productName;
      // productQuantityController.value.text = product.quantity.toString();
      productCommissionController.value.text = product.commission.toString();
    }
  }

  //get company details
  void getUserData() async {
    isLoading.value = true;

    final uid = _auth.currentUser!.uid;

    try {
      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      userData.value = model.User.fromSnap(userSnap);
    } catch (e) {
      showSnackBar(e.toString(), Get.context!);
    }
    isLoading.value = false;
  }

  //save transaction

  Future<String> addTransactionMain({
    required String agentId,
    required String agentName,
    required double caret,
    required double commission,
    required double coolie,
    required int daag,
    required double jagaBhade,
    required double motorRent,
    required double postage,
    required String productId,
    required double totalBalance,
    required double totalExpense,
    required String companyId,
    required String companyAddress,
    required DateTime transactionDate,
  }) async {
    String res = "Some error occured";
    final userId = _auth.currentUser!.uid;

    try {
      String transactionId = const Uuid().v1();

      TransactionMain transactionMain = TransactionMain(
        userId: userId,
        transactionId: transactionId,
        transactionDate: transactionDate,
        agentId: agentId,
        agentName: agentName,
        productId: productId,
        daag: daag,
        commission: commission,
        motorRent: motorRent,
        coolie: coolie,
        jagaBhade: jagaBhade,
        postage: postage,
        caret: caret,
        totalSale: totalSale,
        totalExpense: totalExpense,
        totalBalance: totalBalance,
        companyId: companyId,
        companyAddress: companyAddress,
      );

      await firestore.collection('transactionMain').doc(transactionId).set(
            transactionMain.toJson(),
          );

      //add transaction details

      for (var product in productsList) {
        String transactionDetailsId = const Uuid().v1();

        TransactionDetails transactionDetails = TransactionDetails(
          transactionMainId: transactionId,
          transactionDetailsId: transactionDetailsId,
          itemName: product.itemName,
          quantity: product.itemQuantity,
          rate: product.itemRate,
          totalSale: product.totalSale,
        );

        await firestore
            .collection('transactionMain')
            .doc(transactionId)
            .collection('transactionDetails')
            .doc(transactionDetailsId)
            .set(
              transactionDetails.toJson(),
            );
      }

      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  void addTransactionMainToDB() async {
    isSaveLoading.value = true;

    totalExpense = double.parse(postageController.value.text.trim()) +
        actualCommission +
        double.parse(motorRentController.value.text.trim()) +
        double.parse(jagaBhadeController.value.text.trim()) +
        double.parse(coolieController.value.text.trim()) +
        double.parse(caretController.value.text.trim());

    totalBalance = totalSale - totalExpense;

    try {
      DateTime selectedDate = selectedTransactionDate.value ?? DateTime.now();

      DateTime selectedDateWithoutTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      final uid = _auth.currentUser!.uid;

      QuerySnapshot snapshot = await firestore
          .collection('transactionMain')
          .where('userId', isEqualTo: uid)
          .get();

      bool transactionExists = false;

      for (var doc in snapshot.docs) {
        var agentNameDb = doc['agentName'];
        var isActive = doc['isActive'];

        DateTime transactionDate =
            (doc['transactionDate'] as Timestamp).toDate();
        DateTime transactionDateWithoutTime = DateTime(
          transactionDate.year,
          transactionDate.month,
          transactionDate.day,
        );

        if (transactionDateWithoutTime == selectedDateWithoutTime &&
            agentNameDb == agentName.value &&
            isActive == 1) {
          transactionExists = true;
          break;
        }
      }

      if (transactionExists) {
        isSaveLoading.value = false;
        _showTransactionExistsDialog(selectedDateWithoutTime);
        return;
      }

      _saveTransactionToDB(selectedDateWithoutTime);
    } catch (e) {
      isSaveLoading.value = false;
      log(e.toString());
      showSnackBar(e.toString(), Get.context!);
    }
  }

  void _saveTransactionToDB(DateTime selectedDateWithoutTime) async {
    isSaveLoading2.value = true;
    String res = await addTransactionMain(
        transactionDate: selectedDateWithoutTime,
        agentId: selectedAgentId.value ?? "",
        agentName: agentName.value,
        productId: selectedProductId.value ?? "",
        daag: int.parse(productBoxController.value.text.trim()),
        commission: actualCommission,
        motorRent: double.parse(motorRentController.value.text.trim()),
        coolie: double.parse(coolieController.value.text.trim()),
        jagaBhade: double.parse(jagaBhadeController.value.text.trim()),
        postage: double.parse(postageController.value.text.trim()),
        caret: double.parse(caretController.value.text.trim()),
        totalExpense: totalExpense,
        totalBalance: totalBalance,
        companyId: userData.value?.companyName ?? "Softflower",
        companyAddress: userData.value?.ownerName == "Milind Ghag"
            ? "Prop: ${userData.value?.ownerName}, \nMob: ${userData.value?.mobileNumber}"
            : "Prop: ${userData.value?.ownerName}, \nMob: ${userData.value?.mobileNumber} \n${userData.value?.address}, ${userData.value?.city} - ${userData.value?.pincode}"
        // "Prop: Milind Ghag, \nMob: 7710008987",
        );

    if (res == "Success") {
      // Clear the form and show success snackbar
      agentName.value = "";
      productBoxController.value.clear();
      productCommissionController.value.clear();
      motorRentController.value.clear();
      coolieController.value.clear();
      jagaBhadeController.value.clear();
      postageController.value.clear();
      caretController.value.clear();
      totalSale = 0.0;
      totalExpense = 0.0;
      totalBalance = 0.0;
      actualCommission = 0.0;
      actualMotorRent.value = 0.0;
      actualCoolie.value = 0.0;
      actualJagaBhade.value = 0.0;
      actualCaret.value = 0.0;
      productsList.clear();

      isSaveLoading.value = false;
      isSaveLoading2.value = false;
      Get.back();
      Get.back();
      showSnackBar('Patti saved', Get.context!);
    } else {
      isSaveLoading.value = false;
      isSaveLoading2.value = false;
      showSnackBar(res, Get.context!);
    }
  }

  _showTransactionExistsDialog(DateTime selectedDateWithoutTime) {
    showCupertinoDialog(
      context: Get.context!,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Transaction Exists'),
        content: const Text(
            'A transaction for this date already exists. Do you want to continue?'),
        actions: [
          Obx(
            () => CupertinoDialogAction(
              isDestructiveAction: true,
              child: isSaveLoading2.value
                  ? const SizedBox(
                      height: 30,
                      child: Center(
                        child: CupertinoActivityIndicator(
                          color: textColor,
                          radius: 30,
                        ),
                      ),
                    )
                  : const Text('Continue'),
              onPressed: () async {
                isSaveLoading2.value = true;
                _saveTransactionToDB(selectedDateWithoutTime);
              },
            ),
          ),
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  showDeleteDialog({required String agentId, required String collectionName}) {
    showCupertinoDialog(
      context: Get.context!,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('Do you really want to delete?'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Yes'),
            onPressed: () async {
              try {
                final uid = _auth.currentUser!.uid;
                //first fetch all trans

                QuerySnapshot allTransactions = await FirebaseFirestore.instance
                    .collection('transactionMain')
                    .where('userId', isEqualTo: uid)
                    .where('agentId', isEqualTo: agentId)
                    .get();

                //set isActive 0  for all trans
                for (var transaction in allTransactions.docs) {
                  transaction.reference.update({'isActive': 0});
                  // showSnackBar('Deleted successfully!', Get.context!);
                  log('Deleted successfully! ${transaction.reference.id}');
                }

                // set isActive 0  for farmer
                await firestore
                    .collection(collectionName)
                    .doc(agentId)
                    // .delete()
                    .update({'isActive': 0}).then(
                  (value) {
                    Get.back();
                  },
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
    );
  }

  showProductDeleteDialog(
      {required String productId, required String collectionName}) {
    showCupertinoDialog(
      context: Get.context!,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('Do you really want to delete?'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Yes'),
            onPressed: () async {
              try {
                final documentReference = FirebaseFirestore.instance
                    .collection(collectionName)
                    .doc(productId);

                await documentReference.update({'isActive': 0})
                    // .delete()
                    .then(
                  (value) {
                    Get.back();
                  },
                );
                // final uid = _auth.currentUser!.uid;
                // //first fetch all trans

                // QuerySnapshot allTransactions = await FirebaseFirestore.instance
                //     .collection('transactionMain')
                //     .where('userId', isEqualTo: uid)
                //     .where('agentId', isEqualTo: agentId)
                //     .get();

                // //set isActive 0  for all trans
                // for (var transaction in allTransactions.docs) {
                //   transaction.reference.update({'isActive': 0});
                //   // showSnackBar('Deleted successfully!', Get.context!);
                //   log('Deleted successfully! ${transaction.reference.id}');
                // }

                // // set isActive 0  for farmer
                // await firestore
                //     .collection(collectionName)
                //     .doc(agentId)
                //     // .delete()
                //     .update({'isActive': 0}).then(
                //   (value) {
                //     Get.back();
                //   },
                // );
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
    );
  }

  //add product to list
  addProduct() {
    try {
      double commissionRate = productCommissionController.value.text
              .trim()
              .isNotEmpty
          ? double.parse(productCommissionController.value.text.trim()) / 100
          : 0.0;

      double itemQuantity =
          productQuantityController.value.text.trim().isNotEmpty
              ? double.parse(productQuantityController.value.text.trim())
              : 0.0;

      double itemRate = productRateController.value.text.trim().isNotEmpty
          ? double.parse(productRateController.value.text.trim())
          : 0.0;

      double postage = postageController.value.text.trim().isNotEmpty
          ? double.parse(postageController.value.text.trim())
          : 0.0;

      double motorRent = motorRentController.value.text.trim().isNotEmpty
          ? double.parse(motorRentController.value.text.trim())
          : 0.0;

      double coolie = coolieController.value.text.trim().isNotEmpty
          ? double.parse(coolieController.value.text.trim())
          : 0.0;

      double jagaBhade = jagaBhadeController.value.text.trim().isNotEmpty
          ? double.parse(jagaBhadeController.value.text.trim())
          : 0.0;

      double caret = caretController.value.text.trim().isNotEmpty
          ? double.parse(caretController.value.text.trim())
          : 0.0;

      // Calculations
      double totalSaleItem = itemRate * itemQuantity;
      double actualCommissionItem = totalSaleItem * commissionRate;

      double totalExpenseItem = actualCommissionItem +
          motorRent +
          coolie +
          jagaBhade +
          caret +
          postage;

      totalSale += totalSaleItem;
      totalExpense += totalExpenseItem;
      actualCommission += actualCommissionItem;

      productModel = ProductModel(
        itemName: productName.value,
        itemQuantity: itemQuantity,
        itemRate: itemRate,
        totalSale: totalSaleItem,
        commission: actualCommissionItem,
      );

      productsList.add(productModel);
      productCount.value = productsList.length;

      // Clear input fields after adding the product
      productName.value = "";
      selectedProductId.value = null;
      productQuantityController.value.clear();
      productCommissionController.value.clear();
      productRateController.value.clear();
    } catch (e) {
      log("Error adding product: $e");

      showSnackBar(
          'Invalid input detected. Please check your values.', Get.context!);
    }
  }

  // addProduct() {
  //   double commissionRate =
  //       double.parse(productCommissionController.value.text.trim()) / 100;
  //   // log("commissionRate >>>$commissionRate");
  //   double itemQuantity =
  //       double.parse(productQuantityController.value.text.trim());
  //   double itemRate = double.parse(productRateController.value.text.trim());
  //   // int daag = int.parse(productBoxController.value.text.trim());
  //   double postage =
  //       double.parse(postageController.value.text.trim() ?? "") ?? 0.0;
  //   double motorRent = double.parse(motorRentController.value.text.trim());
  //   double coolie = double.parse(coolieController.value.text.trim());
  //   double jagaBhade = double.parse(jagaBhadeController.value.text.trim());
  //   double caret = double.parse(caretController.value.text.trim());
  //   //calculations
  //   double totalSaleItem = itemRate * itemQuantity;
  //   double actualCommissionItem = totalSaleItem * commissionRate;
  //   log("actualCommissionItem >>>$actualCommissionItem");
  //   // actualMotorRent = motorRent * daag;
  //   // actualCoolie = coolie * daag;
  //   // actualJagaBhade = jagaBhade * daag;
  //   // actualCaret = caret * daag;
  //   double totalExpenseItem =
  //       actualCommissionItem + motorRent + coolie + jagaBhade + caret + postage;
  //   totalSale += totalSaleItem;
  //   totalExpense += totalExpenseItem;
  //   // actualDaag += daag;
  //   actualCommission += actualCommissionItem;
  //   log("actualCommission after addition >>>$actualCommission");
  //   productModel = ProductModel(
  //     itemName: productName.value,
  //     itemQuantity: itemQuantity,
  //     itemRate: itemRate,
  //     totalSale: totalSaleItem,
  //     commission: actualCommissionItem,
  //   );
  //   productsList.add(productModel);
  //   productCount.value = productsList.length;
  //   // showSnackBar('Total Sale: $totalSale', Get.context!);
  //   // Clear input fields after adding the product
  //   productName.value = "";
  //   selectedProductId.value = null;
  //   productQuantityController.value.clear();
  //   productCommissionController.value.clear();
  //   // productBoxController.value.clear();
  //   productRateController.value.clear();
  // }

  removeProduct(int index) {
    totalSale -= productsList[index].totalSale;
    actualCommission -= productsList[index].commission;
    productsList.removeAt(index);
    productCount.value = productsList.length;
  }
}
