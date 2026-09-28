import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// All Firebase Storage code (image upload) lives here.
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads image bytes and returns the download URL.
  Future<String> uploadImage(Uint8List bytes, {String? contentType}) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('lost_found_images/$fileName');

      await ref
          .putData(bytes, SettableMetadata(contentType: contentType ?? 'image/jpeg'))
          .timeout(const Duration(seconds: 30));

      return await ref.getDownloadURL();
    } on TimeoutException {
      throw Exception('Image upload timed out. Please check your internet connection.');
    } on FirebaseException catch (e) {
      throw Exception('Image upload failed (${e.code}). Please try again.');
    }
  }
}
