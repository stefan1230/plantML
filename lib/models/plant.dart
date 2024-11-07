import 'package:flutter/material.dart';

class Plant {
  final String id;
  final String imageUrl;
  final String diagnosis;
  final String remedies;
  final String prevention;
  final List<String> progressImages;
  final String userId; // Added userId field

  Plant({
    this.id = '', // Allow empty ID for new plants
    required this.imageUrl,
    required this.diagnosis,
    required this.remedies,
    required this.prevention,
    required this.userId,
    this.progressImages = const [],
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
    };
  }

  /// Factory method to create a `Plant` object from a Firestore map.
  /// Includes debugging and error-handling for unexpected data types.
  factory Plant.fromMap(Map<String, dynamic> map) {
    print("Mapping data from Firestore: $map"); // Debugging input map

    // Parse progressImages based on expected data structure.
    List<String> parsedProgressImages;
    if (map['progressImages'] != null) {
      try {
        // Check if progressImages is a list of strings or list of objects.
        if (map['progressImages'] is List<dynamic>) {
          parsedProgressImages = (map['progressImages'] as List<dynamic>)
              .map((item) => item is String ? item : item['url'] as String)
              .toList();
        } else {
          parsedProgressImages = [];
        }
      } catch (e) {
        print("Error parsing progressImages: $e"); // Error debugging
        parsedProgressImages = [];
      }
    } else {
      parsedProgressImages = [];
    }

    // Create the `Plant` object from the parsed data.
    return Plant(
      id: map['id'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      remedies: map['remedies'] ?? '',
      prevention: map['prevention'] ?? '',
      progressImages: parsedProgressImages,
      userId: map['userId'] ?? '',
    );
  }
}
