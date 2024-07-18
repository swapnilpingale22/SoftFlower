import 'package:cloud_firestore/cloud_firestore.dart';

class Agent {
  final String agentId;
  final String agentName;
  final String agentCity;
  final double motorRent;
  final double coolie;
  final double postage;
  final double caret;

  const Agent({
    required this.agentId,
    required this.agentName,
    required this.agentCity,
    required this.motorRent,
    required this.coolie,
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
      'postage': postage,
      'caret': caret,
    };
  }

  factory Agent.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Agent(
      agentId: snapshot['agentId'],
      agentName: snapshot['agentName'],
      agentCity: snapshot['agentCity'],
      motorRent: snapshot['motorRent'],
      coolie: snapshot['coolie'],
      postage: snapshot['postage'],
      caret: snapshot['caret'],
    );
  }
}
