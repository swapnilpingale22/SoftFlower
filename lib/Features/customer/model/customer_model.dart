import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String userId;
  final String customerId;
  final String customerName;
  final double openingBalance;
  int? isActive;

  Customer({
    required this.userId,
    required this.customerId,
    required this.customerName,
    required this.openingBalance,
    this.isActive = 1,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'customerId': customerId,
      'customerName': customerName,
      'openingBalance': openingBalance,
      'isActive': isActive,
    };
  }

  factory Customer.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Customer(
      userId: snapshot['userId'] ?? "",
      customerId: snapshot['customerId'] ?? "",
      customerName: snapshot['customerName'] ?? "",
      openingBalance: snapshot['openingBalance'] ?? 0,
      isActive: snapshot['isActive'] ?? 0,
    );
  }
}
