import 'package:flutter/material.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
import 'package:plantdiseaseidentifcationml/models/plant.dart';
import 'package:plantdiseaseidentifcationml/screens/plant_details_screen.dart';
import 'package:plantdiseaseidentifcationml/services/firestore_service.dart';

class ProgressTrackerScreen extends StatefulWidget {
  const ProgressTrackerScreen({super.key});

  @override
  State<ProgressTrackerScreen> createState() => _ProgressTrackerScreenState();
}

class _ProgressTrackerScreenState extends State<ProgressTrackerScreen> {
  @override
  void initState() {
    super.initState();
    // _addTestPlant();
  }

  Future<void> _addTestPlant() async {
    Plant testPlant = Plant(
      id: '1', // A unique ID for the plant
      imageUrl: 'https://via.placeholder.com/150',
      diagnosis: 'Test Diagnosis',
      remedies: 'Test Remedies',
      prevention: 'Test Prevention',
    );

    await FirestoreService().addPlant(testPlant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Progress Tracker'),
      body: StreamBuilder<List<Plant>>(
        stream: FirestoreService().getPlants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No plants diagnosed yet.'));
          }
          final plants = snapshot.data!;
          return ListView.builder(
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];
              return ListTile(
                leading: Image.network(plant.imageUrl, fit: BoxFit.cover),
                title: Text(plant.diagnosis),
                subtitle: Text('Remedies: ${plant.remedies}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantDetailScreen(plant: plant),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
