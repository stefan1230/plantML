import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
import 'package:plantdiseaseidentifcationml/models/plant.dart';
import 'package:plantdiseaseidentifcationml/services/firestore_service.dart';

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;
  final TextEditingController _commentController = TextEditingController();

  PlantDetailScreen({required this.plant});

  void _addComment(BuildContext context) async {
    if (_commentController.text.isNotEmpty) {
      try {
        await FirestoreService().addComment(
          plant.id,
          _commentController.text,
          // user: 'Current User', // Replace with actual user data
        );
        _commentController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Comment added')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: plant.diagnosis),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(plant.imageUrl,
                width: double.infinity, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(
              plant.diagnosis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text('Remedies: ${plant.remedies}'),
            const SizedBox(height: 8),
            Text('Prevention: ${plant.prevention}'),
            const SizedBox(height: 16),
            Text(
              'Comments:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('plants')
                    .doc(plant.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return Text('No comments yet');
                  }

                  List comments = snapshot.data!['comments'] ?? [];

                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      var comment = comments[index];
                      var timestamp =
                          (comment['timestamp'] as Timestamp?)?.toDate();
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(comment['userImageUrl']),
                        ),
                        title: Text(comment['text']),
                        subtitle: Text(
                          '${comment['user']['name']} - ${timestamp != null ? timestamp.toString() : 'Just now'}',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Add a comment',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _addComment(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
