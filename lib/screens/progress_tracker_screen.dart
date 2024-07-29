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
    // _addSampleData();
  }

  Future<void> _addSampleData() async {
    await FirestoreService().addSampleData();
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JourneyScreen(plant: plant),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              plant.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      plant.diagnosis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '25 Jul', // Replace with dynamic date
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  plant.remedies,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  plant.prevention,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
