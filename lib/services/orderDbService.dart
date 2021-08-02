import 'package:bidding_app/models/bids.dart';
import 'package:bidding_app/models/order.dart';
import 'package:bidding_app/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDBServices {
  String? uid;
  late CollectionReference productsRef;
  late CollectionReference userRef;

  OrderDBServices({String? uid}) {
    this.uid = uid;
    productsRef = FirebaseFirestore.instance.collection('products');
    userRef = FirebaseFirestore.instance.collection('users');
  }

  Future makeOrder({
    required Product product,
    required num price,
  }) async {
    Order order = Order(
        userID: uid!,
        title: product.title,
        description: product.description,
        category: product.category,
        subcategory: product.subcategory,
        condition: product.condition,
        price: price,
        images: product.images,
        publishedAt: DateTime.now());
    await userRef.doc(uid).collection('orders').add(order.toMap());
    await productsRef.doc(product.id).delete();
  }

  Future<Order> getOneOrder(String oId) async {
    DocumentSnapshot snapshot = await userRef.doc(uid).collection('orders').doc(oId).get();
    return Order.fromDocument(snapshot);
  }

  Stream<List<Order>> fetchMyOrders() {
    return userRef
        .doc(uid)
        .collection('orders')
        .orderBy('publishedAt', descending: true)
        .snapshots()
        .asyncMap<List<Order>>((event) =>
            event.docs.map<Order>((d) => Order.fromDocument(d)).toList());
  }

  Future addNewBid({required pId, required String value}) async {
    Bids bid = Bids(
      user: uid!,
      value: value,
      publishedAt: DateTime.now(),
    );
    await productsRef.doc(pId).collection('bids').add(bid.toMap());
  }

  Stream<List<Bids>> fetchAllBids(String pId) => productsRef
      .doc(pId)
      .collection('bids')
      .orderBy('publishedAt', descending: true)
      .snapshots()
      .map<List<Bids>>(
          (event) => event.docs.map((e) => Bids.fromDocument(e)).toList());
}
