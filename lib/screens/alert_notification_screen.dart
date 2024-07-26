import 'package:flutter/material.dart';
import 'package:plantdiseaseidentifcationml/screens/alert_notification_detail_screen.dart';

class NotificationScreen extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Blight Outbreak Alert',
      description: 'A severe blight outbreak has been reported in your area. Take immediate action to protect your crops.',
      date: 'July 25, 2024',
      details: 'Detailed information about Blight Outbreak...',
    ),
    NotificationItem(
      title: 'Powdery Mildew Warning',
      description: 'Powdery mildew has been detected in nearby farms. Ensure your crops are not affected.',
      date: 'July 24, 2024',
      details: 'Detailed information about Powdery Mildew...',
    ),
    // Add more notifications as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Outbreak Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return InkWell(
            onTap: () =>{
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedNotificationScreen(notification: notifications[index],),
                      ),
                    )
            },
            child: Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(notification.title),
                subtitle: Text('${notification.description}\n${notification.date}'),
                isThreeLine: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedNotificationScreen(notification: notification),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final String date;
  final String details;

  NotificationItem({
    required this.title,
    required this.description,
    required this.date,
    required this.details,
  });
}
