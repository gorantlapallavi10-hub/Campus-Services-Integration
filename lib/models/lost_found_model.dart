import 'package:cloud_firestore/cloud_firestore.dart';

/// One document of the "lost_found" collection.
class LostFoundItem {
  final String id; // Firestore document id
  final String itemName;
  final String description;
  final String location;
  final DateTime date; // date the item was lost/found
  final String type; // "Lost" or "Found"
  final String contact;
  final String imageUrl; // '' when no image
  final String reportedBy;
  final DateTime createdAt;

  LostFoundItem({
    required this.id,
    required this.itemName,
    required this.description,
    required this.location,
    required this.date,
    required this.type,
    required this.contact,
    required this.imageUrl,
    required this.reportedBy,
    required this.createdAt,
  });

  /// Firestore document -> Dart object.
  factory LostFoundItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return LostFoundItem(
      id: doc.id,
      itemName: data['itemName'] as String? ?? '',
      description: data['description'] as String? ?? '',
      location: data['location'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: data['type'] as String? ?? 'Lost',
      contact: data['contact'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      reportedBy: data['reportedBy'] as String? ?? '',
      // createdAt can be null for a moment while the server sets the time.
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Dart object -> map that is saved in Firestore.
  Map<String, dynamic> toFirestoreMap() {
    return {
      'itemName': itemName,
      'description': description,
      'location': location,
      'date': Timestamp.fromDate(date),
      'type': type,
      'contact': contact,
      'imageUrl': imageUrl,
      'reportedBy': reportedBy,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
