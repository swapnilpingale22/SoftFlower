import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String userId;
  final String productId;
  // final int productNumber;
  final String productName;
  // final int quantity;
  final double commission;
  final String bundleType;
  int? isActive;

  Product({
    required this.userId,
    required this.productId,
    // required this.productNumber,
    required this.productName,
    // required this.quantity,
    required this.commission,
    required this.bundleType,
    this.isActive = 1,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'productId': productId,
      // 'productNumber': productNumber,
      'productName': productName,
      // 'quantity': quantity,
      'commission': commission,
      'bundleType': bundleType,
      'isActive': isActive,
    };
  }

  factory Product.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Product(
      userId: snapshot['userId'] ?? "",
      productId: snapshot['productId'],
      // productNumber: snapshot['productNumber'],
      productName: snapshot['productName'],
      // quantity: snapshot['quantity'],
      commission: snapshot['commission'],
      bundleType: snapshot['bundleType'],
      isActive: snapshot['isActive'] ?? 0,
    );
  }
}
