// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantdiseaseidentifcationml/models/plant.dart';
import 'package:plantdiseaseidentifcationml/screens/community_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final CollectionReference plantsCollection =
      FirebaseFirestore.instance.collection('plants');

  Future<void> addPost(
      String author, String title, String description, String imagePath) async {
    // print(_storage);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      // Upload image to Firebase Storage
      File file = File(imagePath);
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      TaskSnapshot snapshot =
          await _storage.ref().child('post_images/$fileName').putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      // Save post data to Firestore
      await _db.collection('posts').add({
        'author': user!.displayName,
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

  // Future<void> addComment(String postId, String comment) async {
  //   try {
  //     DocumentReference postRef = _db.collection('posts').doc(postId);
  //     await postRef.update({
  //       'comments': FieldValue.arrayUnion([comment])
  //     });
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<void> addComment(String postId, String commentText) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in");
    }

    final commentData = {
      'text': commentText,
      'user': {
        'uid': user.uid,
        'name': user.displayName ?? user.email,
      },
      // 'timestamp': FieldValue.serverTimestamp(),
    };

    await _db.collection('posts').doc(postId).update({
      'comments': FieldValue.arrayUnion([commentData])
    });
  }

  Stream<List<Plant>> getPlants() {
    return plantsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Plant.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addPlant(Plant plant) {
    return plantsCollection.add(plant.toMap());
  }

  Future<List<Post>> getPosts() async {
    QuerySnapshot snapshot = await _db.collection('posts').get();
    return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }
}
