import 'package:flutter/material.dart';
import 'package:plantdiseaseidentifcationml/services/firestore_service.dart';
import 'package:plantdiseaseidentifcationml/screens/alert_notification_detail_screen.dart';

import '../models/notification.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Outbreak Notifications'),
      ),
      body: StreamBuilder<List<NotificationItem>>(
        stream: _firestoreService.getAlerts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications available.'));
          }
          final notifications = snapshot.data!;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedNotificationScreen(notification: notification),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(notification.title),
                    subtitle: Text('${notification.description}\n${notification.createdAt}'),
                    isThreeLine: true,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}