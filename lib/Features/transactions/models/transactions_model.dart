// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/Features/transactions/models/transaction_details_model.dart';

class Transactions {
  final String userId;
  final String transactionId;
  final DateTime transactionDate;
  final String agentId;
  final String agentName;
  final String productId;
  final int daag;
  final double commission;
  final double motorRent;
  final double coolie;
  final double jagaBhade;
  final double postage;
  final double caret;
  final double totalSale;
  final double totalExpense;
  final double totalBalance;
  final List<TransactionDetails> transactionDetailsList;
  final String companyId;
  final String companyAddress;
  int? isActive;

  Transactions({
    required this.userId,
    required this.transactionId,
    required this.transactionDate,
    required this.agentId,
    required this.agentName,
    required this.productId,
    required this.daag,
    required this.commission,
    required this.motorRent,
    required this.coolie,
    required this.jagaBhade,
    required this.postage,
    required this.caret,
    required this.totalSale,
    required this.totalExpense,
    required this.totalBalance,
    required this.transactionDetailsList,
    required this.companyId,
    required this.companyAddress,
    this.isActive = 1,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'transactionId': transactionId,
      'transactionDate': transactionDate,
      'agentId': agentId,
      'agentName': agentName,
      'productId': productId,
      'daag': daag,
      'commission': commission,
      'motorRent': motorRent,
      'coolie': coolie,
      'jagaBhade': jagaBhade,
      'postage': postage,
      'caret': caret,
      'totalSale': totalSale,
      'totalExpense': totalExpense,
      'totalBalance': totalBalance,
      'companyId': companyId,
      'companyAddress': companyAddress,
      'isActive': isActive,
      'transactionDetailsList':
          transactionDetailsList.map((detail) => detail.toJson()).toList(),
    };
  }

  factory Transactions.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Transactions(
      userId: snapshot['userId'] ?? "",
      transactionId: snapshot['transactionId'],
      transactionDate: (snapshot['transactionDate'] as Timestamp).toDate(),
      agentId: snapshot['agentId'],
      agentName: snapshot['agentName'],
      productId: snapshot['productId'],
      daag: snapshot['daag'],
      commission: snapshot['commission'],
      motorRent: snapshot['motorRent'],
      coolie: snapshot['coolie'],
      jagaBhade: snapshot['jagaBhade'],
      postage: snapshot['postage'],
      caret: snapshot['caret'],
      totalSale: snapshot['totalSale'],
      totalExpense: snapshot['totalExpense'],
      totalBalance: snapshot['totalBalance'],
      companyId: snapshot['companyId'] ?? '',
      companyAddress: snapshot['companyAddress'] ?? '',
      isActive: snapshot['isActive'] ?? 0,
      transactionDetailsList: [],
      // transactionDetailsList: (snapshot['transactionDetailsList'] as List)
      //     .map((detail) => TransactionDetails.fromSnap(detail))
      //     .toList(),
    );
  }
  Transactions copyWith({
    List<TransactionDetails>? transactionDetailsList,
  }) {
    return Transactions(
      userId: userId,
      transactionId: transactionId,
      transactionDate: transactionDate,
      agentId: agentId,
      agentName: agentName,
      productId: productId,
      daag: daag,
      commission: commission,
      motorRent: motorRent,
      coolie: coolie,
      jagaBhade: jagaBhade,
      postage: postage,
      caret: caret,
      totalSale: totalSale,
      totalExpense: totalExpense,
      totalBalance: totalBalance,
      companyId: companyId,
      companyAddress: companyAddress,
      isActive: isActive,
      transactionDetailsList:
          transactionDetailsList ?? this.transactionDetailsList,
    );
  }
}
