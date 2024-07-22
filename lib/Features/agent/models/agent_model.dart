// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Agent {
  final String agentId;
  final String agentName;
  final String agentCity;
  final double motorRent;
  final double coolie;
  final double jagaBhade;
  final double postage;
  final double caret;

  const Agent({
    required this.agentId,
    required this.agentName,
    required this.agentCity,
    required this.motorRent,
    required this.coolie,
    required this.jagaBhade,
    required this.postage,
    required this.caret,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'agentId': agentId,
      'agentName': agentName,
      'agentCity': agentCity,
      'motorRent': motorRent,
      'coolie': coolie,
      'jagaBhade': jagaBhade,
      'postage': postage,
      'caret': caret,
    };
  }

  factory Agent.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Agent(
      agentId: snapshot['agentId'] ?? "",
      agentName: snapshot['agentName'] ?? "",
      agentCity: snapshot['agentCity'] ?? "",
      motorRent: snapshot['motorRent'] ?? 0.0,
      coolie: snapshot['coolie'] ?? 0.0,
      jagaBhade: snapshot['jagaBhade'] ?? 0.0,
      postage: snapshot['postage'] ?? 0.0,
      caret: snapshot['caret'] ?? 0.0,
    );
  }
}
