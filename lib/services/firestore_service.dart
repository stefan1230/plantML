import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addPost(String userName, String title, String description,
      String imageUrl) async {
    try {
      await _db.collection('posts').add({
        'userName': userName,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding post: $e');
      throw e;
    }
  }
}
