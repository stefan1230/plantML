import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantdiseaseidentifcationml/screens/community_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addPost(String author, String title, String description, String imagePath) async {

    try {
      // Upload image to Firebase Storage
      File file = File(imagePath);
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      TaskSnapshot snapshot = await _storage.ref().child('post_images/$fileName').putFile(file);
print('here, $snapshot');
      String downloadUrl = await snapshot.ref.getDownloadURL();
      // Save post data to Firestore
      await _db.collection('posts').add({
        'author': author,
        'title': title,
        'description': description,
        'imageUrl': downloadUrl,
        'comments': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }

  //   Future<List<Post>> fetchPosts() async {
  //   try {
  //     QuerySnapshot snapshot = await _db.collection('posts').get();
  //     return snapshot.docs.map((doc) {
  //       return Post(
  //         author: doc['author'],
  //         title: doc['title'],
  //         description: doc['description'],
  //         imageUrl: doc['imageUrl'],
  //         comments: List<String>.from(doc['comments']),
  //       );
  //     }).toList();
  //   } catch (e) {
  //     print('Error fetching posts: $e');
  //     throw e;
  //   }
  // }


   Future<void> addComment(String postId, String comment) async {
    try {
      DocumentReference postRef = _db.collection('posts').doc(postId);
      await postRef.update({
        'comments': FieldValue.arrayUnion([comment])
      });
    } catch (e) {
      throw e;
    }
  }

  Future<List<Post>> getPosts() async {
    QuerySnapshot snapshot = await _db.collection('posts').get();
    return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }
}
