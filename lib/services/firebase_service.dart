import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/lost_found_model.dart';

/// All Firestore code for the Lost & Found module lives here.
/// Screens call these methods and never touch Firestore directly.
class FirebaseService {
  final CollectionReference<Map<String, dynamic>> _items =
      FirebaseFirestore.instance.collection('lost_found');

  /// Adds a new lost/found report.
  Future<void> addItem(LostFoundItem item) async {
    try {
      // Timeout: if there is no internet, add() would wait forever.
      await _items
          .add(item.toFirestoreMap())
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw Exception('Request timed out. Please check your internet connection.');
    } on FirebaseException catch (e) {
      throw Exception('Could not save the item (${e.code}). Please try again.');
    }
  }

  /// Live list of all items, newest first.
  /// StreamBuilder listens to this, so the UI updates automatically.
  Stream<List<LostFoundItem>> getItemsStream() {
    return _items
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => LostFoundItem.fromFirestore(doc)).toList());
  }
}
