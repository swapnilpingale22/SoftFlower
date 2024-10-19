import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerAdvance {
  final String userId;
  final String paymentId;
  final DateTime paymentDate;
  final String customerId;
  final String customerName;
  final double custPaidAmount;
  String? remark;
  int? isActive;

  CustomerAdvance({
    required this.userId,
    required this.paymentId,
    required this.paymentDate,
    required this.customerId,
    required this.customerName,
    required this.custPaidAmount,
    this.remark = "",
    this.isActive = 1,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'paymentId': paymentId,
      'paymentDate': paymentDate,
      'customerId': customerId,
      'customerName': customerName,
      'custPaidAmount': custPaidAmount,
      'remark': remark,
      'isActive': isActive,
    };
  }

  factory CustomerAdvance.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CustomerAdvance(
      userId: snapshot['userId'] ?? "",
      paymentId: snapshot['paymentId'] ?? "",
      paymentDate: snapshot['paymentDate'] != null
          ? (snapshot['paymentDate'] as Timestamp).toDate()
          : DateTime.now(),
      customerId: snapshot['customerId'] ?? "",
      customerName: snapshot['customerName'] ?? "",
      custPaidAmount: snapshot['custPaidAmount'] ?? 0,
      remark: snapshot['remark'] ?? "",
      isActive: snapshot['isActive'] ?? 0,
    );
  }
}
