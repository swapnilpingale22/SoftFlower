import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  final String companyId;
  final String companyName;
  final String ownerName;
  final String address;
  final String city;
  final int pincode;
  final int mobileNumber;

  const Company({
    required this.companyId,
    required this.companyName,
    required this.ownerName,
    required this.address,
    required this.city,
    required this.pincode,
    required this.mobileNumber,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'companyId': companyId,
      'companyName': companyName,
      'ownerName': ownerName,
      'address': address,
      'city': city,
      'pincode': pincode,
      'mobileNumber': mobileNumber,
    };
  }

  factory Company.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Company(
      companyId: snapshot['companyId'],
      companyName: snapshot['companyName'],
      ownerName: snapshot['ownerName'],
      address: snapshot['address'],
      city: snapshot['city'],
      pincode: snapshot['pincode'],
      mobileNumber: snapshot['mobileNumber'],
    );
  }
}
