import 'package:cloud_firestore/cloud_firestore.dart';

class SalesDetails {
  final String salesMainId;
  final String salesDetailsId;
  final String itemName;
  final double quantity;
  final double rate;
  final double saleAmount;
  final String userId;
  int? isActive;

  SalesDetails({
    required this.salesMainId,
    required this.salesDetailsId,
    required this.itemName,
    required this.quantity,
    required this.rate,
    required this.saleAmount,
    required this.userId,
    this.isActive = 1,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'salesMainId': salesMainId,
      'transactionDetailsId': salesDetailsId,
      'itemName': itemName,
      'quantity': quantity,
      'rate': rate,
      'saleAmount': saleAmount,
      'userId': userId,
      'isActive': isActive,
    };
  }

  factory SalesDetails.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return SalesDetails(
      salesMainId: snapshot['salesMainId'] ?? "",
      salesDetailsId: snapshot['salesDetailsId'] ?? "",
      itemName: snapshot['itemName'] ?? "",
      quantity: (snapshot['quantity'] as num).toDouble(),
      rate: snapshot['rate'] ?? 0,
      saleAmount: snapshot['saleAmount'] ?? 0,
      userId: snapshot['userId'] ?? "",
      isActive: snapshot['isActive'] ?? 0,
    );
  }
}
