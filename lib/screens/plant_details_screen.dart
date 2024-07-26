import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:plantdiseaseidentifcationml/models/plant.dart';
import 'package:plantdiseaseidentifcationml/screens/diagnosis_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class JourneyScreen extends StatefulWidget {
  final Plant plant;

  JourneyScreen({required this.plant});

  @override
  _JourneyScreenState createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  late ScrollController _scrollController;
  bool _isFabVisible = true;
  File? _image;

  final List<Map<String, String>> progressImages = [
    {
      'imageUrl': 'https://via.placeholder.com/150',
      'date': '2023-01-01',
      'description': 'Image 1 description'
    },
    {
      'imageUrl': 'https://via.placeholder.com/150',
      'date': '2023-01-02',
      'description': 'Image 2 description'
    },
    {
      'imageUrl': 'https://via.placeholder.com/150',
      'date': '2023-01-03',
      'description': 'Image 3 description'
    },
  ];

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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadProgressImage() async {
    // Here you can handle the image upload
    if (_image != null) {
      setState(() {
        progressImages.add({
          'imageUrl': _image!.path,
          'date': DateTime.now().toIso8601String(),
          'description': 'Newly added image'
        });
        _image = null;
      });
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
        child: Column(
          children: [
            DiagnosisCard(plant: widget.plant),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: progressImages.length,
                itemBuilder: (context, index) {
                  if (index >= progressImages.length) {
                    return SizedBox.shrink(); // Return an empty widget if index is out of range
                  }
                  String imageUrl = progressImages[index]['imageUrl']!;
                  String date = progressImages[index]['date']!;
                  String description = progressImages[index]['description']!;
                  return JourneyTile(
                    title: 'Progress Image',
                    date: date,
                    description: description,
                    imageUrl: imageUrl,
                    isFirst: index == 0,
                    isLast: index == progressImages.length - 1,
                  );
                },
              ),
            ),
            if (_image != null)
              Column(
                children: [
                  Image.file(_image!, height: 200),
                  ElevatedButton(
                    onPressed: _uploadProgressImage,
                    child: Text('Upload Progress Image'),
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _isFabVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: _isFabVisible
            ? FloatingActionButton.extended(
                onPressed: _pickImage,
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

class DiagnosisCard extends StatelessWidget {
  final Plant plant;

  DiagnosisCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DiagnosisScreen()),
        )
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  plant.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.diagnosis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Remedies: ${plant.remedies}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Prevention: ${plant.prevention}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
            '20',
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


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:plantdiseaseidentifcationml/screens/diagnosis_screen.dart';
// import 'package:timeline_tile/timeline_tile.dart';
// import 'package:plantdiseaseidentifcationml/models/plant.dart';
// import 'package:plantdiseaseidentifcationml/services/firestore_service.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class JourneyScreen extends StatefulWidget {
//   final Plant plant;

//   JourneyScreen({required this.plant});

//   @override
//   _JourneyScreenState createState() => _JourneyScreenState();
// }

// class _JourneyScreenState extends State<JourneyScreen> {
//   late ScrollController _scrollController;
//   bool _isFabVisible = true;
//   File? _image;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollController.addListener(_scrollListener);
//   }

//   void _scrollListener() {
//     if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
//       if (_isFabVisible) setState(() => _isFabVisible = false);
//     }
//     if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
//       if (!_isFabVisible) setState(() => _isFabVisible = true);
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       }
//     });
//   }

//   Future<void> _uploadProgressImage() async {
//     if (_image != null) {
//       await FirestoreService().addProgressImage(widget.plant.id, _image!);
//       setState(() {
//         _image = null;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollListener);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Journey'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
//         child: Column(
//           children: [
//             DiagnosisCard(plant: widget.plant),
//             Expanded(
//               child: StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance.collection('plants').doc(widget.plant.id).snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || !snapshot.data!.exists) {
//                     return Center(child: Text('No progress images yet.'));
//                   }
//                   List progressImages = snapshot.data!['progressImages'] ?? [];
//                   if (progressImages.isEmpty) {
//                     // Sample hardcoded data
//                     progressImages = [
//                       'https://via.placeholder.com/150',
//                       'https://via.placeholder.com/150',
//                       'https://via.placeholder.com/150',
//                     ];
//                   }
//                   return ListView.builder(
//                     controller: _scrollController,
//                     itemCount: progressImages.length,
//                     itemBuilder: (context, index) {
//                       String imageUrl = progressImages[index];
//                       return JourneyTile(
//                         title: 'Progress Image',
//                         date: 'Sample Date', // Replace with the actual date if available
//                         description: 'Image ${index + 1}',
//                         imageUrl: imageUrl,
//                         isFirst: index == 0,
//                         isLast: index == progressImages.length - 1,
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             if (_image != null)
//               Column(
//                 children: [
//                   Image.file(_image!, height: 200),
//                   ElevatedButton(
//                     onPressed: _uploadProgressImage,
//                     child: Text('Upload Progress Image'),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//       floatingActionButton: AnimatedOpacity(
//         opacity: _isFabVisible ? 1.0 : 0.0,
//         duration: Duration(milliseconds: 300),
//         child: _isFabVisible
//             ? FloatingActionButton.extended(
//                 onPressed: _pickImage,
//                 icon: Icon(Icons.add),
//                 label: Text('Add Progress'),
//                 tooltip: 'Add Progress',
//               )
//             : null,
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(9.0),
//         child: ElevatedButton(
//           onPressed: () {
//             // Confirm journey action
//           },
//           child: Text('Confirm Journey'),
//         ),
//       ),
//     );
//   }
// }

// class DiagnosisCard extends StatelessWidget {
//   final Plant plant;

//   DiagnosisCard({required this.plant});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => DiagnosisScreen()),
//         )
//       },
//       child: Card(
//         margin: EdgeInsets.symmetric(vertical: 10),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.network(
//                   plant.imageUrl,
//                   width: 80,
//                   height: 80,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       plant.diagnosis,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       'Remedies: ${plant.remedies}',
//                       style: TextStyle(
//                         color: Colors.green,
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       'Prevention: ${plant.prevention}',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class JourneyTile extends StatelessWidget {
//   final String title;
//   final String date;
//   final String description;
//   final String imageUrl;
//   final bool isFirst;
//   final bool isLast;

//   JourneyTile({
//     required this.title,
//     required this.date,
//     required this.description,
//     required this.imageUrl,
//     this.isFirst = false,
//     this.isLast = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TimelineTile(
//       alignment: TimelineAlign.manual,
//       lineXY: 0.1,
//       isFirst: isFirst,
//       isLast: isLast,
//       beforeLineStyle: LineStyle(
//         color: Colors.grey,
//         thickness: 2,
//       ),
//       afterLineStyle: LineStyle(
//         color: Colors.grey,
//         thickness: 2,
//       ),
//       indicatorStyle: IndicatorStyle(
//         width: 20,
//         color: Colors.blue,
//         padding: const EdgeInsets.all(6),
//       ),
//       endChild: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundImage: NetworkImage(imageUrl),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     date,
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   Text(
//                     description,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       startChild: Container(
//         width: 50,
//         child: Center(
//           child: Text(
//             date.split(' ')[1],
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
