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

  Future<void> addPost(String author, String title, String description,
      String imagePath, String userId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      File file = File(imagePath);
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      TaskSnapshot snapshot =
          await _storage.ref().child('post_images/$fileName').putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await _db.collection('posts').add({
        'author': user!.displayName,
        'userId': userId, // Store the user ID
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

  Future<String> addPlant(Plant plant) async {
    DocumentReference docRef = await plantsCollection.add(plant.toMap());
    String plantId = docRef.id;

    // Update the document with its own ID
    await docRef.update({'id': plantId});

    return plantId;
  }

  Stream<List<Plant>> getPlants() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser);
    if (currentUser == null) {
      // If no user is logged in, return an empty stream
      return Stream.value([]);
    }

    return plantsCollection
        .where('userId', isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        print(doc.data());
        return Plant.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addProgressImage(
      String plantId, File image, String note, double healthMeter) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in");
    }

    DocumentSnapshot plantDoc = await plantsCollection.doc(plantId).get();
    if (!plantDoc.exists) {
      throw Exception("Plant document not found");
    }

    String fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${user.uid}.jpg';
    String storagePath = 'plants/$plantId/$fileName';

    try {
      // Upload the image to Firebase Storage
      TaskSnapshot snapshot = await _storage.ref(storagePath).putFile(image);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Prepare the data to be stored in Firestore
      Map<String, dynamic> imageData = {
        'url': downloadUrl,
        'date': DateTime.now(), // Store the timestamp
        'note': note,
        'healthMeter': healthMeter,
      };

      // Update the Firestore document with the new progress data
      await plantsCollection.doc(plantId).update({
        'progressImages': FieldValue.arrayUnion([imageData]),
      });

      print("Progress image added successfully: $downloadUrl");
    } catch (e) {
      print("Error adding progress image: $e");
      throw e;
    }
  }

  // Future<void> addSampleData() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     throw Exception("No user logged in");
  //   }

  //   List<Plant> samplePlants = [
  //     Plant(
  //       imageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/plantdiseaseapp-6f285.appspot.com/o/plants%2F1%2F1721927087286_J5nIWV2WYDSgPJEGIRlwU138ttp2.jpg?alt=media&token=68949b68-9466-44df-996c-d70ed745b6d2',
  //       diagnosis: 'Chilli Corcospora Leaf Spot',
  //       remedies: 'Complete',
  //       prevention: 'Test Prevention',
  //       userId: user.uid, // Add the current user's ID
  //     ),
  //     Plant(
  //       imageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/plantdiseaseapp-6f285.appspot.com/o/plants%2F1%2F1721927087286_J5nIWV2WYDSgPJEGIRlwU138ttp2.jpg?alt=media&token=68949b68-9466-44df-996c-d70ed745b6d2',
  //       diagnosis: 'Tomato Blight',
  //       remedies: 'Complete',
  //       prevention: 'Test Prevention',
  //       userId: user.uid, // Add the current user's ID
  //     ),
  //   ];

  //   for (Plant plant in samplePlants) {
  //     // Create a new map with all plant data and the user ID
  //     Map<String, dynamic> plantData = plant.toMap();
  //     plantData['userId'] = user.uid;

  //     DocumentReference plantRef = await plantsCollection.add(plantData);

  //     // Add sample progress images
  //     List<String> progressImages = [
  //       'https://via.placeholder.com/150/1',
  //       'https://via.placeholder.com/150/2',
  //       'https://via.placeholder.com/150/3',
  //     ];

  //     for (String imageUrl in progressImages) {
  //       await plantRef.update({
  //         'progressImages': FieldValue.arrayUnion([imageUrl]),
  //       });
  //     }
  //   }
  // }'

  Future<String> uploadImage(File image) async {
    try {
      String fileName =
          'plant_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      TaskSnapshot snapshot = await _storage.ref(fileName).putFile(image);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    } catch (e) {
      throw Exception("Image upload failed: $e");
    }
  }

  Future<void> addSampleData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in");
    }

    List<Plant> samplePlants = [
      Plant(
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/plantdiseaseapp-6f285.appspot.com/o/plants%2F1%2F1721927087286_J5nIWV2WYDSgPJEGIRlwU138ttp2.jpg?alt=media&token=68949b68-9466-44df-996c-d70ed745b6d2',
        diagnosis: 'Chilli Corcospora Leaf Spot',
        remedies: 'Complete',
        prevention: 'Test Prevention',
        userId: user.uid,
        // progressImages: [
        //   'https://via.placeholder.com/150/1',
        //   'https://via.placeholder.com/150/2',
        //   'https://via.placeholder.com/150/3',
        // ],
      ),
      Plant(
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/plantdiseaseapp-6f285.appspot.com/o/plants%2F1%2F1721927087286_J5nIWV2WYDSgPJEGIRlwU138ttp2.jpg?alt=media&token=68949b68-9466-44df-996c-d70ed745b6d2',
        diagnosis: 'Tomato Blight',
        remedies: 'Complete',
        prevention: 'Test Prevention',
        userId: user.uid,
        // progressImages: [
        //   'https://via.placeholder.com/150/4',
        //   'https://via.placeholder.com/150/5',
        //   'https://via.placeholder.com/150/6',
        // ],
      ),
    ];

    for (Plant plant in samplePlants) {
      String plantId = await addPlant(plant);
      print("Added sample plant with ID: $plantId");
    }
  }

  Future<void> addSampleNotifications() async {
    final CollectionReference alertsCollection =
        _db.collection('diseaseAlerts');
    List<Map<String, dynamic>> sampleAlerts = [
      {
        'title': 'Powdery Mildew Outbreak 2',
        'description':
            'There is an outbreak of Powdery Mildew in the following areas...',
        'affectedAreas': ['Area1', 'Area2'],
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Blight Outbreak Alert 3',
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
