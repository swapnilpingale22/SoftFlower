import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/Features/agent/models/agent_model.dart';
import 'package:expense_manager/Features/company/models/company_model.dart';
import 'package:expense_manager/Features/product/models/product_model.dart';
import 'package:get/get.dart';

class AddTransactionController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //company
  Rx<String?> selectedCompanyId = Rx<String?>(null);
  RxList<Company> companies = <Company>[].obs;

  //agent
  Rx<String?> selectedAgentId = Rx<String?>(null);
  RxList<Agent> agents = <Agent>[].obs;

  //product
  Rx<String?> selectedProductId = Rx<String?>(null);
  RxList<Product> products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgents();
    fetchCompanies();
    fetchProducts();
  }

  Future<void> fetchCompanies() async {
    QuerySnapshot querySnapshot = await firestore.collection('company').get();

    companies.value =
        querySnapshot.docs.map((doc) => Company.fromSnap(doc)).toList();
  }

  Future<void> fetchAgents() async {
    QuerySnapshot querySnapshot = await firestore.collection('agent').get();

    agents.value =
        querySnapshot.docs.map((doc) => Agent.fromSnap(doc)).toList();
  }

  Future<void> fetchProducts() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('product').get();
      products.value =
          querySnapshot.docs.map((doc) => Product.fromSnap(doc)).toList();
    } catch (e) {
      log("Error fetching products: $e");
    }

    // QuerySnapshot querySnapshot = await firestore.collection('product').get();

    // products.value =
    //     querySnapshot.docs.map((doc) => Product.fromSnap(doc)).toList();
  }
}
