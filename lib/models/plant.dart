class Plant {
  final String id;
  final String imageUrl;
  final String diagnosis;
  final String remedies;
  final String prevention;
  final List<String> progressImages;
  final String userId; // Added userId field

  // Plant({
  //   required this.id,
  //   required this.imageUrl,
  //   required this.diagnosis,
  //   required this.remedies,
  //   required this.prevention,
  //   this.progressImages = const [],
  //   required this.userId, // Added userId parameter
  // });

  Plant({
    this.id = '', // Allow empty ID for new plants
    required this.imageUrl,
    required this.diagnosis,
    required this.remedies,
    required this.prevention,
    required this.userId,
    this.progressImages = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'diagnosis': diagnosis,
      'remedies': remedies,
      'prevention': prevention,
      'progressImages': progressImages,
      'userId': userId, // Added userId to map
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      remedies: map['remedies'] ?? '',
      prevention: map['prevention'] ?? '',
      progressImages: List<String>.from(map['progressImages'] ?? []),
      userId: map['userId'] ?? '', // Added userId from map
    );
  }
}
