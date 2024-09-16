import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plantdiseaseidentifcationml/app_color.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
import 'package:plantdiseaseidentifcationml/screens/community_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      // appBar: const CommonAppBar(title: ''),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            // const Card(
            // color: Colors.white,
            // surfaceTintColor: Colors.white,
            // elevation: 0.3,
            const SizedBox(
              height: 50,
            ),
            const ListTile(
              title: Text(
                'Welcome back! 👋 ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Ready to take care of your plants?',
                  style: TextStyle(
                    fontSize: 12,
                  )),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: const Color(0xffFBF1E7),
                surfaceTintColor: Colors.white,
                elevation: 0,
                child: ListTile(
                  title: const Text(
                    'Latest Disease Alerts',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Blight outbreak reported in your area.',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(8.0), // Space around the icon
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),

            // const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                color: const Color(0xffE0F8E0), // Light green background
                elevation: 0.3,
                child: ListTile(
                  title: const Text(
                    'Plant Care Tips',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Ensure good air circulation around plants to prevent fungal diseases.',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: SvgPicture.asset(
                    'assets/plant_pot.svg', // Path to your SVG image in the assets folder
                    width: 40, // Set the width of the SVG image
                    height: 40, // Set the height of the SVG image
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),

            // Recent Activity
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Activity',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text('Tomato Blight Detected',
                        style: TextStyle(fontSize: 14)),
                    subtitle:
                        Text('2 days ago', style: TextStyle(fontSize: 12)),
                  ),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text('New post in Community Forum',
                        style: TextStyle(fontSize: 14)),
                    subtitle: Text('1 day ago', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),

            // Weather Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xffFFE9A5).withOpacity(0.3),
                      const Color(0xffFFD700).withOpacity(0.3)
                    ], // Define gradient colors here
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(
                      10.0)), // To give the same rounded corners as a card
                ),
                child: Card(
                  color: Colors
                      .transparent, // Make the card's background transparent to show the gradient
                  elevation: 0,
                  child: ListTile(
                    title: const Text('Current Weather',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Sunny, 25°C',
                        style: TextStyle(fontSize: 12)),
                    trailing: Container(
                      padding:
                          const EdgeInsets.all(8.0), // Space around the icon
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: const Icon(
                        Icons.wb_sunny,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Tips and Tricks

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
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ListTile(
                    leading: Icon(Icons.assessment),
                    title:
                        Text('Plants Scanned', style: TextStyle(fontSize: 14)),
                    subtitle: Text('15 plants', style: TextStyle(fontSize: 12)),
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
