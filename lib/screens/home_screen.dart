import 'package:flutter/material.dart';
import 'package:plantdiseaseidentifcationml/app_color.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Home'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            // const Card(
            // color: Colors.white,
            // surfaceTintColor: Colors.white,
            // elevation: 0.3,

            ListTile(
              title: Text(
                'Welcome back!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Ready to take care of your plants?'),
            ),
            // ),

            // Quick Access Buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to scan screen
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      label: const Text('Scan Plant',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.MainGreen,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to my plants screen
                      },
                      icon: const Icon(
                        Icons.local_florist,
                        color: Colors.white,
                      ),
                      label: const Text('My Plants',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.MainGreen,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to community forum
                      },
                      icon: const Icon(
                        Icons.forum,
                        color: Colors.white,
                      ),
                      label: const Text('Community',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.MainGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 0),

            // Latest News/Updates
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 0.3,
                child: ListTile(
                  title: Text('Latest Disease Alerts'),
                  subtitle: Text('Blight outbreak reported in your area.'),
                  trailing: Icon(Icons.warning, color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 5),

            // Recent Activity
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Activity',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text('Tomato Blight Detected'),
                    subtitle: Text('2 days ago'),
                  ),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text('New post in Community Forum'),
                    subtitle: Text('1 day ago'),
                  ),
                ],
              ),
            ),

            // Weather Information
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 0.3,
                child: ListTile(
                  leading: Icon(Icons.wb_sunny),
                  title: Text('Current Weather'),
                  subtitle: Text('Sunny, 25°C'),
                ),
              ),
            ),

            // Tips and Tricks
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 0.3,
                child: ListTile(
                  title: Text('Plant Care Tips'),
                  subtitle: Text(
                      'Ensure good air circulation around plants to prevent fungal diseases.'),
                ),
              ),
            ),
            // const SizedBox(height: 5),

            const SizedBox(height: 15),

            // Statistics and Achievements
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Stats',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    leading: Icon(Icons.assessment),
                    title: Text('Plants Scanned'),
                    subtitle: Text('15 plants'),
                  ),
                ],
              ),
            ),
            // const ListTile(
            //   leading: Icon(Icons.stars),
            //   title: Text('Achievements'),
            //   subtitle: Text('5 badges earned'),
            // ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
