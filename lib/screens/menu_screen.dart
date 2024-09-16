// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
// import 'package:plantdiseaseidentifcationml/screens/login_screen.dart';
// import 'package:plantdiseaseidentifcationml/screens/update_profile_screen.dart';

// class MenuScreen extends StatefulWidget {
//   const MenuScreen({super.key});

//   @override
//   State<MenuScreen> createState() => _MenuScreenState();
// }

// class _MenuScreenState extends State<MenuScreen> {
//   Future<void> _logout(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     } catch (e) {
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Logout failed: ${e.toString()}')),
//       );
//     }
//   }

//   void _navigateToUpdateProfile(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const UpdateProfileScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CommonAppBar(title: 'More'),
//       body: Padding(
//         padding: EdgeInsets.all(8),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             ListTile(
//               leading: const Icon(Icons.person),
//               title: const Text('Update Profile'),
//               onTap: () => _navigateToUpdateProfile(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Sign Out'),
//               onTap: () => _logout(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
import 'package:plantdiseaseidentifcationml/screens/login_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/update_profile_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/alert_notification_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    }
  }

  void _navigateToUpdateProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UpdateProfileScreen()),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: CommonAppBar(title: 'More'),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Update Profile'),
              onTap: () => _navigateToUpdateProfile(context),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () => _navigateToNotifications(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}

// class NotificationScreen extends StatelessWidget {
//   final List<NotificationItem> notifications = [
//     NotificationItem(
//       title: 'Blight Outbreak Alert',
//       description: 'A severe blight outbreak has been reported in your area. Take immediate action to protect your crops.',
//       date: 'July 25, 2024',
//     ),
//     NotificationItem(
//       title: 'Powdery Mildew Warning',
//       description: 'Powdery mildew has been detected in nearby farms. Ensure your crops are not affected.',
//       date: 'July 24, 2024',
//     ),
//     // Add more notifications as needed
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Disease Outbreak Notifications'),
//       ),
//       body: ListView.builder(
//         itemCount: notifications.length,
//         itemBuilder: (context, index) {
//           final notification = notifications[index];
//           return Card(
//             margin: EdgeInsets.all(10),
//             child: ListTile(
//               title: Text(notification.title),
//               subtitle: Text('${notification.description}\n${notification.date}'),
//               isThreeLine: true,
//               onTap: () {
//                 // Navigate to detailed view if necessary
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class NotificationItem {
  final String title;
  final String description;
  final String date;

  NotificationItem({
    required this.title,
    required this.description,
    required this.date,
  });
}
