import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/Features/agent/models/agent_model.dart';
import 'package:expense_manager/Features/company/models/company_model.dart';
import 'package:expense_manager/Features/product/models/product_model.dart';
import 'package:expense_manager/Features/transactions/models/product.dart';
import 'package:expense_manager/Features/transactions/models/transaction_details_model.dart';
import 'package:expense_manager/Features/transactions/models/transaction_main_model.dart';
import 'package:expense_manager/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddTransactionController extends GetxController {
  final transactionFormKey = GlobalKey<FormState>();
  final productListFormKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  RxBool isSaveLoading = false.obs;
  //company
  Rx<String?> selectedCompanyId = Rx<String?>(null);
  RxList<Company> companies = <Company>[].obs;

  //agent
  Rx<String?> selectedAgentId = Rx<String?>(null);
  RxList<Agent> agents = <Agent>[].obs;

  //product
  Rx<String?> selectedProductId = Rx<String?>(null);
  RxList<Product> products = <Product>[].obs;

  //agent
  RxString agentName = "".obs;
  Rx<TextEditingController> motorRentController = TextEditingController().obs;
  Rx<TextEditingController> coolieController = TextEditingController().obs;
  Rx<TextEditingController> jagaBhadeController = TextEditingController().obs;
  Rx<TextEditingController> postageController = TextEditingController().obs;
  Rx<TextEditingController> caretController = TextEditingController().obs;

  //product
  RxString productName = "".obs;
  Rx<TextEditingController> productQuantityController =
      TextEditingController().obs;
  Rx<TextEditingController> productComissionController =
      TextEditingController().obs;
  Rx<TextEditingController> productBoxController = TextEditingController().obs;
  Rx<TextEditingController> productRateController = TextEditingController().obs;

  double totalSale = 0.0;
  double totalExpense = 0.0;
  double totalBalance = 0.0;
  double actualCommission = 0.0;
  double actualMotorRent = 0.0;
  double actualCoolie = 0.0;
  double actualJagaBhade = 0.0;
  double actualCaret = 0.0;

  RxList<ProductModel> productsList = <ProductModel>[].obs;

  late ProductModel productModel;
  var productCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgents();
    fetchCompanies();
    fetchProducts();
  }

  @override
  void onClose() {
    motorRentController.value.dispose();
    coolieController.value.dispose();
    jagaBhadeController.value.dispose();
    postageController.value.dispose();
    caretController.value.dispose();
    productQuantityController.value.dispose();
    productComissionController.value.dispose();
    productBoxController.value.dispose();
    productRateController.value.dispose();
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

  void fetchCompanies() {
    isLoading.value = true;
    firestore.collection('company').snapshots().listen((snapshot) {
      companies.value =
          snapshot.docs.map((doc) => Company.fromSnap(doc)).toList();
      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
      log("Error fetching companies: $e");
    });
  }

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
    isLoading.value = true;
    firestore.collection('agent').snapshots().listen((snapshot) {
      agents.value = snapshot.docs.map((doc) => Agent.fromSnap(doc)).toList();
      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
      log("Error fetching agents: $e");
    });
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
    isLoading.value = true;
    firestore.collection('product').snapshots().listen((snapshot) {
      products.value =
          snapshot.docs.map((doc) => Product.fromSnap(doc)).toList();
      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
      log("Error fetching products: $e");
    });
  }

  void fetchAgentDetails(String agentId) {
    Agent? agent = agents.firstWhere(
      (a) => a.agentId == agentId,
    );
    if (agent != null) {
      agentName.value = agent.agentName;
      motorRentController.value.text = agent.motorRent.toString();
      coolieController.value.text = agent.coolie.toString();
      jagaBhadeController.value.text = agent.jagaBhade.toString();
      postageController.value.text = agent.postage.toString();
      caretController.value.text = agent.caret.toString();
    }
  }

  void fetchProductDetails(String productId) {
    Product? product = products.firstWhere(
      (p) => p.productId == productId,
    );
    if (product != null) {
      productName.value = product.productName;
      productQuantityController.value.text = product.quantity.toString();
      productComissionController.value.text = product.commission.toString();
    }
  }

  //save transaction

  Future<String> addTransactionMain({
    required String agentId, //
    required String agentName, //
    required double caret, //
    required double commission, //
    required double coolie, //
    // required int daag, //
    required double jagaBhade, //
    required double motorRent, //
    required double postage, //
    required String productId, //
    required double totalBalance, //
    required double totalExpense, //
    //total sale
    // required double totalSale,
    required DateTime transactionDate, //
    //transaction id
    //
    // required String itemName, //2
    // required int quantity, //2
    // required double rate, //2
    //each total sale
    //transaction details id
    //transaction main id
  }) async {
    String res = "Some error occured";

    try {
      String transactionId = const Uuid().v1();

      TransactionMain transactionMain = TransactionMain(
        transactionId: transactionId,
        transactionDate: transactionDate,
        agentId: agentId,
        agentName: agentName,
        productId: productId,
        daag: 0,
        commission: commission,
        motorRent: motorRent,
        coolie: coolie,
        jagaBhade: jagaBhade,
        postage: postage,
        caret: caret,
        totalSale: totalSale,
        totalExpense: totalExpense,
        totalBalance: totalBalance,
      );

      await firestore.collection('transactionMain').doc(transactionId).set(
            transactionMain.toJson(),
          );

      //add transaction details

      // String transactionDetailsId = const Uuid().v1();

      // TransactionDetails transactionDetails = TransactionDetails(
      //   transactionMainId: transactionId,
      //   transactionDetailsId: transactionDetailsId,
      //   itemName: itemName,
      //   quantity: quantity,
      //   rate: rate,
      //   totalSale: totalSale,
      // );

      // await firestore
      //     .collection('transactionMain')
      //     .doc(transactionId)
      //     .collection('transactionDetails')
      //     .doc(transactionDetailsId)
      //     .set(
      //       transactionDetails.toJson(),
      //     );

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

    // totalSale = (double.parse(productQuantityController.value.text.trim()) *
    //     double.parse(productRateController.value.text.trim()));

    // final actualCommission = (totalSale *
    //         double.parse(productComissionController.value.text.trim())) /
    //     100;

    // final actualMotorRent = int.parse(productBoxController.value.text.trim()) *
    //     double.parse(motorRentController.value.text.trim());

    // final actualCoolie = int.parse(productBoxController.value.text.trim()) *
    //     double.parse(coolieController.value.text.trim());

    // final actualJagaBhade = int.parse(productBoxController.value.text.trim()) *
    //     double.parse(jagaBhadeController.value.text.trim());

    // final actualCaret = int.parse(productBoxController.value.text.trim()) *
    //     double.parse(caretController.value.text.trim());

    totalExpense = double.parse(postageController.value.text.trim()) +
        actualCommission +
        actualMotorRent +
        actualCoolie +
        actualJagaBhade +
        actualCaret;

    totalBalance = totalSale - totalExpense;

    try {
      String res = await addTransactionMain(
        transactionDate: DateTime.now(),
        agentId: selectedAgentId.value ?? "",
        agentName: agentName.value,
        productId: selectedProductId.value ?? "",
        // daag: int.parse(productBoxController.value.text.trim()),
        commission: actualCommission,
        motorRent: actualMotorRent,
        coolie: actualCoolie,
        jagaBhade: actualJagaBhade,
        postage: double.parse(postageController.value.text.trim()),
        caret: actualCaret,
        // totalSale: totalSale,
        totalExpense: totalExpense,
        totalBalance: totalBalance,
        // itemName: productName.value,
        // quantity: int.parse(productQuantityController.value.text),
        // rate: double.parse(productRateController.value.text),
      );

      if (res == "Success") {
        agentName.value = "";
        productBoxController.value.clear();
        productComissionController.value.clear();
        motorRentController.value.clear();
        coolieController.value.clear();
        jagaBhadeController.value.clear();
        postageController.value.clear();
        caretController.value.clear();
        totalSale = 0.0;
        totalExpense = 0.0;
        totalBalance = 0.0;
        productsList.clear();

        // isLoading.value = false;
        isSaveLoading.value = false;
        Get.back();
        showSnackBar('Transaction saved', Get.context!);
      } else {
        isSaveLoading.value = false;

        showSnackBar(res, Get.context!);
      }
    } catch (e) {
      isSaveLoading.value = false;
      log(e.toString());
      showSnackBar(e.toString(), Get.context!);
    }
  }

  // Future<void> deleteDocument(
  //     {required String agentId, required String collectionName}) async {}

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
                await firestore
                    .collection(collectionName)
                    .doc(agentId)
                    .delete()
                    .then(
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

  //add product to list

  addProduct(
    String itemName,
    int itemQuantity,
    double itemRate,
    double totalSale,
  ) {
    productModel = ProductModel(
      itemName: itemName,
      itemQuantity: itemQuantity,
      itemRate: itemRate,
      totalSale: totalSale,
    );
    productsList.add(productModel);
    productCount.value = productsList.length;

    // Add the product's totalSale to the cumulative totalSale
    this.totalSale += totalSale;

    showSnackBar('Total Sale: $totalSale', Get.context!);

    // Clear input fields after adding the product
    productName.value = "";
    selectedProductId.value = null;
    productQuantityController.value.clear();
    productComissionController.value.clear();
    productBoxController.value.clear();
    productRateController.value.clear();
  }

  removeProduct(int index) {
    // Subtract the product's totalSale from the cumulative totalSale
    totalSale -= productsList[index].totalSale;

    productsList.removeAt(index);
    productCount.value = productsList.length;

    showSnackBar('Total Sale: $totalSale', Get.context!);
  }
}
