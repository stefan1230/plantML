import 'package:flutter/material.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
import 'package:plantdiseaseidentifcationml/models/notification.dart';

class DetailedNotificationScreen extends StatelessWidget {
  final NotificationItem notification;

  DetailedNotificationScreen({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: CommonAppBar(
        title: notification.title,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '${notification.createdAt.toLocal()}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              notification.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Affected Areas: ${notification.affectedAreas.join(', ')}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
