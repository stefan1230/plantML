import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      backgroundColor: const Color(0xffffffff),
      appBar: CommonAppBar(
        title: '',
        leading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildUserHeader(post),
                  const SizedBox(height: 8),
                  buildTitle(post),
                  buildImage(post),
                  const SizedBox(height: 8),
                  buildDescription(post),
                  const SizedBox(height: 16),
                  Text(
                    'Comments:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  buildCommentsList(post),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          //   child: TextField(
          //     controller: _commentController,
          //     decoration: InputDecoration(
          //       labelText: 'Add a comment',
          //       suffixIcon: IconButton(
          //         icon: const Icon(Icons.send),
          //         onPressed: () => _addComment(context),
          //       ),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(8.0),
          //       ),
          //     ),
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/comment 1.svg',
                  height: 32,
                  width: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      border: customBorder(Colors.grey),
                      enabledBorder: customBorder(Colors.grey),
                      focusedBorder: customBorder(Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 0),
                TextButton(
                  onPressed: () {
                    _addComment(context);
                    if (_commentController.text.isNotEmpty) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: const Text(
                    'Post',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildUserHeader(Post post) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 223, 222, 222),
          backgroundImage: AssetImage('assets/user23.png'), // Example image
          radius: 15,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.author,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              '12 mins ago',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTitle(Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Text(
        post.title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget buildImage(Post post) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.network(
          post.imageUrl,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildDescription(Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(post.description),
    );
  }

  Widget buildCommentsList(Post post) {
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
            var timestamp = (comment['timestamp'] as Timestamp?)?.toDate();
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(comment['user']['imageUrl'] ??
                    'https://via.placeholder.com/150'),
              ),
              title: Text(comment['text']),
              subtitle: Text(
                '${comment['user']['name']} - ${timestamp != null ? timestamp.toString() : 'Just now'}',
              ),
            );
          },
        );
      },
    );
  }
}

OutlineInputBorder customBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color, width: 0.5),
  );
}
