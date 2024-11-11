import 'package:flutter/material.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
import 'package:plantdiseaseidentifcationml/services/firestore_service.dart';

class DiagnosisScreen extends StatefulWidget {
  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  @override
  void initState() {
    super.initState();
    _addSampleData();
  }

  Future<void> _addSampleData() async {
    await FirestoreService().addSampleNotifications();
  }

  final Map<String, dynamic> plantData = {
    "name": "Pepper Bell - Bacterial Spot",
    "type": "Bacterial Disease",
    "description":
        "A bacterial disease affecting peppers, causing small, water-soaked spots on leaves and fruits.",
    "symptoms": [
      "Small, water-soaked spots on leaves and fruits.",
      "Spots enlarge to dark brown lesions with yellow halos.",
      "Severe infections cause leaves to drop, exposing fruits to sunscald."
    ],
    "prevention": [
      "Use disease-free seeds.",
      "Practice crop rotation.",
      "Avoid overhead watering to reduce leaf wetness."
    ],
    "remedies": [
      "Remove and destroy infected plants.",
      "Apply copper-based bactericides as a preventive measure.",
      "Avoid working in the garden when plants are wet to prevent spreading."
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Diagnosis'),
      // ),
      appBar: const CommonAppBar(title: 'Diagnosis', leading: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section (Placeholder for now)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://via.placeholder.com/300.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Plant Name and Type
              Text(
                plantData["name"],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                plantData["type"],
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),

              // Health Alert Section
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
                          SizedBox(height: 4),
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

              // Description Section
              const Text(
                "About",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                plantData["description"],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Symptoms Section
              Row(
                children: const [
                  Icon(Icons.bug_report, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    "Symptoms",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...plantData["symptoms"].map<Widget>((symptom) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.black54),
                      const SizedBox(width: 8),
                      Expanded(
                        child:
                            Text(symptom, style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),

              // Prevention Section
              Row(
                children: const [
                  Icon(Icons.shield, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    "Prevention",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...plantData["prevention"].map<Widget>((prevention) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.black54),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(prevention,
                            style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),

              // Remedies Section
              Row(
                children: const [
                  Icon(Icons.medical_services, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    "Remedies",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...plantData["remedies"].map<Widget>((remedy) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.black54),
                      const SizedBox(width: 8),
                      Expanded(
                        child:
                            Text(remedy, style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),

              // FAQ Section (if needed for extra content)
              Row(
                children: const [
                  Icon(Icons.help_outline, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    "FAQ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Add FAQ content here if needed...
            ],
          ),
        ),
      ),
    );
  }
}
