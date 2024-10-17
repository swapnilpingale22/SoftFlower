import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/colors.dart';
import '../../../utils/utils.dart';
import '../../customer/model/customer_model.dart';
import '../../product/models/product_model.dart';
import '../../transactions/models/product.dart';
import '../models/sales_details_model.dart';
import '../models/sales_model.dart';

class AddPaymentController extends GetxController {
  //firebase
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
//loaders & keys
  RxBool isLoading = false.obs;
  final paymentFormKey = GlobalKey<FormState>();
  final flowerListFormKey = GlobalKey<FormState>();
  RxBool isBackDated = false.obs;
//farmers
  Rx<String?> selectedCustomerId = Rx<String?>(null);
  RxList<Customer> customers = <Customer>[].obs;
  RxString customerName = "".obs;
  RxDouble openingBalance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
    fetchProducts();
    _getNextOrderNumber();
  }

  @override
  void onClose() {
    super.onClose();
    productQuantityController.value.dispose();
    productRateController.value.dispose();
  }

  void fetchCustomers() {
    final uid = _auth.currentUser!.uid;
    isLoading.value = true;
    firestore
        .collection('customer')
        .where('userId', isEqualTo: uid)
        .where('isActive', isEqualTo: 1)
        .orderBy('customerName')
        .snapshots()
        .listen((snapshot) {
      customers.value =
          snapshot.docs.map((doc) => Customer.fromSnap(doc)).toList();
      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
      log("Error fetching customers: $e");
    });
  }

  void fetchAgentDetails(String customerId) {
    Customer? customer = customers.firstWhere(
      (a) => a.customerId == customerId,
    );

    customerName.value = customer.customerName;
    openingBalance.value = customer.openingBalance;
    balanceController.value.text = customer.openingBalance.toStringAsFixed(0);
  }

