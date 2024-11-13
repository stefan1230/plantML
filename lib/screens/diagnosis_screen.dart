import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
import 'package:plantdiseaseidentifcationml/models/plant.dart';
import 'package:plantdiseaseidentifcationml/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiagnosisScreen extends StatelessWidget {
  final Map<String, dynamic> plantData;
  final File? imageFile;
  final bool fromModelDetection;
  final String? imageURL;

  const DiagnosisScreen({
    Key? key,
    required this.plantData,
    this.imageFile,
    this.fromModelDetection = false,
    this.imageURL,
  }) : super(key: key);

  Future<void> _addPlant(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      // Get the current user ID
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Upload the image to Firebase Storage and get the download URL
      final String imageUrl = await FirestoreService().uploadImage(imageFile!);

      // Create the plant object
      Plant newPlant = Plant(
        imageUrl: imageUrl,
        diagnosis: plantData['displayName'] ?? '',
        remedies: (plantData['remedies'] as List<dynamic>).join(", "),
        prevention: (plantData['prevention'] as List<dynamic>).join(", "),
        userId: userId,
      );

      // Close loading dialog
      Navigator.of(context).pop();

      // Add the plant to Firestore
      await FirestoreService().addPlant(newPlant);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Plant added successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add plant: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String diseaseName = (plantData["name"] ?? "").toString().trim();
    bool isHealthy = diseaseName.toLowerCase() == "healthy";
    return Scaffold(
      appBar: const CommonAppBar(title: 'Diagnosis', leading: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageFile != null
                    ? Image.file(
                        imageFile!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        imageURL ?? 'https://via.placeholder.com/300.png',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 16),

              // Display plant diagnosis information
              Text(
                plantData["displayName"],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Health alert section (conditionally shown if not healthy)
              if (plantData["name"] != "Tomato_healthy")
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Your plant may not be healthy!",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Check regularly to see if your plant is healthy!",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              // Description
              const Text("About",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(plantData["description"],
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),

              // Symptoms, Prevention, Remedies
              _buildSection("Symptoms", plantData["symptoms"]),
              const SizedBox(height: 16),
              _buildSection("Prevention", plantData["prevention"]),
              const SizedBox(height: 16),
              _buildSection("Remedies", plantData["remedies"]),
              const SizedBox(height: 16),

              // Add Plant Button (only shown if fromModelDetection is true)
              // if (fromModelDetection)
              //   Center(
              //     child: ElevatedButton.icon(
              //       icon: const Icon(Icons.add),
              //       label: const Text("Add Plant"),
              //       onPressed: () => _addPlant(context),
              //       style: ElevatedButton.styleFrom(
              //         foregroundColor: Colors.white,
              //         backgroundColor: Colors.green,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
      // Sticky "Add Plant" button at the bottom when applicable
      bottomNavigationBar: fromModelDetection && !isHealthy
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Plant"),
                onPressed: () {
                  // Handle Add Plant functionality here
                  _addPlant(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50), // Make it full-width
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.black54),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(item, style: const TextStyle(fontSize: 16))),
                ],
              ),
            )),
      ],
    );
  }
}
