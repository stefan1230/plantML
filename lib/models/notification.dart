class NotificationItem {
 final String id;
  final String title;
  final String description;
  final List<String> affectedAreas;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.affectedAreas,
    required this.createdAt,
  });

  //  factory NotificationItem.fromMap(Map<String, dynamic> data) {
  //   return NotificationItem(
  //     title: data['title'] ?? '',
  //     description: data['description'] ?? '',
  //     date: data['date'] ?? '',
  //     details: data['details'] ?? '',
  //   );
  // }
}