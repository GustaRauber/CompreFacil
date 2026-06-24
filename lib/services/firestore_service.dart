import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<List<ShoppingList>> userShoppingLists(String userId) {
    final query = _firestore
        .collection('users')
        .doc(userId)
        .collection('shopping_lists')
        .orderBy('createdAt', descending: true);

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ShoppingList.fromDocument(doc))
        .toList(growable: false));
  }

  static Future<void> createShoppingList({
    required String userId,
    required String title,
  }) async {
    final collection =
        _firestore.collection('users').doc(userId).collection('shopping_lists');

    await collection.add({
      'title': title,
      'itemsCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

class ShoppingList {
  final String id;
  final String title;
  final int itemsCount;
  final DateTime? createdAt;

  ShoppingList({
    required this.id,
    required this.title,
    required this.itemsCount,
    required this.createdAt,
  });

  factory ShoppingList.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final timestamp = data['createdAt'];
    return ShoppingList(
      id: doc.id,
      title: data['title'] as String? ?? 'Lista sem título',
      itemsCount: (data['itemsCount'] as num?)?.toInt() ?? 0,
      createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }
}
