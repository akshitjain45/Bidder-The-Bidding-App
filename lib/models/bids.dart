import 'package:cloud_firestore/cloud_firestore.dart';

class Bids {
  final String? id;
  final String user;
  final String value;
  final DateTime publishedAt;

  Bids({
    this.id,
    required this.user,
    required this.value,
    required this.publishedAt,
  });

  factory Bids.fromDocument(DocumentSnapshot doc) {
    return Bids(
      id: doc.id,
      user: doc.data()?['user'].toString() ?? "",
      value: doc.data()?['value'] ?? "",
      publishedAt: DateTime.parse(
          (doc.data()!['publishedAt'] as Timestamp).toDate().toString()),
    );
  }

  Map<String, dynamic> toMap() => {
        'user': user,
        'value': value,
        'publishedAt': publishedAt,
      };
}
