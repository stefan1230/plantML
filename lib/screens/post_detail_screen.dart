import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
import 'package:plantdiseaseidentifcationml/screens/community_screen.dart';
import 'package:plantdiseaseidentifcationml/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

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
      backgroundColor: const Color(0xffffffff),
      appBar: CommonAppBar(
        title: '',
        leading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              // padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildImage(context, post),
                  _buildUserPost(post),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: buildCommentsList(post),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildInputField(context),
          ),
        ],
      ),
    );
  }

  Widget _buildUserPost(Post post) {
    String getTimeAgo(Timestamp timestamp) {
      final DateTime dateTime = timestamp.toDate();
      return timeago.format(dateTime);
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    AssetImage('assets/user24.jpg'), // Dummy user image
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.author,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(getTimeAgo(post.createdAt)),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            post.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(post.description),
        ],
      ),
    );
  }

  Widget buildImage(BuildContext context, Post post) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0.0),
        child: Image.network(
          post.imageUrl,
          width: MediaQuery.of(context).size.width, // Full width
          height: 250,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildCommentsList(Post post) {
    String getTimeAgo(Timestamp timestamp) {
      final DateTime dateTime = timestamp.toDate();
      return timeago.format(dateTime);
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Text('No comments yet');
        }
        List comments = snapshot.data!['comments'] ?? [];
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: comments.length,
          itemBuilder: (context, index) {
            var comment = comments[index];
            // var timestamp = (comment['timestamp'] as Timestamp?)?.toDate();
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(comment['user']['imageUrl'] ??
                    'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg'),
              ),
              title: Text(comment['text']),
              subtitle: Text(
                style: TextStyle(fontSize: 10),
                '${comment['user']['name']} - ${'Just now'}',
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Write your answer',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.send, color: Colors.green),
          onPressed: () {
            _addComment(context);
            if (_commentController.text.isNotEmpty) {
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ],
    );
  }
}
