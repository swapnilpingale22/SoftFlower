import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  String? userType;
  String? companyName;
  String? ownerName;
  String? address;
  String? city;
  int? pincode;
  int? mobileNumber;
  int? isActive;

  User({
    required this.email,
    required this.uid,
    this.userType = 'user',
    this.companyName = "",
    this.ownerName = "",
    this.address = "",
    this.city = "",
    this.pincode = 0,
    this.mobileNumber = 0,
    this.isActive = 1,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'userType': userType,
        'companyName': companyName,
        'ownerName': ownerName,
        'address': address,
        'city': city,
        'pincode': pincode,
        'mobileNumber': mobileNumber,
        'isActive': isActive,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'] ?? "",
      uid: snapshot['uid'] ?? "",
      userType: snapshot['userType'] ?? "",
      companyName: snapshot['companyName'] ?? "",
      ownerName: snapshot['ownerName'] ?? "",
      address: snapshot['address'] ?? "",
      city: snapshot['city'] ?? "",
      pincode: snapshot['pincode'] ?? 0,
      mobileNumber: snapshot['mobileNumber'] ?? 0,
      isActive: snapshot['isActive'] ?? 0,
    );
  }
}
