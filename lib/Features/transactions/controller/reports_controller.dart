import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportsController extends GetxController {
  var dataList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
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
    } catch (e) {
      log("Error fetching data: $e");
    }
  }
}
