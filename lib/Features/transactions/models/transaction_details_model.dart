import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionDetails {
  final String transactionMainId;
  final String transactionDetailsId;
  final String itemName;
  final double quantity;
  final double rate;
  final double totalSale;

  const TransactionDetails({
    required this.transactionMainId,
    required this.transactionDetailsId,
    required this.itemName,
    required this.quantity,
    required this.rate,
    required this.totalSale,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'transactionMainId': transactionMainId,
      'transactionDetailsId': transactionDetailsId,
      'itemName': itemName,
      'quantity': quantity,
      'rate': rate,
      'totalSale': totalSale,
    };
  }

  factory TransactionDetails.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TransactionDetails(
      transactionMainId: snapshot['transactionMainId'],
      transactionDetailsId: snapshot['transactionDetailsId'],
      itemName: snapshot['itemName'],
      quantity: (snapshot['quantity'] as num).toDouble(),
      rate: snapshot['rate'],
      totalSale: snapshot['totalSale'],
    );
  }
}