//date
  Rx<DateTime?> selectedTransactionDate = Rx<DateTime?>(null);
  DateTime? selectedDate;

  //balance
  Rx<TextEditingController> balanceController = TextEditingController().obs;

  //product
  Rx<String?> selectedProductId = Rx<String?>(null);
  RxList<Product> products = <Product>[].obs;
  RxString productName = "".obs;
  Rx<TextEditingController> productQuantityController =
      TextEditingController().obs;
  Rx<TextEditingController> productRateController = TextEditingController().obs;
  double totalSale = 0.0;
  late ProductModel productModel;

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

  void fetchProductDetails(String productId) {
    Product? product = products.firstWhere(
      (p) => p.productId == productId,
    );

    productName.value = product.productName;
  }

  //product list
  RxList<ProductModel> productsList = <ProductModel>[].obs;
  var productCount = 0.obs;

  addProduct() {
    double itemQuantity =
        double.parse(productQuantityController.value.text.trim());

    double itemRate = double.parse(productRateController.value.text.trim());

    //calculations

    double totalSaleItem = itemRate * itemQuantity;

    totalSale += totalSaleItem;

    productModel = ProductModel(
      itemName: productName.value,
      itemQuantity: itemQuantity,
      itemRate: itemRate,
      totalSale: totalSaleItem,
      commission: 0,
    );

    productsList.add(productModel);
    productCount.value = productsList.length;

    // Clear input fields after adding the product
    productName.value = "";
    selectedProductId.value = null;
    productQuantityController.value.clear();
    productRateController.value.clear();
  }

  removeProduct(int index) {
    totalSale -= productsList[index].totalSale;
    productsList.removeAt(index);
    productCount.value = productsList.length;
  }

  //add payment
  RxBool isSaveLoading = false.obs;
  RxBool isSaveLoading2 = false.obs;
  RxInt currentOrderNumber = 0.obs;

  Future<int> _getNextOrderNumber() async {
    final uid = _auth.currentUser!.uid;

    QuerySnapshot snapshot = await firestore
        .collection('salesMain')
        .where('userId', isEqualTo: uid)
        .orderBy('orderNumber', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      currentOrderNumber.value = int.parse(snapshot.docs.first['orderNumber']);
    }
    currentOrderNumber.value++;

    log("currentOrderNumber >>> ${currentOrderNumber.value}");

    return currentOrderNumber.value;
  }

  void addTransactionMainToDB() async {
    isSaveLoading.value = true;

    try {
      DateTime selectedDate = selectedTransactionDate.value ?? DateTime.now();

      DateTime selectedDateWithoutTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      final uid = _auth.currentUser!.uid;

      QuerySnapshot snapshot = await firestore
          .collection('salesMain')
          .where('userId', isEqualTo: uid)
          .get();

      // bool transactionExists = snapshot.docs.isNotEmpty;
      bool transactionExists = false;

      for (var doc in snapshot.docs) {
        var customerId = doc['customerId'];
        var isActive = doc['isActive'];

        DateTime paymentDate = (doc['paymentDate'] as Timestamp).toDate();
        DateTime transactionDateWithoutTime = DateTime(
          paymentDate.year,
          paymentDate.month,
          paymentDate.day,
        );

        if (transactionDateWithoutTime == selectedDateWithoutTime &&
            customerId == selectedCustomerId.value &&
            isActive == 1) {
          transactionExists = true;
          break;
        }
      }
      // Get the next order number
      // int nextOrderNumber = await _getNextOrderNumber();
      // int nextOrderNumber = currentOrderNumber.value;

      if (transactionExists) {
        isSaveLoading.value = false;
        _showTransactionExistsDialog(
            selectedDateWithoutTime, currentOrderNumber.value);
        return;
      }

      _saveTransactionToDB(selectedDateWithoutTime, currentOrderNumber.value);
    } catch (e) {
      isSaveLoading.value = false;
      log(e.toString());
      showSnackBar(e.toString(), Get.context!);
    }
  }

  void _saveTransactionToDB(
    DateTime selectedDateWithoutTime,
    int orderNumber,
  ) async {
    isSaveLoading2.value = true;
    String res = await addTransactionMain(
      transactionDate: selectedDateWithoutTime,
      customerId: selectedCustomerId.value ?? "",
      orderNumber: orderNumber,
    );

    if (res == "Success") {
      // Clear the form and show success snackbar
      customerName.value = "";
      totalSale = 0.0;
      productsList.clear();

      isSaveLoading.value = false;
      isSaveLoading2.value = false;
      Get.back();
      Get.back();
      showSnackBar('Payment saved', Get.context!);
    } else {
      isSaveLoading.value = false;
      isSaveLoading2.value = false;
      showSnackBar(res, Get.context!);
    }
  }

  Future<String> addTransactionMain({
    required String customerId,
    required DateTime transactionDate,
    required int orderNumber,
  }) async {
    String res = "Some error occured";
    final userId = _auth.currentUser!.uid;

    try {
      String paymentId = const Uuid().v1();

      SalesMain salesMain = SalesMain(
        userId: userId,
        paymentId: paymentId,
        paymentDate: transactionDate,
        customerId: customerId,
        customerName: customerName.value,
        balance: openingBalance.value,
        orderNumber: orderNumber.toString().padLeft(4, '0'),
      );

      WriteBatch batch = firestore.batch();

      DocumentReference mainTransactionRef =
          firestore.collection('salesMain').doc(paymentId);

      batch.set(mainTransactionRef, salesMain.toJson());

      // await firestore.collection('salesMain').doc(paymentId).set(
      //       salesMain.toJson(),
      //     );

      //add transaction details

      for (var product in productsList) {
        String salesDetailsId = const Uuid().v1();

        SalesDetails salesDetails = SalesDetails(
          salesMainId: paymentId,
          salesDetailsId: salesDetailsId,
          itemName: product.itemName,
          quantity: product.itemQuantity,
          rate: product.itemRate,
          saleAmount: product.totalSale,
          userId: userId,
        );

        DocumentReference detailsRef =
            firestore.collection('salesDetails').doc(salesDetailsId);

        batch.set(detailsRef, salesDetails.toJson());

        // await firestore.collection('salesDetails').doc(salesDetailsId).set(
        //       salesDetails.toJson(),
        //     );
      }

      await batch.commit();

      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  _showTransactionExistsDialog(
    DateTime selectedDateWithoutTime,
    int nextOrderNumber,
  ) {
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
                _saveTransactionToDB(selectedDateWithoutTime, nextOrderNumber);
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
}
