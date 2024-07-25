class Plant {
  final String id;
  final String imageUrl;
  final String diagnosis;
  final String remedies;
  final String prevention;
  final List<String> progressImages;

  Plant({
    required this.id,
    required this.imageUrl,
    required this.diagnosis,
    required this.remedies,
    required this.prevention,
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
    );
  }
}
