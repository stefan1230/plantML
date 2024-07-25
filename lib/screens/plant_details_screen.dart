// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:plantdiseaseidentifcationml/commonComponents/common_appbar.dart';
// import 'package:plantdiseaseidentifcationml/models/plant.dart';
// import 'package:plantdiseaseidentifcationml/services/firestore_service.dart';

// class PlantDetailScreen extends StatelessWidget {
//   final Plant plant;
//   final TextEditingController _commentController = TextEditingController();

//   PlantDetailScreen({required this.plant});

//   void _addComment(BuildContext context) async {
//     if (_commentController.text.isNotEmpty) {
//       try {
//         await FirestoreService().addComment(
//           plant.id,
//           _commentController.text,
//           // user: 'Current User', // Replace with actual user data
//         );
//         _commentController.clear();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Comment added')),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to add comment: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CommonAppBar(title: plant.diagnosis),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(plant.imageUrl,
//                 width: double.infinity, height: 200, fit: BoxFit.cover),
//             const SizedBox(height: 8),
//             Text(
//               plant.diagnosis,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text('Remedies: ${plant.remedies}'),
//             const SizedBox(height: 8),
//             Text('Prevention: ${plant.prevention}'),
//             const SizedBox(height: 16),
//             Text(
//               'Comments:',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             Expanded(
//               child: StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('plants')
//                     .doc(plant.id)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }

//                   if (!snapshot.hasData) {
//                     return Text('No comments yet');
//                   }

//                   List comments = snapshot.data!['comments'] ?? [];

//                   return ListView.builder(
//                     itemCount: comments.length,
//                     itemBuilder: (context, index) {
//                       var comment = comments[index];
//                       var timestamp =
//                           (comment['timestamp'] as Timestamp?)?.toDate();
//                       return ListTile(
//                         leading: CircleAvatar(
//                           backgroundImage:
//                               NetworkImage(comment['userImageUrl']),
//                         ),
//                         title: Text(comment['text']),
//                         subtitle: Text(
//                           '${comment['user']['name']} - ${timestamp != null ? timestamp.toString() : 'Just now'}',
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             TextField(
//               controller: _commentController,
//               decoration: InputDecoration(
//                 labelText: 'Add a comment',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () => _addComment(context),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timeline_tile/timeline_tile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JourneyScreen(),
    );
  }
}

class JourneyScreen extends StatefulWidget {
  @override
  _JourneyScreenState createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  late ScrollController _scrollController;
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isFabVisible) setState(() => _isFabVisible = false);
    }
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isFabVisible) setState(() => _isFabVisible = true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journey'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
        child: ListView(
          controller: _scrollController,
          children: [
            JourneyTile(
              title: 'Moraine Lake',
              date: 'Tuesday 20',
              description: 'One of the many wonderful turquoise lakes in Alberta.',
              imageUrl: 'https://example.com/moraine_lake.jpg',
              isFirst: true,
            ),
            JourneyTile(
              title: 'Moraine Lake',
              date: 'Tuesday 16',
              description: 'One of the many wonderful turquoise lakes in Alberta.',
              imageUrl: 'https://example.com/moraine_lake.jpg',
            ),
            JourneyTile(
              title: 'Niagara Falls',
              date: 'Wednesday 17',
              description: 'Probably the most popular natural landmark in Canada that everyone...',
              imageUrl: 'https://example.com/niagara_falls.jpg',
            ),
            JourneyTile(
              title: 'Baffin Island',
              date: 'Thursday 18',
              description: 'Canada\'s largest island (5th in the world) is located in Nunavut.',
              imageUrl: 'https://example.com/baffin_island.jpg',
              isLast: false,
            ),
            JourneyTile(
              title: 'Banff National Park',
              date: 'Friday 19',
              description: 'Known for its stunning mountain landscapes and diverse wildlife.',
              imageUrl: 'https://example.com/banff_national_park.jpg',
            ),
            JourneyTile(
              title: 'Lake Louise',
              date: 'Saturday 20',
              description: 'A glacial lake known for its crystal clear turquoise waters.',
              imageUrl: 'https://example.com/lake_louise.jpg',
            ),
            JourneyTile(
              title: 'Prince Edward Island',
              date: 'Sunday 21',
              description: 'Famous for its red sand beaches and the Anne of Green Gables house.',
              imageUrl: 'https://example.com/prince_edward_island.jpg',
              isLast: true,
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _isFabVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: _isFabVisible
            ? FloatingActionButton.extended(
                onPressed: () {
                  // Add progress action
                },
                icon: Icon(Icons.add),
                label: Text('Add Progress'),
                tooltip: 'Add Progress',
              )
            : null,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(9.0),
        child: ElevatedButton(
          onPressed: () {
            // Confirm journey action
          },
          child: Text('Confirm Journey'),
        ),
      ),
    );
  }
}

class JourneyTile extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String imageUrl;
  final bool isFirst;
  final bool isLast;

  JourneyTile({
    required this.title,
    required this.date,
    required this.description,
    required this.imageUrl,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.1,
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: Colors.grey,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: Colors.grey,
        thickness: 2,
      ),
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: Colors.blue,
        padding: const EdgeInsets.all(6),
      ),
      endChild: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(imageUrl),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      startChild: Container(
        width: 50,
        child: Center(
          child: Text(
            date.split(' ')[1],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
