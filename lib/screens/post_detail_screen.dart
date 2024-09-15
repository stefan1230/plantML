import 'package:flutter/material.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
import 'package:plantdiseaseidentifcationml/screens/community_screen.dart';
import 'package:plantdiseaseidentifcationml/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;
  final TextEditingController _commentController = TextEditingController();

  PostDetailScreen({required this.post});

  void _addComment(BuildContext context) async {
    if (_commentController.text.isNotEmpty) {
      try {
        await FirestoreService().addComment(post.id, _commentController.text);
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
      appBar: CommonAppBar(
        title: post.title,
        leading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(12.0), // Adjust the radius as needed
              child: Image.network(
                post.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(post.description),
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
                    .collection('posts')
                    .doc(post.id)
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
                          backgroundImage: NetworkImage(comment['user']
                                  ['imageUrl'] ??
                              'https://via.placeholder.com/150'), // Replace with default image if necessary
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
