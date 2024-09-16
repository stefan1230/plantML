import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Plant Care App'),
      ),
      body: CardWidget(),
    ),
  ));
}

class CardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
                'path_to_your_image.jpg'), // Replace with your plant image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'George Gregor',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('12 mins ago', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  Text(
                    'Hi guys, I\'ve got a problem with my plant, when I try to let it be on sun, leaves are moving low and start to dry. Could you tell me please what\'s the problem?',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle Save
                  },
                  child: Text('Save'),
                ),
                TextButton(
                  onPressed: () {
                    // Handle Comment
                  },
                  child: Text('Comment'),
                ),
                TextButton(
                  onPressed: () {
                    // Handle Share
                  },
                  child: Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
