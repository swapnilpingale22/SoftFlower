import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  String? userType;

  User({
    required this.email,
    required this.uid,
    this.userType = 'user',
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'userType': userType,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      userType: snapshot['userType'],
    );
  }
}
