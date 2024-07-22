import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plantdiseaseidentifcationml/screens/add_post_screen.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
import 'package:plantdiseaseidentifcationml/screens/post_detail_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<Post> posts = [
    Post(
      author: 'User1',
      title: 'First Post',
      description: 'This is the first post description.',
      imageUrl: 'https://via.placeholder.com/150',
      comments: ['Great post!', 'Thanks for sharing.'],
    ),
    Post(
      author: 'User2',
      title: 'Another Post',
      description: 'This is another post description.',
      imageUrl: 'https://via.placeholder.com/150',
      comments: ['Interesting!', 'Very helpful.'],
    ),
    Post(
      author: 'User2',
      title: 'Another Post 2',
      description: 'This is another post description.',
      imageUrl: 'https://via.placeholder.com/150',
      comments: ['Interesting!', 'Very helpful.'],
    ),
  ];

  final TextEditingController _postController = TextEditingController();
  bool _isFabVisible = true;

  void _addPost() {
    // if (_postController.text.isNotEmpty) {
    //   setState(() {
    //     posts.add(
    //       Post(
    //         author: 'NewUser',
    //         title: 'New Post',
    //         description: _postController.text,
    //         imageUrl: 'https://via.placeholder.com/150',
    //         comments: [],
    //       ),
    //     );
    //     _postController.clear();
    //   });
    // }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPostScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Community'),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse) {
            if (_isFabVisible) setState(() => _isFabVisible = false);
          } else if (notification.direction == ScrollDirection.forward) {
            if (!_isFabVisible) setState(() => _isFabVisible = true);
          }
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PostDetailScreen(post: posts[index]),
                          ),
                        );
                      },
                      child: PostCard(
                        imageUrl: posts[index].imageUrl,
                        userName: posts[index].author,
                        location: 'Sri Lanka', // You can modify this as needed
                        title: posts[index].title,
                        description: posts[index].description,
                        commentsCount: posts[index].comments.length,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _isFabVisible
          ? FloatingActionButton(
              onPressed: _addPost,
              child: Icon(Icons.edit),
            )
          : null,
    );
  }
}

class Post {
  final String author;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> comments;

  Post({
    required this.author,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.comments,
  });
}

class PostCard extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final String location;
  final String title;
  final String description;
  final int commentsCount;

  const PostCard({
    Key? key,
    required this.imageUrl,
    required this.userName,
    required this.location,
    required this.title,
    required this.description,
    required this.commentsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          imageUrl), // Placeholder for user profile image
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(location),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 5),
                Text(description),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Comments: $commentsCount'),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
