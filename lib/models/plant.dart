// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class Plant {
//   final String id;
//   final String imageUrl;
//   final String diagnosis;
//   final String remedies;
//   final String prevention;
//   final List<String> progressImages;
//   final String userId; // Added userId field
//   final DateTime createdAt;

//   Plant(
//       {this.id = '', // Allow empty ID for new plants
//       required this.imageUrl,
//       required this.diagnosis,
//       required this.remedies,
//       required this.prevention,
//       required this.userId,
//       this.progressImages = const [],
//       required this.createdAt});

//   /// Convert a `Plant` object into a map suitable for storing in Firestore.
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'imageUrl': imageUrl,
//       'diagnosis': diagnosis,
//       'remedies': remedies,
//       'prevention': prevention,
//       'progressImages': progressImages,
//       'userId': userId,
//       'createdAt': createdAt
//     };
//   }

//   /// Factory method to create a `Plant` object from a Firestore map.
//   /// Includes debugging and error-handling for unexpected data types.
//   factory Plant.fromMap(Map<String, dynamic> map) {
//     print("Mapping data from Firestore: $map"); // Debugging input map

//     // Parse progressImages based on expected data structure.
//     List<String> parsedProgressImages;
//     if (map['progressImages'] != null) {
//       try {
//         // Check if progressImages is a list of strings or list of objects.
//         if (map['progressImages'] is List<dynamic>) {
//           parsedProgressImages = (map['progressImages'] as List<dynamic>)
//               .map((item) => item is String ? item : item['url'] as String)
//               .toList();
//         } else {
//           parsedProgressImages = [];
//         }
//       } catch (e) {
//         print("Error parsing progressImages: $e"); // Error debugging
//         parsedProgressImages = [];
//       }
//     } else {
//       parsedProgressImages = [];
//     }

//     // Create the `Plant` object from the parsed data.
//     return Plant(
//       id: map['id'] ?? '',
//       imageUrl: map['imageUrl'] ?? '',
//       diagnosis: map['diagnosis'] ?? '',
//       remedies: map['remedies'] ?? '',
//       prevention: map['prevention'] ?? '',
//       progressImages: parsedProgressImages,
//       userId: map['userId'] ?? '',
//       createdAt: FieldValue.serverTimestamp(),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Plant {
  final String id;
  final String imageUrl;
  final String diagnosis;
  final String remedies;
  final String prevention;
  final List<String> progressImages;
  final String userId;
  final Timestamp? createdAt; // Change to Timestamp

  Plant({
    this.id = '',
    required this.imageUrl,
    required this.diagnosis,
    required this.remedies,
    required this.prevention,
    required this.userId,
    this.progressImages = const [],
    this.createdAt,
  });

  /// Convert a `Plant` object into a map suitable for storing in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'diagnosis': diagnosis,
      'remedies': remedies,
      'prevention': prevention,
      'progressImages': progressImages,
      'userId': userId,
      'createdAt': createdAt ??
          FieldValue.serverTimestamp(), // Store the existing Timestamp directly
    };
  }

  /// Factory method to create a `Plant` object from a Firestore map.
  factory Plant.fromMap(Map<String, dynamic> map) {
    // Parse progressImages based on expected data structure.
    List<String> parsedProgressImages = [];
    if (map['progressImages'] != null) {
      try {
        parsedProgressImages = (map['progressImages'] as List<dynamic>)
            .map((item) => item is String ? item : item['url'] as String)
            .toList();
      } catch (e) {
        print("Error parsing progressImages: $e");
      }
    }

    return Plant(
      id: map['id'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      remedies: map['remedies'] ?? '',
      prevention: map['prevention'] ?? '',
      progressImages: parsedProgressImages,
      userId: map['userId'] ?? '',
      createdAt:
          map['createdAt'] ?? Timestamp.now(), // Use Timestamp.now() if missing
    );
  }
}
