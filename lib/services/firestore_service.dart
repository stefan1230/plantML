import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:plantdiseaseidentifcationml/models/plant.dart';

import '../models/notification.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final CollectionReference plantsCollection =
      FirebaseFirestore.instance.collection('plants');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addPost(
      String author, String title, String description, String imagePath) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      File file = File(imagePath);
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      TaskSnapshot snapshot =
          await _storage.ref().child('post_images/$fileName').putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();
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

  Future<void> addPlant(Plant plant) async {
    await plantsCollection.add(plant.toMap());
  }

  Stream<List<Plant>> getPlants() {
    return plantsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Plant.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addProgressImage(String plantId, File image) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in");
    }

    String fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${user.uid}.jpg';
    TaskSnapshot snapshot =
        await _storage.ref().child('plants/$plantId/$fileName').putFile(image);
    String downloadUrl = await snapshot.ref.getDownloadURL();

    await plantsCollection.doc(plantId).update({
      'progressImages': FieldValue.arrayUnion([downloadUrl]),
    });
  }

  Future<void> addSampleData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in");
    }

    List<Plant> samplePlants = [
      Plant(
        id: '1',
        imageUrl: 'https://via.placeholder.com/150',
        diagnosis: 'Chilli Corcospora Leaf Spot',
        remedies: 'Complete',
        prevention: 'Test Prevention',
      ),
      Plant(
        id: '2',
        imageUrl: 'https://via.placeholder.com/150',
        diagnosis: 'Tomato Blight',
        remedies: 'Complete',
        prevention: 'Test Prevention',
      ),
    ];

    for (Plant plant in samplePlants) {
      DocumentReference plantRef = await plantsCollection.add(plant.toMap());

      // Add sample progress images
      List<String> progressImages = [
        'https://via.placeholder.com/150/1',
        'https://via.placeholder.com/150/2',
        'https://via.placeholder.com/150/3',
      ];

      for (String imageUrl in progressImages) {
        await plantRef.update({
          'progressImages': FieldValue.arrayUnion([imageUrl]),
        });
      }
    }
  }

  Future<void> addSampleNotifications() async {
    final CollectionReference alertsCollection =
        _db.collection('diseaseAlerts');
    List<Map<String, dynamic>> sampleAlerts = [
      {
        'title': 'Powdery Mildew Outbreak',
        'description':
            'There is an outbreak of Powdery Mildew in the following areas...',
        'affectedAreas': ['Area1', 'Area2'],
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Blight Outbreak Alert',
        'description':
            'A severe blight outbreak has been reported in your area. Take immediate action to protect your crops.',
        'affectedAreas': ['Area3', 'Area4'],
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var alert in sampleAlerts) {
      await alertsCollection.add(alert);
    }
  }

  Stream<List<NotificationItem>> getAlerts() {
    return _db.collection('diseaseAlerts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationItem(
          id: doc.id,
          title: doc['title'],
          description: doc['description'],
          affectedAreas: List<String>.from(doc['affectedAreas']),
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  Future<void> addPlantDiseases() async {
    final CollectionReference diseasesCollection =
        FirebaseFirestore.instance.collection('plantDiseases');

    List<Map<String, dynamic>> diseaseData = [
      {
        'diseaseName': 'Powdery Mildew',
        'description':
            'Powdery mildew is a fungal disease that affects a wide range of plants. It is characterized by white powdery spots on leaves and stems.',
        'prevention': [
          'Ensure good air circulation around plants',
          'Avoid overhead watering',
          'Plant resistant varieties'
        ],
        'treatment': [
          'Apply fungicidal sprays containing sulfur or potassium bicarbonate',
          'Remove and destroy infected plant parts',
          'Use neem oil or horticultural oils'
        ]
      },
      {
        'diseaseName': 'Downy Mildew',
        'description':
            'Downy mildew is a disease caused by water molds. It is characterized by yellowish or pale green spots on the upper surface of leaves and white, downy growth on the underside.',
        'prevention': [
          'Improve air circulation by proper spacing of plants',
          'Water plants early in the day to allow leaves to dry',
          'Remove plant debris from the garden'
        ],
        'treatment': [
          'Apply fungicides containing copper or mancozeb',
          'Remove and destroy infected plant parts',
          'Use resistant plant varieties'
        ]
      },
      {
        'diseaseName': 'Rust',
        'description':
            'Rust is a fungal disease that appears as orange, yellow, or brown pustules on leaves and stems. It can severely affect plant health and yield.',
        'prevention': [
          'Plant resistant varieties',
          'Avoid overhead watering',
          'Ensure proper plant spacing for air circulation'
        ],
        'treatment': [
          'Apply fungicides containing sulfur or copper',
          'Remove and destroy infected plant parts',
          'Use neem oil or other organic fungicides'
        ]
      }
    ];

    for (var disease in diseaseData) {
      await diseasesCollection.add(disease);
    }
  }
}
