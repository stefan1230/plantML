import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plantdiseaseidentifcationml/screens/add_post_screen.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
import 'package:plantdiseaseidentifcationml/screens/post_detail_screen.dart';
// import 'package:plantdiseaseidentifcationml/models/post.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  bool _isFabVisible = true;
  late Future<List<Post>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _futurePosts = fetchPostsFromFirestore();
  }

  Future<List<Post>> fetchPostsFromFirestore() async {
    final List<Post> posts = [];
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('posts').get();
      snapshot.docs.forEach((doc) {
        posts.add(Post.fromFirestore(doc));
      });
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
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse) {
            if (_isFabVisible) setState(() => _isFabVisible = false);
          } else if (notification.direction == ScrollDirection.forward) {
            if (!_isFabVisible) setState(() => _isFabVisible = true);
          }
          return true;
        },
        child: FutureBuilder<List<Post>>(
          future: _futurePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching posts'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No posts available'));
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Post post = snapshot.data![index];
                  return CardWidget(
                    imageUrl: post.imageUrl,
                    userName: post.author,
                    location: 'Sri Lanka', // You can modify this as needed
                    title: post.title,
                    description: post.description,
                    commentsCount: post.comments.length,
                    post: post,
                  );
                  // return GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => PostDetailScreen(post: post),
                  //       ),
                  //     );
                  //   },
                  //   child: PostCard(
                  //     imageUrl: post.imageUrl,
                  //     userName: post.author,
                  //     location: 'Sri Lanka', // You can modify this as needed
                  //     title: post.title,
                  //     description: post.description,
                  //     commentsCount: post.comments.length,
                  //   ),
                  // );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: _isFabVisible
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPostScreen(),
                  ),
                );
              },
              child: Icon(Icons.edit),
            )
          : null,
    );
  }
}

class CardWidget extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final String location;
  final String title;
  final String description;
  final int commentsCount;
  final Post post;

  const CardWidget(
      {super.key,
      required this.imageUrl,
      required this.userName,
      required this.location,
      required this.title,
      required this.description,
      required this.commentsCount,
      required this.post});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color(0xffffffff),
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xffEBEBEB), width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Replace with your plant image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 223, 222, 222),
                        backgroundImage: AssetImage('assets/user23.png'),
                        radius: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('12 mins ago',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              )),
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () => (Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostDetailScreen(post: post),
                                ),
                              )),
                          child: Text('View'))
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => (),
                    icon: const Icon(Icons.comment, color: Colors.black),
                    label: const Text(
                      'Comment',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            // OverflowBar(
            //   alignment: MainAxisAlignment.start,
            //   children: [
            //     // TextButton(
            //     //   onPressed: () {
            //     //     // Handle Save
            //     //   },
            //     //   child: Text('Save'),
            //     // ),
            //     TextButton(
            //       onPressed: () {
            //         // Handle Comment
            //       },
            //       child: Row(
            //         children: [
            //           SvgPicture.asset(
            //             'assets/scanner.svg',
            //             color: Colors.white,
            //             height: 40,
            //           ),
            //           Text('Comment'),
            //         ],
            //       ),
            //     ),
            //     // TextButton(
            //     //   onPressed: () {
            //     //     // Handle Share
            //     //   },
            //     //   child: Text('Share'),
            //     // ),
            //   ],
            // ),
          ],
        ),
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

  Post({
    required this.id,
    required this.author,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.comments,
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
    );
  }
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
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0.3,
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
