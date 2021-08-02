import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String? id;
  final String userID;
  final String title;
  final String description;
  final String? category;
  final String? subcategory;
  final String condition;
  final num price;
  final List<String> images;
  final DateTime publishedAt;

  Order({
    this.id,
    required this.userID,
    required this.title,
    required this.description,
    required this.category,
    this.subcategory,
    required this.condition,
    required this.price,
    required this.images,
    required this.publishedAt,
  });

  factory Order.fromDocument(DocumentSnapshot doc) {
    return Order(
      id: doc.id,
      userID: doc.data()?['userID'].toString() ?? "",
      title: doc.data()?['title'] ?? "",
      description: doc.data()?['description'] ?? "",
      condition: doc.data()?['condition'] ?? "",
      price: doc.data()?['price'] ?? 0,
      category: doc.data()?['category'],
      subcategory: doc.data()?['subcategory'],
      images: List<String>.from(doc.data()?['images'] ?? []),
      publishedAt: DateTime.tryParse(
              (doc.data()?['publishedAt'] as Timestamp).toDate().toString()) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userID': userID,
        'title': title,
        'description': description,
        'condition': condition,
        'category': category,
        'subcategory': subcategory,
        'price': price,
        'images': images,
        'publishedAt': publishedAt,
      };
}
