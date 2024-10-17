import 'package:cloud_firestore/cloud_firestore.dart';

class SalesMain {
  final String userId;
  final String paymentId;
  final DateTime paymentDate;
  final String customerId;
  final String customerName;
  final double balance;
  int? isActive;
  final String orderNumber;

  SalesMain({
    required this.userId,
    required this.paymentId,
    required this.paymentDate,
    required this.customerId,
    required this.customerName,
    required this.balance,
    this.isActive = 1,
    required this.orderNumber,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'paymentId': paymentId,
      'paymentDate': paymentDate,
      'customerId': customerId,
      'customerName': customerName,
      'balance': balance,
      'isActive': isActive,
      'orderNumber': orderNumber,
    };
  }

  factory SalesMain.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return SalesMain(
      userId: snapshot['userId'] ?? "",
      paymentId: snapshot['paymentId'] ?? "",
      paymentDate: snapshot['paymentDate'] != null
          ? (snapshot['paymentDate'] as Timestamp).toDate()
          : DateTime.now(),
      customerId: snapshot['customerId'] ?? "",
      customerName: snapshot['customerName'] ?? "",
      balance: snapshot['balance']?.toDouble() ?? 0.0,
      isActive: snapshot['isActive'] ?? 0,
      orderNumber: snapshot['orderNumber'] ?? "",
    );
  }
}
