import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
import 'package:plantdiseaseidentifcationml/screens/add_post_screen.dart';
import 'package:plantdiseaseidentifcationml/screens/post_detail_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late Future<List<Post>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _futurePosts = fetchPostsFromFirestore();
  }

  Future<List<Post>> fetchPostsFromFirestore() async {
    final List<Post> posts = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true) // Order by timestamp
          .get();

      for (var doc in snapshot.docs) {
        posts.add(Post.fromFirestore(doc));
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: CommonAppBar(title: 'Community'),
      body: FutureBuilder<List<Post>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching posts'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Post post = snapshot.data![index];
              return CardWidget(
                imageUrl: post.imageUrl,
                userName: post.author,
                title: post.title,
                description: post.description,
                commentsCount: post.comments.length,
                post: post,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddPostScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPostScreen(),
            ),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final String title;
  final String description;
  final int commentsCount;
  final Post post;

  const CardWidget({
    super.key,
    required this.imageUrl,
    required this.userName,
    required this.title,
    required this.description,
    required this.commentsCount,
    required this.post,
  });

  String getShortDescription(String description, int wordLimit) {
    List<String> words = description.split(" ");
    if (words.length <= wordLimit) return description;
    return words.take(wordLimit).join(" ") + '...';
  }

  String getTimeAgo(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return timeago
        .format(dateTime); // Formats to 'x mins ago', 'x hours ago', etc.
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xffEBEBEB), width: 0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 223, 222, 222),
                      backgroundImage: AssetImage('assets/user24.jpg'),
                      radius: 15,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          getTimeAgo(post.createdAt),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(post: post),
                          ),
                        );
                      },
                      child: Text('View'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  getShortDescription(description, 20), // limit to 20 words
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.comment,
                      color: Colors.black,
                      size: 14,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '$commentsCount Comments',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Post {
  final String id;
  final String author;
  final String title;
  final String description;
  final String imageUrl;
  final List comments;
  final Timestamp createdAt; // Add createdAt field

  Post({
    required this.id,
    required this.author,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.comments,
    required this.createdAt, // Initialize createdAt
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      author: data['author'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      comments: data['comments'] ?? [],
      createdAt:
          data['createdAt'] ?? Timestamp.now(), // Default to now if missing
    );
  }
}
