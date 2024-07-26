import 'package:flutter/material.dart';
import 'package:plantdiseaseidentifcationml/screens/alert_notification_screen.dart';

class DetailedNotificationScreen extends StatelessWidget {
  final NotificationItem notification;

  DetailedNotificationScreen({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(notification.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              notification.date,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              notification.description,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              notification.details,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
